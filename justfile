# Befehle für das Extension-Repo. Übersicht: just
# (Die Befehle für die Skripten stehen in _extensions/hak/hak.just.)

default:
  @just --list

# Alle Skripten ../hak-mam-* auf diesen Stand der Extension bringen und rendern (ohne Commit)
alle-aktualisieren:
  #!/usr/bin/env bash
  # Geht durch alle Nachbarordner ../hak-mam-*, übernimmt dort die Extension aus
  # diesem Ordner und rendert zur Kontrolle HTML, PDF und Folien. Skripten mit
  # nicht committeten Änderungen werden übersprungen. Es wird nichts committet
  # und nichts gepusht.
  set -u
  quelle="$(pwd)"
  uebersicht=()
  for skript in ../hak-mam-*/; do
    [ -f "$skript/_quarto.yml" ] || continue
    name="$(basename "$skript")"
    if [ -n "$(git -C "$skript" status --porcelain)" ]; then
      uebersicht+=("ÜBERSPRUNGEN  $name  (nicht committete Änderungen)")
      continue
    fi
    echo
    echo "=== $name ==="
    if (cd "$skript" && quarto add "$quelle" --no-prompt && just alles); then
      uebersicht+=("OK            $name")
    else
      uebersicht+=("FEHLER        $name  (Ausgabe oben prüfen)")
    fi
  done
  echo
  echo "=== Übersicht ==="
  if [ ${#uebersicht[@]} -eq 0 ]; then
    echo "Kein Skript ../hak-mam-* gefunden."
  else
    printf '%s\n' "${uebersicht[@]}"
    echo
    echo "Nichts wurde committet. Pro Skript prüfen (git status, git diff), dann committen und pushen."
  fi
