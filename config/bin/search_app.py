#!/usr/bin/env python3

import configparser
import os
import shutil
import subprocess
import sys
from pathlib import Path

TERMINAL = "kitty"

# Directorios donde buscar aplicaciones .desktop
DESKTOP_DIRS = [
    Path.home() / ".local/share/applications",

    Path.home() / ".local/share/flatpak/exports/share/applications",

    Path("/usr/local/share/applications"),
    Path("/usr/share/applications"),

    Path("/var/lib/flatpak/exports/share/applications"),
]


# Directorios donde buscar binarios
BIN_DIRS = [
    Path.home() / ".local/bin",
    Path("/usr/local/bin"),
    Path("/usr/bin"),
]


def get_desktop_files():
    """
    Busca aplicaciones gráficas a través de sus archivos .desktop.
    Incluye aplicaciones normales y Flatpak.
    """

    applications = {}

    for directory in DESKTOP_DIRS:
        if not directory.is_dir():
            continue

        try:
            desktop_files = directory.rglob("*.desktop")
        except OSError:
            continue

        for desktop_file in desktop_files:
            try:
                parser = configparser.ConfigParser(
                    interpolation=None,
                    strict=False
                )


                with desktop_file.open(
                    encoding="utf-8",
                    errors="ignore"
                ) as f:
                    parser.read_file(f)

                if "Desktop Entry" not in parser:
                    continue

                entry = parser["Desktop Entry"]

                # Solo aplicaciones
                if entry.get("Type", "Application") != "Application":
                    continue

                # Aplicaciones ocultas
                if entry.get("Hidden", "false").lower() == "true":
                    continue

                # Rofi normalmente no muestra estas aplicaciones
                if entry.get("NoDisplay", "false").lower() == "true":
                    continue

                name = entry.get("Name")

                if not name:
                    continue

                desktop_id = desktop_file.name

                applications[desktop_id] = {
                    "name": name,
                    "desktop_id": desktop_id,
                    "path": desktop_file,
                }

            except (
                OSError,
                UnicodeDecodeError,
                configparser.Error,
            ):
                continue

    return applications


def get_binaries():
    """
    Busca ejecutables en los directorios de binarios.
    """

    binaries = {}

    for directory in BIN_DIRS:
        if not directory.is_dir():
            continue

        try:
            for binary in directory.iterdir():

                if not binary.is_file():
                    continue

                if not os.access(binary, os.X_OK):
                    continue

                name = binary.name

                # El primer directorio tiene prioridad.
                if name not in binaries:
                    binaries[name] = binary

        except PermissionError:
            continue

    return binaries


def build_entries() -> list[dict]:
    """
    Construye la lista final de aplicaciones y binarios.
    """

    entries = []

    # -------------------------
    # Aplicaciones gráficas
    # -------------------------

    for app in get_desktop_files().values():
        entries.append({
            "display": app["name"],
            "type": "desktop",
            "target": app["desktop_id"],
        })

    # -------------------------
    # Binarios
    # -------------------------

    for name, path in get_binaries().items():
        entries.append({
            "display": name,
            "type": "binary",
            "target": str(path),
        })

    # -------------------------
    # Eliminar duplicados
    # -------------------------

    unique = {}

    for entry in entries:
        name = entry["display"]

        # Si no existe todavía
        if name not in unique:
            unique[name] = entry
            continue

        # prioridad a la GUI.
        if (unique[name]["type"] == "binary" and entry["type"] == "desktop"):
            unique[name] = entry

    entries = list(unique.values())

    # GUI primero, después binarios.
    entries.sort(key=lambda entry: (
        entry["type"] != "desktop",
        entry["display"].lower(),
        ))

    return entries


def choose(entries: list[dict]):
    """
    Ejecuta fzf y devuelve la entrada seleccionada.
    """

    lines = []

    for index, entry in enumerate(entries):
        if entry["type"] == "desktop":
            tag = "[GUI]"
        else:
            tag = "[BIN]"

        lines.append(f"{index}\t{entry['display']:<45} {tag}")

    try:
        result = subprocess.run([
                "fzf",

                "--height=100%",
                "--layout=reverse",
                "--padding=2",
                "--no-scrollbar",
                "--separator= ",
                "--gutter= ",

                "--info=inline-right",
                "--color=bg+:grey,bg:-1,gutter:grey",
                "--color=fg:-1,info:blue,pointer:magenta",
                "--color=fg+:white,prompt:blue,hl+:blue,hl:blue",

                # Solo una selección
                "--no-multi",

                # El primer campo es nuestro índice
                "--delimiter=\t",

                # Mostrar todo excepto el índice
                "--with-nth=2..",
            ],

            input="\n".join(lines),

            text=True,

            stdout=subprocess.PIPE,

            stderr=None,
        )

    except FileNotFoundError:
        print("Error: fzf no está instalado.", file=sys.stderr)
        sys.exit(1)

    # ESC / Ctrl-C
    if result.returncode != 0:
        return None

    if not result.stdout.strip():
        return None

    selected = result.stdout.rstrip("\n")

    try:
        index = int(
            selected.split("\t", 1)[0]
        )
        return entries[index]

    except ( ValueError, IndexError):
        return None


def launch(entry):
    """
    Ejecuta la aplicación seleccionada.
    """

    # Gui
    if entry["type"] == "desktop":

        desktop_id = entry["target"]

        # gtk-launch permite lanzar tanto
        if shutil.which("gtk-launch"):
            subprocess.Popen(
                ["gtk-launch", desktop_id],
                start_new_session=True,
                stdin=subprocess.DEVNULL,
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
            )

        else:
            print("Error: gtk-launch no está instalado.", file=sys.stderr)
            sys.exit(1)

    # Bin
    elif entry["type"] == "binary":
        subprocess.Popen(
            [TERMINAL, "--hold", entry["target"]],
            start_new_session=True,
            stdin=subprocess.DEVNULL,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )


def main():

    # Comprobar fzf antes de hacer trabajo
    if not shutil.which("fzf"):
        print(
            "Error: fzf no está instalado.",
            file=sys.stderr
        )
        sys.exit(1)


    entries = build_entries()

    if not entries:
        print(
            "No se encontraron aplicaciones ni binarios.",
            file=sys.stderr
        )
        sys.exit(1)

    selected = choose(entries)

    if selected:
        launch(selected)
        exit(0)


if __name__ == "__main__":
    main()
