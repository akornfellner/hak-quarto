# Gemeinsame Befehle für alle Skripten (braucht just ab 1.19).
# Wird im justfile des Skripts eingebunden:
#   import '_extensions/hak/hak.just'
# Die Befehle laufen im Ordner des Skripts. Übersicht: just
#
# Der Befehl "default" (Übersicht) steht im justfile des Skripts: just nimmt als
# Standardbefehl nur einen Befehl aus dem justfile selbst, keinen eingebundenen.

# Name des Repos, bestimmt die Adresse der Online-Version (/hak-mam-1/).
# Vorgabe ist der Ordnername; bei abweichendem Ordner: just repo=hak-mam-1 online
repo := file_name(justfile_directory())

# Python-Umgebung einrichten (einmalig / nach git pull)
sync:
  uv sync

# (--render hak-html: vorher alles neu rendern, sonst fehlen Änderungen in _N-M-*.qmd)
# Live-Vorschau des Skripts (HTML) im Browser
preview:
  uv run quarto preview --render hak-html

# Live-Vorschau des Skripts als PDF
preview-pdf:
  uv run quarto preview --to typst --render typst

# Live-Vorschau der Folien eines Kapitels: just folien 1
folien n:
  uv run quarto preview "$(ls [0-9]*/folien-{{n}}.qmd)" --profile folien

# Skript als HTML und PDF nach _book/ rendern
render:
  uv run quarto render

# Nur das PDF des Skripts erzeugen
pdf:
  uv run quarto render --to typst

# Alle Folien nach _folien/ rendern
render-folien:
  uv run quarto render --profile folien

# Skript und Folien rendern
alles: render render-folien

# Skript (HTML) und Folien so zusammenbauen wie auf GitHub Pages → _online/<repo>/
online-bauen:
  uv run quarto render --to hak-html
  uv run quarto render --profile folien
  rm -rf _online
  mkdir -p _online/{{repo}}/folien
  cp -r _book/. _online/{{repo}}/
  cp -r _folien/. _online/{{repo}}/folien/

# Online-Version lokal testen: http://localhost:8000/<repo>/
online: online-bauen
  @echo "Online-Version: http://localhost:8000/{{repo}}/"
  uv run python -m http.server 8000 --directory _online

# Extension (Design, Filter, Regeln, Befehle) von GitHub aktualisieren
extension:
  #!/usr/bin/env bash
  # Holt den Stand von GitHub in einen temporären Ordner und übernimmt ihn von
  # dort. Direkt mit "quarto add akornfellner/hak-quarto" landete die Extension
  # in _extensions/akornfellner/hak/ statt in _extensions/hak/.
  set -euo pipefail
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  git clone --quiet --depth 1 https://github.com/akornfellner/hak-quarto.git "$tmp/hak-quarto"
  quarto add "$tmp/hak-quarto" --no-prompt

# Extension aus dem Nachbarordner ../hak-quarto übernehmen (zum Testen von Änderungen)
extension-lokal:
  quarto add ../hak-quarto --no-prompt

# Erzeugte Dateien löschen (_book/, _folien/, _online/, .quarto/)
aufraeumen:
  rm -rf _book _folien _online .quarto
