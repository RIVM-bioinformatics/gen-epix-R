"""Generate one R constructor per composed Gen-EpiX CRUD command.

Run from any directory with ``python tools/generate_crud_commands.py``. The
backend checkout is only needed while regenerating the package sources.
"""

from __future__ import annotations

import argparse
import csv
import json
import re
import subprocess
from collections import Counter
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
APPS = ("commondb", "casedb", "seqdb", "omopdb")
OPERATIONS = {
    ("", "GET"): "read_all",
    ("", "POST"): "create_one",
    ("", "DELETE"): "delete_all",
    ("/batch", "GET"): "read_some",
    ("/batch", "POST"): "create_some",
    ("/batch", "PUT"): "update_some",
    ("/batch", "DELETE"): "delete_some",
    ("/query", "POST"): "read_query",
    ("/query/ids", "POST"): "read_query_ids",
    ("/{object_id}", "GET"): "read_one",
    ("/{object_id}", "PUT"): "update_one",
    ("/{object_id}", "DELETE"): "delete_one",
}
ROUTE_ORDER = tuple(OPERATIONS.values())
PROBE = r'''
import contextlib
import importlib
import io
import json

from gen_epix.commondb.domain.util import set_env_variables
from gen_epix.commondb.domain.enum import DevIdpConfig, DevRepositoryConfig
from gen_epix.fastapp.api.crud_endpoint_set import CrudEndpointSet

app_name = __import__("sys").argv[1]
set_env_variables(app_name, DevIdpConfig.MOCK, DevRepositoryConfig.DICT_EMPTY)
with contextlib.redirect_stdout(io.StringIO()):
    fast_api = importlib.import_module(f"gen_epix.{app_name}.app").FAST_API
    schema = fast_api.openapi()

rows = []
for api_route in fast_api.routes:
    endpoint = getattr(api_route, "endpoint", None)
    code = getattr(endpoint, "__code__", None)
    if code is None:
        continue
    cells = dict(zip(code.co_freevars, endpoint.__closure__ or ()))
    route_cell = cells.get("route")
    route_set = route_cell.cell_contents if route_cell else None
    if not isinstance(route_set, CrudEndpointSet):
        continue
    path = api_route.path
    method = next(iter(api_route.methods))
    assert method.lower() in schema["paths"][path]
    assert schema["paths"][path][method.lower()]["operationId"] == api_route.operation_id
    rows.append({
        "app": app_name,
        "command": route_set.crud_command_class.__name__,
        "endpoint": route_set.endpoint_basename,
        "id_field": route_set.model_class.ENTITY.id_field_name,
        "method": method,
        "path": path,
    })
print("CRUD_ROUTES_JSON=" + json.dumps(rows, sort_keys=True))
'''


def read_backend_routes(api_root: Path) -> list[dict[str, str]]:
    python = api_root / ".venv" / "bin" / "python"
    if not python.is_file():
        raise SystemExit(f"Backend virtual environment missing: {python}")
    commands: dict[tuple[str, str], dict[str, str | set[str]]] = {}
    for app in APPS:
        result = subprocess.run(
            [str(python), "-c", PROBE, app],
            cwd=api_root,
            text=True,
            capture_output=True,
            check=True,
        )
        marker = "CRUD_ROUTES_JSON="
        output = next(
            (line[len(marker) :] for line in result.stdout.splitlines() if line.startswith(marker)),
            None,
        )
        if output is None:
            raise RuntimeError(f"No CRUD route data from {app}: {result.stdout}")
        for route in json.loads(output):
            base = "/v1/" + route.pop("endpoint")
            if not route["path"].startswith(base):
                raise ValueError(f"Unexpected CRUD path: {route}")
            suffix = route["path"][len(base) :]
            try:
                route["operation"] = OPERATIONS[(suffix, route["method"])]
            except KeyError as error:
                raise ValueError(f"Unknown CRUD endpoint shape: {route}") from error
            command = route["command"]
            if not command.endswith("CrudCommand"):
                raise ValueError(f"Unknown CRUD command: {command}")
            stem = command[: -len("CrudCommand")]
            entity = re.sub(r"(?<!^)(?=[A-Z])", "_", stem).lower()
            key = (app, command)
            if key not in commands:
                commands[key] = {
                    "app": app,
                    "command": command,
                    "entity": entity,
                    "function": f"{app}_{entity}_crud_command",
                    "path": base,
                    "id_field": route["id_field"],
                    "routes": set(),
                }
            entry = commands[key]
            if entry["path"] != base or entry["id_field"] != route["id_field"]:
                raise ValueError(f"Inconsistent route metadata for {key}")
            assert isinstance(entry["routes"], set)
            entry["routes"].add(route["operation"])
    rows = []
    for entry in commands.values():
        rows.append({
            **entry,
            "routes": ";".join(x for x in ROUTE_ORDER if x in entry["routes"]),
        })
    rows.sort(key=lambda row: (APPS.index(row["app"]), row["entity"]))
    duplicates = [name for name, count in Counter(row["function"] for row in rows).items() if count > 1]
    if duplicates:
        raise ValueError(f"Duplicate R function names: {duplicates}")
    return rows


def render_function(route: dict[str, str]) -> str:
    name = route["function"]
    routes = ", ".join(f'"{x}"' for x in route["routes"].split(";"))
    return (
        f"{name} <- make_crud_command_constructor(\n"
        f'    "{route["app"]}", "{route["command"]}", '
        f'"{route["path"]}", "{route["id_field"]}",\n'
        f"    c({routes})\n"
        ")\n"
    )


def render_rd(app: str, rows: list[dict[str, str]]) -> str:
    app_rows = [row for row in rows if row["app"] == app]
    aliases = "".join(f"\\alias{{{row['function']}}}\n" for row in app_rows)
    usage = "\n".join(
        f"{row['function']}(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)"
        for row in app_rows
    )
    return (
        f"\\name{{{app}-crud-commands}}\n"
        + aliases
        + f"\\title{{{app.upper()} CRUD commands}}\n"
        + "\\description{Construct CRUD commands for entities exposed by the named Gen-EpiX application. Pass the result to \\code{execute_crud_command()} to send a request.}\n"
        + f"\\usage{{\n{usage}\n}}\n"
        + "\\arguments{\n"
        + "  \\item{operation}{API CRUD operation, such as \\code{READ_ONE} or \\code{CREATE_SOME}.}\n"
        + "  \\item{obj_ids}{One ID for read/delete-one, or a character vector for read/delete-some.}\n"
        + "  \\item{objs}{A named object list for create/update-one, or a list of objects for create/update-some. UPDATE_ONE requires the entity's ID field.}\n"
        + "  \\item{query_filter}{Optional Gen-EpiX filter as a named R list for READ_ALL.}\n"
        + "  \\item{return_id}{Return matching IDs for a filtered READ_ALL request.}\n"
        + "  \\item{limit}{Optional limit for READ_ALL or DELETE_ALL.}\n"
        + "  \\item{offset}{Optional offset for READ_ALL or DELETE_ALL.}\n"
        + "}\n"
        + "\\value{A \\code{genepix_crud_command} object.}\n"
    )


def write_outputs(api_root: Path, rows: list[dict[str, str]]) -> None:
    revision = subprocess.run(
        ["git", "rev-parse", "HEAD"],
        cwd=api_root,
        text=True,
        capture_output=True,
        check=True,
    ).stdout.strip()
    catalog_path = ROOT / "inst" / "extdata" / "crud-commands.csv"
    catalog_path.parent.mkdir(parents=True, exist_ok=True)
    with catalog_path.open("w", newline="", encoding="utf-8") as file:
        writer = csv.DictWriter(
            file,
            fieldnames=("app", "command", "entity", "function", "path", "id_field", "routes"),
            lineterminator="\n",
        )
        writer.writeheader()
        writer.writerows(rows)
    (catalog_path.parent / "crud-api-revision.txt").write_text(revision + "\n", encoding="utf-8")
    generated = "# Generated by tools/generate_crud_commands.py; do not edit by hand.\n\n"
    generated += "\n".join(render_function(row) for row in rows)
    (ROOT / "R" / "crud-commands-generated.R").write_text(generated, encoding="utf-8")
    namespace_path = ROOT / "NAMESPACE"
    namespace = namespace_path.read_text(encoding="utf-8")
    marker = "# Generated CRUD exports"
    namespace = namespace.split(marker)[0].rstrip() + "\n\n" + marker + "\n"
    namespace += "export(execute_crud_command)\n"
    namespace += "".join(f"export({row['function']})\n" for row in rows)
    namespace_path.write_text(namespace, encoding="utf-8")
    for app in APPS:
        (ROOT / "man" / f"{app}-crud-commands.Rd").write_text(render_rd(app, rows), encoding="utf-8")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--api-root", type=Path, default=ROOT.parent / "gen-epix-api")
    args = parser.parse_args()
    api_root = args.api_root.resolve()
    rows = read_backend_routes(api_root)
    write_outputs(api_root, rows)
    counts = Counter(row["app"] for row in rows)
    print("Generated", len(rows), "CRUD command constructors:", dict(counts))


if __name__ == "__main__":
    main()
