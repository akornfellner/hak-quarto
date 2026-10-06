-- Dezimalkomma {,} im PDF ohne Abstand setzen: 4,5 statt 4, 5.
--
-- Typst setzt nach jedem Komma in einer Formel einen Abstand wie nach einem
-- Satzzeichen. Pandoc macht aus {,} und aus „x, y“ dasselbe, deshalb wird {,}
-- vorher markiert und im Typst-Code als normales Zeichen (class "normal") gesetzt.
-- Formeln mit eckigen Klammern gibt intervallklammern.lua als Typst aus und ersetzt
-- die Markierung dort selbst. Deshalb muss dieser Filter danach laufen.

local MARKE = "\\text{DEZIMALKOMMA}"

function Math(el)
  if not quarto.doc.is_format("typst") or not el.text:find("{,}", 1, true) then
    return nil
  end
  el.text = el.text:gsub("{,}", MARKE)
  local code = pandoc.write(pandoc.Pandoc({ pandoc.Plain({ el }) }), "typst")
  code = code:gsub("%s+$", "")
  code = code:gsub('upright%("DEZIMALKOMMA"%)', 'class("normal", \\,)')
  -- Inline-Formeln dürfen nicht mit "$ " beginnen, sonst setzt Typst sie abgesetzt
  if el.mathtype == "InlineMath" then
    code = "$" .. code:match("^%$%s*(.-)%s*%$$") .. "$"
  end
  return pandoc.RawInline("typst", code)
end
