-- Kurzbefehl für Buchbeispiele: {{< buch 1.23 1.24ab 1.27 >}}
--
-- Erzeugt einen eigenen Kasten „Übungsbeispiele: 1.23, 1.24ab, 1.27“ mit Buch-Symbol,
-- im Skript (HTML, PDF) und auf den Folien. Aussehen:
--   HTML und Folien: buchbeispiele.css
--   PDF:             Funktion buchbeispiele() in typst-anpassungen.typ

-- Buch-Symbol (aufgeschlagenes Buch), Farbe kommt aus dem CSS
local SYMBOL = '<svg viewBox="0 0 16 16" aria-hidden="true">'
  .. '<path d="M1 2.8C2.6 2 5.4 1.8 7.5 3.2v10.3C5.4 12.2 2.6 12.4 1 13.2z'
  .. 'M15 2.8C13.4 2 10.6 1.8 8.5 3.2v10.3c2.1-1.3 4.9-1.1 6.5-.3z"/></svg>'

local function nummern(args)
  local liste = {}
  for _, arg in ipairs(args) do
    table.insert(liste, pandoc.utils.stringify(arg))
  end
  return table.concat(liste, ", ")
end

return {
  ["buch"] = function(args)
    local text = nummern(args)
    if quarto.doc.is_format("typst") then
      local typst = text:gsub("\\", "\\\\"):gsub('"', '\\"')
      return pandoc.RawBlock("typst", '#buchbeispiele("' .. typst .. '")')
    elseif quarto.doc.is_format("html:js") then
      return pandoc.RawBlock("html", '<div class="buchbeispiele">' .. SYMBOL
        .. '<strong>Übungsbeispiele:</strong> ' .. text .. '</div>')
    else
      return pandoc.Para({ pandoc.Strong("Übungsbeispiele:"), pandoc.Space(),
        pandoc.Str(text) })
    end
  end
}
