-- Deutsche Anführungszeichen „…“ in allen Formaten.
--
-- Pandoc macht in der Typst-Ausgabe aus “ ein gerades ", das Typst dann als
-- öffnendes Zeichen setzt („…„). Deshalb wird “ für Typst roh durchgereicht.
-- Gerade Anführungszeichen "…" im Quelltext werden ebenfalls zu „…“.

local function schliessend()
  if quarto.doc.is_format("typst") then
    return pandoc.RawInline("typst", "“")
  end
  return pandoc.Str("“")
end

function Str(el)
  if not quarto.doc.is_format("typst") or not el.text:find("“", 1, true) then
    return nil
  end
  local teile = pandoc.List()
  local rest = el.text
  while true do
    local i, j = rest:find("“", 1, true)
    if not i then break end
    if i > 1 then teile:insert(pandoc.Str(rest:sub(1, i - 1))) end
    teile:insert(schliessend())
    rest = rest:sub(j + 1)
  end
  if #rest > 0 then teile:insert(pandoc.Str(rest)) end
  return teile
end

function Quoted(el)
  if el.quotetype ~= "DoubleQuote" then return nil end
  local teile = pandoc.List({ pandoc.Str("„") })
  teile:extend(el.content)
  teile:insert(schliessend())
  return teile
end
