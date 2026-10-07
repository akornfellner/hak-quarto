# Regeln für alle Mathematik-Skripten der HAK/HAS Eferding

Diese Datei gehört zur Extension `hak` (Repo `akornfellner/hak-quarto`) und gilt
für jedes Skript. Die `CLAUDE.md` des Skripts bindet sie ein und ergänzt, was nur
für die jeweilige Klasse gilt. Welche Kapitel und Themen dazukommen, gibt der
Benutzer jeweils vor.

**Pflege:** Neue Regeln oder Vorgaben des Benutzers sofort eintragen:
allgemeine hier (in `../hak-quarto/_extensions/hak/regeln.md`, siehe „Extension“),
klassenspezifische in der `CLAUDE.md` des Skripts.

## Allgemein

- Deutsch (Österreich), auch Kommentare, Dateinamen und Commit-Messages.
- Quarto-Buchprojekt, PDF mit **Typst** (nicht LaTeX).

## Extension

Alles, was alle Klassen gemeinsam haben, liegt im Repo `hak-quarto` (lokal im
Nachbarordner `../hak-quarto`): Design, Filter, Kurzbefehle, Formate, diese
Regeln, die gemeinsamen just-Befehle und der Workflow. Im Skript liegt davon
eine mitcommittete Kopie in `_extensions/hak/`.

- **Nie etwas in `_extensions/` des Skripts bearbeiten.** Die nächste
  Aktualisierung überschreibt es.
- Allgemeine Änderung beim Arbeiten an einer Klasse:
  1. Datei in `../hak-quarto/_extensions/hak/` ändern.
  2. Im Skript `just extension-lokal` (= `quarto add ../hak-quarto --no-prompt`),
     dann rendern und prüfen (`just alles`, bei Verweisen/Workflow `just online`).
  3. In beiden Repos committen. `hak-quarto` erst nach Rückfrage pushen.
- Extension aus GitHub holen (auch ohne lokalen Ordner `hak-quarto`):
  `just extension`, danach rendern und committen.
- Alle Klassen auf einmal: `just alle-aktualisieren` im Ordner `hak-quarto`
  (aktualisiert und rendert jedes `../hak-mam-*`, committet nichts).
- Gehört etwas nur zu einer Klasse, bleibt es im Skript: Zeichnungen in
  `_python/grafiken.py`, Regeln in `CLAUDE.md`, Befehle im `justfile`.
- Fehlt der Ordner `../hak-quarto`, den Benutzer bitten, ihn zu klonen
  (`git clone git@github.com:akornfellner/hak-quarto.git` im Ordner darüber).

## Ausgabeformate

| Format | Zweck | Inhalt |
|---|---|---|
| PDF (`typst`), HTML (`hak-html`) | Skript | vollständig: Erklärungen, Formeln, Beispiele |
| Folien (`hak-revealjs`) | Unterricht | **nur** Formeln und Kernaussagen, **keine** Erklärtexte |

- Alles im selben Quelltext. Erklärtext (auch Einführungsbeispiele) steht in
  `::: {.content-hidden when-format="revealjs"}`. Formeln, Definitionen, Beispiele
  und Merksätze stehen ohne Bedingung. Nur für Folien:
  `::: {.content-visible when-format="revealjs"}`.
- Die Formate heißen `hak-html` und `hak-revealjs` (aus der Extension). Das PDF
  verwendet das normale `typst` mit den Einstellungen aus
  `_extensions/hak/pdf.yml`, weil ein eigenes Format die Buchvorlage
  „orange-book“ verdrängen würde. Nie `--to html` verwenden: Das rendert ohne
  Extension (kein Design, keine Filter).

### Rendern

- Kurzbefehle mit `just` (Übersicht: `just`, braucht just ab 1.19):
  `just preview`, `just folien N`, `just render`, `just render-folien`,
  `just alles`, `just online` usw. Die gemeinsamen Befehle stehen in
  `_extensions/hak/hak.just`, das `justfile` des Skripts bindet sie ein. Neue
  häufige Befehle dort ergänzen (allgemeine in `hak-quarto`, klassenspezifische
  im `justfile` des Skripts) und im README nachtragen.
- Skript: `quarto render` → `_book/`. Folien: `quarto render --profile folien` → `_folien/`.
- Ein Quarto-Buch kann keine revealjs-Folien erzeugen. Deshalb gibt es das Profil
  `_quarto-folien.yml` (Projekttyp `website`, nur `folien-*.qmd` und die
  Übersichtsseite). Der Untertitel der Folien (Fach und Klasse) steht einmal
  dort und gilt für alle Folien und die Übersichtsseite. Folien-Einstellungen,
  die für alle Klassen gelten, gehören ins Format `revealjs` in
  `_extension.yml`, nicht in die Foliendateien.
- Übersichtsseite der Folien: `folien-uebersicht.qmd` → `_folien/index.html`
  (normales HTML). Die Datei im Skript enthält nur den Kopf; Inhalt und Aussehen
  kommen aus der Extension (`_folien-uebersicht.qmd`, `folien-uebersicht.css`).
  Sie findet alle `NN-…/folien-N.qmd` selbst und zeigt Kapitelnummer und `title`
  aus deren YAML-Kopf. Bei neuen Kapiteln ist nichts zu ergänzen.
- Folien-Preview nur mit einer einzelnen Datei:
  `quarto preview 01-zahlen-und-mengen/folien-1.qmd --profile folien`.
- Logo: kommt aus `_brand.yml` der Extension. Quarto kopiert es nach
  `site_libs/quarto-contrib/…` und bindet es mit relativem Pfad ein. Den
  Projekttyp `website` im Folien-Profil nicht ändern.
- Python: Projekt-venv `.venv/`, verwaltet mit **uv** (`pyproject.toml`, `uv.lock`,
  `.python-version` immer mitcommitten). `_environment` setzt
  `QUARTO_PYTHON=.venv/bin/python`, sonst nimmt Quarto einen fremden Kernel.
  - Einrichten / nach `git pull`: `uv sync`
  - Paket fürs Rendern: `uv add paket`, nur als Werkzeug am Rechner: `uv add --dev paket`
  - Nie `pip install` in die `.venv` (entfernt der nächste `uv sync`), nie
    `python3 -m venv` (auf dem Arbeitsrechner fehlt `ensurepip`).
- Neuer Rechner: `git clone …`, `uv sync`, `quarto render`.

### Veröffentlichung

- Bei jedem Push auf `main` veröffentlicht GitHub Actions das Skript (HTML) und
  die Folien auf GitHub Pages: Skript unter `/<repo>/`, Folien unter
  `/<repo>/folien/`. Kein PDF. Die Adressen stehen in der `CLAUDE.md` des Skripts.
- Der Ablauf steht nur in `hak-quarto/.github/workflows/pages.yml`
  (wiederverwendbarer Workflow): `uv sync --locked --no-dev`,
  `quarto render --to hak-html`, `quarto render --profile folien`, `_folien/`
  nach `_book/folien/` kopieren, `_book/` veröffentlichen. Die
  `.github/workflows/pages.yml` des Skripts ruft ihn nur auf (`@main`) und
  vergibt die Rechte. Änderungen am Ablauf deshalb nur in `hak-quarto`; sie
  gelten nach dem Push dort beim nächsten Push jedes Skripts.
- Im Skript führt der Link „Folien“ in der Navigationsleiste (`book: navbar` in
  `_quarto.yml`) zur Übersichtsseite. Er funktioniert nur online bzw. mit
  `just online`.
- Alle Verweise müssen relativ sein (kein führendes `/`), weil die Seite unter
  `/<repo>/` liegt. Vor Änderungen an Workflow, Profil oder Verweisen mit
  `just online` testen: baut `_online/<repo>/` wie der Workflow und liefert es
  unter `http://localhost:8000/<repo>/` aus.
- Quarto- und uv-Version im Workflow = lokale Version (derzeit Quarto 1.10.18,
  uv 0.11.9). Bei einem Update beide anpassen.
- Actions-Versionen vor Änderungen online prüfen, z. B.
  `git ls-remote --tags https://github.com/actions/deploy-pages.git`.

### Folien-Aufteilung

- `slide-level: 4`: `#` bis `###` werden Titel-/Abschnittsfolien, jede `####`
  beginnt eine neue Folie.
- Zu volle Folie: Umbruch, der nur in den Folien wirkt (**nicht** `---`, das hält
  Quarto für YAML):
  ```markdown
  ::: {.content-visible when-format="revealjs"}
  * * *
  :::
  ```
- Pro Folie höchstens Definition + Formel + Abbildung, höchstens eine
  Zahlengerade. Beispiele bei Bedarf auf eine eigene Folie.
- Mehrere Formeln nebeneinander in einer abgesetzten Formel mit `\qquad`
  trennen. Auf den Folien zerlegt `filters/folien-formelzeilen.lua` die Formel an
  jedem `\qquad` und bricht bei Platzmangel dort um (Aussehen in `folien.css`),
  im Skript bleibt alles in einer Zeile. Deshalb keine kleinere Schrift und
  keine händischen Umbrüche. Ist eine einzelne Formel zu breit, sie kürzen oder
  auf zwei Formeln aufteilen.

## Ordner- und Dateistruktur eines Skripts

```
_quarto.yml              Buchprojekt: Titel, Klasse, Kapitelliste, Formate
_quarto-folien.yml       Folien-Profil: Projektteil, Untertitel der Folien
_extensions/hak/         Kopie der Extension (nie direkt bearbeiten)
folien-uebersicht.qmd    Übersichtsseite der Folien (nur Kopf + include)
_python/grafiken.py      Zeichnungen dieser Klasse, importiert den Stil aus
                         _extensions/hak/stil.py
index.qmd                Startseite / Vorwort
NN-kapitelname/          ein Ordner pro Kapitel (01-, 02-, …)
  kapitel-N.qmd          "# Titel" + includes der Unterkapitel
  folien-N.qmd           nur Titel, format: hak-revealjs + dieselben includes
  _N-M-thema.qmd         Unterkapitel N.M, beginnt mit "## Titel"
  _zusammenfassung.qmd, _weitere-aufgaben.qmd, _wissens-check.qmd  ({.unnumbered})
  images/
justfile                 bindet _extensions/hak/hak.just ein (+ Klassenbefehle)
CLAUDE.md                Klasse, Adressen, Einbindung dieser Regeln
```

- Niemals alles in eine Datei schreiben. In `_quarto.yml` nur `kapitel-N.qmd`
  eintragen, Unterkapitel per `{{< include _N-M-thema.qmd >}}` (sonst stimmt die
  Nummerierung 1.1, 1.2, … nicht). Unterkapitel-Dateien beginnen mit `_`.
- Neues Kapitel: Ordner `NN-kapitelname/` mit `kapitel-N.qmd` und `folien-N.qmd`
  anlegen (Kopf der Foliendatei: nur `title` und `format: hak-revealjs`),
  `kapitel-N.qmd` in `_quarto.yml` eintragen.
- Überschriften: `#` Kapitel, `##` Unterkapitel, `###` Thema, `####` Teilthema.
  Nummeriert wird nur bis 1.1. Jede Überschrift bekommt eine ID `{#sec-…}`.
- Dateinamen: Kleinbuchstaben, Bindestriche, keine Umlaute/ß (ä→ae, ß→ss).

## Design

- Design nur in `_brand.yml` der Extension, keine Farben oder Schriften in
  `.qmd`-Dateien. Neue Farben, die im HTML sichtbar sind, mit `light`- und
  `dark`-Variante.
- Schulfarben: Rot `#CE1F2C`, reines Schwarz `#000000`. Schriften: Oswald
  (Überschriften), Lato (Text). Logo `hak-logo.png`, im dunklen HTML-Modus
  `hak-logo-dunkel.png` (beide in der Extension).
- HTML hat hell/dunkel (`cosmo`/`darkly`, jeweils `brand` zuletzt). PDF und Folien
  sind immer hell.

## Inhaltliche Bausteine

- Definitionen: `::: {.callout-note title="Definition: Titel"}`. `callout-note` ist
  **nur** für Definitionen.
- Beispiele: Absatz `**Beispiel:** …` (bei reiner Formel danach Leerzeile + `$$…$$`).
- Merksätze: `callout-important title="Merke"`, Tipps: `callout-tip title="Tipp: …"`.
- Nichts nummerieren außer Abbildungen: keine `#def-`/`#exm-`-Blöcke.
- Schreibweisen als Tabelle mit den Spalten „Schreibweise“ | „Sprechweise“.
- **Übungsbeispiele aus dem Schulbuch** mit dem Kurzbefehl `{{< buch 1.23 1.24ab 1.27 >}}`
  (eigene Zeile, Nummern mit Leerzeichen getrennt, keine Seitenzahlen). Ergibt einen
  Kasten „Übungsbeispiele: 1.23, 1.24ab, 1.27“ im Skript und auf den Folien.
  - Nummern gibt nur der Benutzer vor, nie selbst erfinden. Nennt er sie beim
    Einarbeiten eines Kapitels, den Kasten an die angegebene Stelle setzen (meist
    am Ende des passenden `###`- oder `####`-Abschnitts).
  - Aussehen (in der Extension): HTML/Folien in `buchbeispiele.css` (Farben per
    `var(--bs-primary)` bzw. `var(--brand-hak-rot)` aus `_brand.yml`), PDF in
    `buchbeispiele()` in `typst-anpassungen.typ`, der Kurzbefehl selbst in `buch.lua`.

## Mathematik & Technik

- Formeln in LaTeX-Mathe-Syntax (`$…$`, `$$…$$`). Keine Roh-LaTeX-Blöcke, keine
  eigenen Makros, kein TikZ (geht mit Typst nicht).
- Dezimalkomma als `{,}`, Elemente in Mengen mit Dezimalzahlen durch Strichpunkt
  trennen: `$\{1{,}5;\ 2\}$`. Den Abstand nach dem Komma im PDF entfernt
  `filters/dezimalkomma.lua`.
- Intervalle österreichisch: `$[2; 5]$`, `$]2; 5[$`, `$]-\infty; 5]$`. Einfach so
  schreiben, die Abstände korrigiert `filters/intervallklammern.lua`.
- Deutsche Anführungszeichen „…“ direkt im Text.
- Buch-Titel/-Untertitel nicht mit „1.“ beginnen (Typst macht eine Aufzählung daraus).
- Korrekturen für die PDF-Vorlage „orange-book“ und Mathe stehen in der Extension
  in `typst-anpassungen.typ` und `filters/*.lua` (Zweck jeweils im Dateikopf).
  Neue Korrekturen dort ergänzen, nicht in den `.qmd`-Dateien. Ein neuer Filter
  muss in `_extension.yml` **und** in `pdf.yml` eingetragen werden.

### Grafiken

- **Grafiken mit Python/matplotlib, Code nie sichtbar** (global `echo: false`).
  Handgeschriebene SVG nur, wenn es mit matplotlib nicht sinnvoll geht.
- Pro Unterkapitel einmal eine Zelle mit `#| include: false` und
  `from _python.grafiken import *`. Wiederverwendbare Zeichnungen der Klasse
  (z. B. `zahlengerade()`) in `_python/grafiken.py` des Skripts, einmalige direkt
  in der Zelle. Farben, `rcParams`, `zahl()` und `tausender()` kommen aus
  `stil.py` der Extension.
- Jede Grafik-Zelle hat `#| label: fig-…` und `#| fig-cap: "…"`. Die letzte Zeile
  endet mit `;`, damit keine Textausgabe erscheint. Mathe in `fig-cap` mit doppeltem
  Backslash: `"$\\mathbb{R}$"`.
- Stil: Linien schwarz, Flächen hellrot `#EBA5AB` (hellere Abstufungen erlaubt),
  Markierungen Schulrot, Schrift sans-serif, weißer Hintergrund (lesbar im dunklen
  Modus), Zahlen mit Dezimalkomma und echtem Minus (`zahl()`).
