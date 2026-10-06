# hak-quarto

Gemeinsame Technik für die Mathematik-Skripten der HAK/HAS Eferding, verpackt als
[Quarto](https://quarto.org)-Extension `hak`.

Für jede Klasse gibt es ein eigenes Skript-Repo (`hak-mam-1`, `hak-mam-2`, …) mit
eigener Webseite. Alles, was in allen Klassen gleich ist, wird nur hier gepflegt:
Design, Filter, Kurzbefehle, Formate, Regeln für Claude, just-Befehle und der
Ablauf der Veröffentlichung.

## So hängt alles zusammen

```
~/Dokumente/Skript/
  hak-quarto/        dieses Repo: Technik für alle Klassen
  hak-mam-1/         Skript 1. Klasse
  hak-mam-2/ …       weitere Klassen
```

- In jedem Skript liegt im Ordner `_extensions/hak/` eine **Kopie** der Extension.
  Sie ist mitcommittet, damit das Skript auch ohne dieses Repo rendert (auf
  GitHub, auf einem neuen Rechner).
- Geändert wird immer **hier** in `hak-quarto`. Danach wird die Kopie im Skript
  aktualisiert (ein Befehl) und dort committet. Solange das nicht passiert,
  bleibt ein Skript auf seinem alten Stand. Es kann also nichts „von selbst“
  kaputtgehen.
- Einzige Ausnahme ist der Ablauf der Veröffentlichung (Workflow): Den holen
  sich die Skripten bei jedem Push direkt von hier (siehe unten).

Voraussetzungen auf jedem Rechner: [Quarto](https://quarto.org/docs/get-started/)
≥ 1.10, [uv](https://docs.astral.sh/uv/), [just](https://just.systems) ≥ 1.19
(`cargo install just` oder `uv tool install rust-just`), git.

## Wo liegt was

### In `hak-quarto`

| Datei / Ordner | Zweck |
|---|---|
| `README.md` | diese Anleitung |
| `CLAUDE.md` | Regeln für Claude bei der Arbeit an diesem Repo |
| `justfile` | Befehle für dieses Repo, vor allem `just alle-aktualisieren` |
| `.github/workflows/pages.yml` | Ablauf der Veröffentlichung für alle Skripten; hier stehen die Quarto- und die uv-Version |
| `LICENSE`, `.gitignore` | Lizenz, von Git ignorierte Dateien |
| `_extensions/hak/` | die Extension: Dieser Ordner wird in die Skripten kopiert |

In `_extensions/hak/`:

| Datei / Ordner | Zweck |
|---|---|
| `_extension.yml` | Beschreibung der Extension: Formate `hak-html` (Webseite) und `hak-revealjs` (Folien) mit allen Einstellungen, Filtern und Kurzbefehlen |
| `pdf.yml` | dieselben Einstellungen für das PDF (Papierformat, Inhaltsverzeichnis, Filter) |
| `_brand.yml` | Design: Schulfarben, Schriften, Logos (hell/dunkel) |
| `hak-logo.png`, `hak-logo-dunkel.png` | Logo für hellen und dunklen Modus |
| `filters/dezimalkomma.lua` | Dezimalkomma im PDF ohne Abstand |
| `filters/intervallklammern.lua` | Intervalle wie `]2; 5[` richtig setzen |
| `filters/deutsche-anfuehrungszeichen.lua` | „…“ in allen Formaten |
| `filters/pdf-nummerierung.lua` | im PDF nur bis 1.1 nummerieren |
| `buch.lua` | Kurzbefehl `{{< buch 1.23 1.24 >}}` für Übungsbeispiele |
| `buchbeispiele.css` | Aussehen der Übungsbeispiel-Kästen in HTML und Folien |
| `typst-anpassungen.typ` | Anpassungen der PDF-Vorlage, Kasten für Übungsbeispiele im PDF |
| `_folien-uebersicht.qmd` | Inhalt der Übersichtsseite der Folien (sucht die Kapitel selbst) |
| `folien-uebersicht.css` | Aussehen der Übersichtsseite |
| `stil.py` | Stil der Grafiken: Farben, Schrift, `zahl()`, `tausender()` |
| `regeln.md` | Regeln für Claude, die für alle Klassen gelten |
| `hak.just` | just-Befehle für alle Skripten (`just preview`, `just online`, …) |

### In einem Skript (z. B. `hak-mam-1`)

| Datei / Ordner | Zweck |
|---|---|
| `_extensions/hak/` | Kopie der Extension. **Nie direkt bearbeiten.** |
| `_quarto.yml` | Titel, Klasse, Kapitelliste, Link „Folien“ |
| `_quarto-folien.yml` | Einstellungen für die Folien, Untertitel der Folien (Fach und Klasse) |
| `folien-uebersicht.qmd` | Übersichtsseite der Folien (nur Kopf, Inhalt kommt aus der Extension) |
| `index.qmd` | Vorwort |
| `NN-kapitelname/` | ein Ordner pro Kapitel: `kapitel-N.qmd`, `folien-N.qmd`, Unterkapitel `_N-M-thema.qmd`, `images/` |
| `_python/grafiken.py` | Zeichnungen dieser Klasse (holt den Stil aus `stil.py`) |
| `CLAUDE.md` | Klasse, Adressen, Regeln nur für diese Klasse; bindet `regeln.md` ein |
| `justfile` | bindet `hak.just` ein; Platz für Befehle nur dieser Klasse |
| `.github/workflows/pages.yml` | wenige Zeilen: ruft bei jedem Push den Workflow aus `hak-quarto` auf |
| `.claude/settings.json` | erlaubt Claude den Zugriff auf `../hak-quarto` |
| `pyproject.toml`, `uv.lock`, `.python-version` | Python-Pakete für die Grafiken |
| `_environment` | sagt Quarto, welches Python es nehmen soll |
| `.gitignore`, `README.md`, `LICENSE` | wie üblich |

## Ich will … ändern

„Extension übernehmen“ heißt: im Skript `just extension-lokal`, mit `just alles`
ansehen, dann in `hak-quarto` **und** im Skript committen und pushen (genau:
Ablauf A unten).

| Ich will … ändern | Wo | Danach |
|---|---|---|
| Farbe, Schrift, Logo | `hak-quarto/_extensions/hak/_brand.yml` (Logo: die PNG-Dateien daneben ersetzen) | Extension übernehmen |
| Aussehen der Übungsbeispiel-Kästen | HTML/Folien: `buchbeispiele.css`, PDF: `buchbeispiele()` in `typst-anpassungen.typ`, Text/Symbol: `buch.lua` (alle in `hak-quarto/_extensions/hak/`) | Extension übernehmen |
| Filter (Dezimalkomma, Intervalle, Anführungszeichen) | `hak-quarto/_extensions/hak/filters/` | Extension übernehmen. Neuer Filter: zusätzlich in `_extension.yml` **und** `pdf.yml` eintragen |
| PDF-Vorlage (Schrift, Abstände, Papier, Inhaltsverzeichnis) | `typst-anpassungen.typ` bzw. `pdf.yml` in `hak-quarto/_extensions/hak/` | Extension übernehmen |
| Folien-Einstellungen für alle Klassen | Abschnitt `revealjs` in `hak-quarto/_extensions/hak/_extension.yml` | Extension übernehmen |
| Untertitel der Folien einer Klasse | `_quarto-folien.yml` im Skript | committen, pushen |
| Folien-Übersichtsseite | Inhalt: `_folien-uebersicht.qmd`, Aussehen: `folien-uebersicht.css` (in `hak-quarto/_extensions/hak/`) | Extension übernehmen, mit `just online` ansehen |
| Grafikstil (Farben, Schriftgröße, Zahlenformat) | `hak-quarto/_extensions/hak/stil.py` | Extension übernehmen |
| neue Zeichnung für eine Klasse | `_python/grafiken.py` im Skript | committen, pushen |
| Regel für Claude, alle Klassen | `hak-quarto/_extensions/hak/regeln.md` | Extension übernehmen |
| Regel für Claude, nur eine Klasse | `CLAUDE.md` im Skript | committen, pushen |
| just-Befehl für alle Klassen | `hak-quarto/_extensions/hak/hak.just` | Extension übernehmen, Befehl im README des Skripts nachtragen |
| just-Befehl nur für eine Klasse | `justfile` im Skript, unter der `import`-Zeile | committen, pushen |
| Workflow, Quarto- oder uv-Version | `hak-quarto/.github/workflows/pages.yml` | nur `hak-quarto` committen und pushen. Gilt ab dem nächsten Push jedes Skripts (Ablauf D) |
| Python-Paket | im Skript: `uv add paket` | `pyproject.toml` und `uv.lock` committen, pushen (pro Skript) |
| neues Kapitel | im Skript: Ordner `NN-name/` mit `kapitel-N.qmd` und `folien-N.qmd`, Eintrag in `_quarto.yml` | committen, pushen. Die Übersichtsseite findet es selbst |
| Titel, Klasse | im Skript: `_quarto.yml` (Titel, Untertitel), `_quarto-folien.yml` (Untertitel der Folien) | committen, pushen |

## Abläufe

### A. Etwas Allgemeines ändern, testen und übernehmen

```bash
# 1. Datei in hak-quarto ändern (nie in _extensions/ des Skripts)

# 2. Im Skript testen
cd ~/Dokumente/Skript/hak-mam-1
just extension-lokal      # kopiert ../hak-quarto/_extensions/hak ins Skript
just alles                # HTML, PDF und Folien rendern und ansehen
just online               # nur bei Änderungen an Verweisen, Logo oder Workflow

# 3. Extension committen und pushen
cd ~/Dokumente/Skript/hak-quarto
git add -A
git commit -m "Was sich geändert hat"
git push

# 4. Skript committen und pushen (damit ist die Änderung online)
cd ~/Dokumente/Skript/hak-mam-1
git add -A
git commit -m "Extension aktualisiert: was sich geändert hat"
git push
```

Passt das Ergebnis in Schritt 2 nicht: Datei in `hak-quarto` nachbessern und
`just extension-lokal` wiederholen. Soll alles zurück: in `hak-quarto` die
Änderung verwerfen und noch einmal `just extension-lokal`.

### B. Eine andere Klasse aktualisieren

Holt den Stand von GitHub, braucht also keinen Ordner `hak-quarto`:

```bash
cd ~/Dokumente/Skript/hak-mam-2
git pull
just extension            # holt akornfellner/hak-quarto von GitHub
just alles                # rendern und ansehen
git add -A
git commit -m "Extension aktualisiert"
git push
```

### C. Alle Klassen auf einmal aktualisieren

```bash
cd ~/Dokumente/Skript/hak-quarto
just alle-aktualisieren
```

Der Befehl geht durch alle Nachbarordner `../hak-mam-*`, kopiert die Extension
aus diesem Ordner hinein und rendert HTML, PDF und Folien. Am Ende steht eine
Übersicht: `OK`, `FEHLER` oder `ÜBERSPRUNGEN`. Übersprungen wird ein Skript,
in dem noch nicht committete Änderungen liegen (zuerst dort committen).

Es wird **nichts committet und nichts gepusht**. Danach in jedem Skript mit
`OK` das Ergebnis ansehen und wie in Ablauf B committen und pushen.

### D. Workflow ändern (z. B. neue Quarto-Version)

1. Quarto bzw. uv lokal aktualisieren und in einem Skript mit `just online` testen.
2. Version in `hak-quarto/.github/workflows/pages.yml` eintragen, committen, pushen.
3. Ab dem nächsten Push jedes Skripts gilt der neue Ablauf. Sofort auslösen:
   auf GitHub im Skript-Repo unter *Actions* den Workflow wählen und
   *Run workflow* drücken.

In den Skripten ist dafür nichts zu ändern. Achtung: Ein Fehler im Workflow
trifft alle Skripten. Die bisherige Webseite bleibt dann einfach online, bis der
Fehler hier behoben ist.

### E. Neue Klasse anlegen (Checkliste)

Ausgangspunkt ist das neueste Skript. Beispiel: aus `hak-mam-1` wird `hak-mam-2`.

1. Auf GitHub ein leeres, öffentliches Repo `hak-mam-2` anlegen (ohne README).
2. Kopie mit neuer Git-Historie anlegen:
   ```bash
   cd ~/Dokumente/Skript
   git clone git@github.com:akornfellner/hak-mam-1.git hak-mam-2
   cd hak-mam-2
   rm -rf .git
   git init -b main
   git remote add origin git@github.com:akornfellner/hak-mam-2.git
   ```
   Der Ordner muss so heißen wie das Repo (`just online` verwendet den Ordnernamen).
3. Inhalt der alten Klasse entfernen:
   - alle Kapitelordner `NN-…/` löschen,
   - in `_quarto.yml` die Kapitelliste bis auf `index.qmd` leeren,
   - `_python/grafiken.py` auf den Stil-Import kürzen (alles ab der ersten
     `def …` löschen),
   - Dateien löschen, die nur zur alten Klasse gehören (z. B. `extension-umbau.md`).
4. Klasse und Repo-Name anpassen. Das sind alle Stellen:
   - `_quarto.yml`: `subtitle`
   - `_quarto-folien.yml`: `subtitle`
   - `index.qmd`: Text des Vorworts
   - `CLAUDE.md`: Klasse, Repo-Name, Adressen, Abschnitt „Nur in dieser Klasse“
   - `README.md`: Titel, Klasse, Inhalt, Adressen
   - `pyproject.toml`: `name` und `description`
5. Extension auf den neuesten Stand bringen und Python einrichten:
   ```bash
   just extension
   uv sync          # passt auch uv.lock an den neuen Namen an
   ```
6. Erstes Kapitel anlegen (`01-…/kapitel-1.qmd`, `folien-1.qmd`), in
   `_quarto.yml` eintragen.
7. Testen: `just alles`, dann `just online` und
   <http://localhost:8000/hak-mam-2/> ansehen (Skript, Link „Folien“,
   Übersichtsseite, Folien mit Logo).
8. Committen und pushen:
   ```bash
   git add -A
   git commit -m "Skript 2. Klasse angelegt"
   git push -u origin main
   ```
9. Auf GitHub im neuen Repo:
   - *Settings → Pages → Build and deployment → Source:* „GitHub Actions“,
     danach unter *Actions* den Workflow noch einmal starten (*Run workflow*),
     falls der erste Lauf vor dem Einschalten fehlgeschlagen ist,
   - Topic `mathe-skript` setzen (Zahnrad neben „About“),
   - Repo am Profil anheften (*Customize your pins*).
10. Seite prüfen: `https://akornfellner.github.io/hak-mam-2/`.

### F. Neuer Rechner

```bash
# Werkzeuge installieren: Quarto, uv, just (ab 1.19), git
mkdir -p ~/Dokumente/Skript && cd ~/Dokumente/Skript
git clone git@github.com:akornfellner/hak-quarto.git     # nur nötig, wenn Allgemeines geändert wird
git clone git@github.com:akornfellner/hak-mam-1.git
cd hak-mam-1
uv sync
just alles
```

## Was man nie tun darf

- **Nie Dateien in `_extensions/` eines Skripts bearbeiten.** Die nächste
  Aktualisierung überschreibt sie ohne Rückfrage. Immer in `hak-quarto` ändern.
- **Nie `quarto render --to html`.** Das rendert ohne Extension (kein Design,
  keine Filter). Richtig: `just render` bzw. `quarto render --to hak-html`.
- **Den Ordner `_extensions/` nicht löschen und nicht in `.gitignore` setzen.**
  Er muss mitcommittet sein, sonst kann GitHub das Skript nicht rendern.
- **In `_quarto.yml` beim PDF `typst` stehen lassen** (nicht `hak-typst`) und
  die Zeile `metadata-files` nicht entfernen. Sonst verliert das PDF Vorlage
  oder Einstellungen.
- **Im Folien-Profil den Projekttyp `website` nicht ändern.** Sonst fehlt
  online das Logo auf den Folien.
- **Keine Verweise mit führendem `/`** (z. B. `/bild.png`). Die Seiten liegen
  online in einem Unterordner.
- **Einen neuen Filter nicht nur an einer Stelle eintragen.** Er gehört in
  `_extension.yml` (HTML, Folien) und in `pdf.yml` (PDF).
- **Die Extension nicht mit `quarto add akornfellner/hak-quarto` holen.** Das
  legt eine zweite Kopie in `_extensions/akornfellner/` an. Immer
  `just extension` oder `just extension-lokal`.
- **Kein `git reset --hard` und kein `git push --force`.** Zurück geht es immer
  mit `git revert` (siehe unten).
- **Dieses Repo nicht umbenennen oder privat schalten.** Die Skripten holen
  Workflow und Extension unter `akornfellner/hak-quarto`.

## Zurück zu einem früheren Stand

Eine einzelne Änderung an der Extension zurücknehmen:

```bash
cd ~/Dokumente/Skript/hak-quarto
git log --oneline            # Nummer des fehlerhaften Commits suchen
git revert <nummer>
git push
```

Danach die Skripten wie in Ablauf B oder C aktualisieren.

Rückfallpunkt von `hak-mam-1` vor dem Umbau auf diese Extension (Tag
`vor-extension-umbau`):

```bash
cd ~/Dokumente/Skript/hak-mam-1
git revert --no-commit vor-extension-umbau..HEAD
git commit -m "Zurück zum Stand vor dem Extension-Umbau"
git push
```

Das stellt alle Dateien so her, wie sie vor dem Umbau waren (samt eigenem
Workflow), ohne die Geschichte zu löschen. Kapitel, die seit dem Umbau
dazugekommen sind, wären damit auch weg. Dann besser gezielt nur die
Umbau-Commits zurücknehmen.

## Was vom ursprünglichen Plan abweicht

- **Kein Format `hak-typst`.** Quarto setzt die Buchvorlage „orange-book“ nur
  beim reinen Format `typst` ein. Ein eigenes Format hätte sie verdrängt
  (anderes Titelblatt, 21 statt 25 Seiten). Das PDF verwendet deshalb `typst`
  und holt seine Einstellungen über `metadata-files` aus `pdf.yml`. Folge:
  Sprache, Python-Einstellungen, Kurzbefehle und Filter stehen in der Extension
  zweimal (`_extension.yml` und `pdf.yml`).
- **`_brand.yml` ist keine Format-Einstellung**, sondern wird von der Extension
  als Projekt-Einstellung geliefert. Nur so wirkt sie in HTML, PDF und Folien.
- **Logo und CSS liegen online an einer anderen Stelle** (`site_libs/quarto-contrib/…`
  statt im Hauptordner). Quarto kopiert sie selbst dorthin, die Zeile
  `resources: /hak-logo.png` im Folien-Profil ist entfallen. Zu sehen ist davon
  nichts.
- **HTML wird mit `--to hak-html` gerendert** statt `--to html` (im Workflow
  und in den just-Befehlen).
- **just musste aktualisiert werden** (1.13 → 1.58): Das Einbinden von
  `hak.just` gibt es erst ab just 1.19.
- **Der Repo-Name für `just online` kommt aus dem Ordnernamen** und steht in
  keiner Datei mehr.
