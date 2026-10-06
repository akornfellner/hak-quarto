# CLAUDE.md – hak-quarto (Extension für die Mathematik-Skripten)

Gemeinsame Technik aller Mathematik-Skripten der HAK/HAS Eferding als
Quarto-Extension `hak`. Die Skripten selbst liegen in eigenen Repos in den
Nachbarordnern `../hak-mam-1`, `../hak-mam-2`, … und enthalten eine Kopie von
`_extensions/hak/`.

Die Regeln für die Skripten (Aufbau, Schreibweisen, Grafiken, Abläufe) stehen in
@_extensions/hak/regeln.md. Sie gelten auch hier, soweit sie passen (Sprache,
Dateinamen, Design).

**Pflege:** Neue Regeln oder Vorgaben des Benutzers sofort eintragen: Regeln für
die Skripten in `_extensions/hak/regeln.md`, Regeln für die Arbeit an diesem
Repo hier.

## Arbeiten an diesem Repo

- Deutsch (Österreich), auch Kommentare, Dateinamen und Commit-Messages. Jede
  Datei hat einen Kopfkommentar mit ihrem Zweck.
- Dieses Repo lässt sich nicht selbst rendern. Jede Änderung in einem Skript
  testen: dort `just extension-lokal`, dann `just alles` (bei Verweisen, Logo
  oder Workflow zusätzlich `just online`). Vor dem Push mit
  `just alle-aktualisieren` alle vorhandenen Skripten prüfen.
- Das Ergebnis muss in allen Skripten gleich aussehen wie vorher, außer die
  Änderung ist genau so gewollt.
- Committen und pushen nur nach Rückfrage. Der Workflow wird von den Skripten
  mit `@main` aufgerufen: Ein Push auf `main` wirkt beim nächsten Push jedes
  Skripts. Alles andere erreicht ein Skript erst, wenn dort die Extension
  aktualisiert und committet wird.
- In den Skripten nichts committen oder pushen, wenn die Aufgabe hier liegt;
  das macht der Benutzer pro Klasse.
- Änderungen an Aufbau, Befehlen oder Abläufen im README nachtragen (Tabelle
  „Ich will … ändern“, Abläufe, Checkliste „Neue Klasse anlegen“).

## Technische Besonderheiten (nicht „aufräumen“)

- `_brand.yml` wirkt nur als Projekt-Metadaten (`contributes: metadata: project:
  brand`), nicht als Einstellung eines Formats.
- Das PDF verwendet das Format `typst` mit `pdf.yml` (über `metadata-files` im
  Skript). Ein Format `hak-typst` würde die Buchvorlage „orange-book“ verdrängen.
  Pfade in `pdf.yml` gelten ab dem Projektordner des Skripts
  (`_extensions/hak/…`), Pfade in `_extension.yml` ab dem Extension-Ordner.
- Sprache, Python-Einstellungen, Kurzbefehle und Filter stehen deshalb doppelt:
  in `_extension.yml` (`common`) und in `pdf.yml`. Immer beide ändern.
- Reihenfolge der Filter: `dezimalkomma.lua` muss nach `intervallklammern.lua`
  laufen.
- `quarto render --to html` rendert ohne Extension. Überall `hak-html`.
- `hak.just` braucht just ab 1.19 (`import`). Der Repo-Name für `just online`
  kommt aus dem Ordnernamen des Skripts.
- Workflow: Quarto- und uv-Version = lokale Version (derzeit Quarto 1.10.18,
  uv 0.11.9). Actions-Versionen vor Änderungen online prüfen, z. B.
  `git ls-remote --tags https://github.com/actions/deploy-pages.git`.
- `just extension` klont das Repo und ruft `quarto add` mit dem lokalen Ordner
  auf. `quarto add akornfellner/hak-quarto` würde nach
  `_extensions/akornfellner/hak/` installieren, die Skripten erwarten aber
  `_extensions/hak/`.
- Neue Datei in `_extensions/hak/`: `quarto add` kopiert den ganzen Ordner, es
  ist nichts einzutragen.
