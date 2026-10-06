// Anpassungen der Buchvorlage "orange-book" für das PDF
// (wird über pdf.yml nach book.with() eingebunden und überschreibt deren Einstellungen)

// Fließtextschrift aus _brand.yml (orange-book übernimmt sie nicht automatisch)
#set text(font: "Lato")

// Kein Einzug in der ersten Zeile, dafür Abstand zwischen Absätzen
#set par(first-line-indent: 0em, spacing: 1em)

// Formeln nicht nummerieren
#set math.equation(numbering: none)

// Kasten für Buchbeispiele ({{< buch … >}}, siehe buch.lua)
#let buchbeispiele(nummern) = {
  let farbe = brand-color.primary
  block(
    width: 100%,
    inset: (x: 0.9em, y: 0.6em),
    radius: 3pt,
    fill: farbe.lighten(90%),
    stroke: (left: 3pt + farbe),
  )[#text(fill: farbe)[#fa-book-open() *Übungsbeispiele:*] #nummern]
}
