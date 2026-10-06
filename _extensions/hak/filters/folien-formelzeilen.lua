-- Nebeneinander stehende Formeln auf den Folien bei Bedarf umbrechen.
--
-- Beispiele stehen oft als mehrere Formeln in einer Zeile, getrennt mit \qquad.
-- Im Skript bricht das niemand um, auf den Folien wird eine zu lange Zeile rechts
-- abgeschnitten. Dieser Filter zerlegt eine abgesetzte Formel auf den Folien an
-- jedem \qquad in einzelne Formeln. Sie stehen weiter nebeneinander, rutschen
-- aber in die nächste Zeile, wenn der Platz nicht reicht (siehe folien.css).
-- Skript (HTML, PDF) bleibt unverändert.

-- Teilt den Formeltext an jedem \qquad, das nicht in geschweiften Klammern steht
local function teile(text)
  local stuecke = {}
  local tiefe, anfang, i = 0, 1, 1
  while i <= #text do
    local z = text:sub(i, i)
    if z == "\\" then
      if tiefe == 0 and text:sub(i, i + 5) == "\\qquad"
          and not text:sub(i + 6, i + 6):match("%a") then
        table.insert(stuecke, text:sub(anfang, i - 1))
        anfang = i + 6
        i = i + 5
      else
        i = i + 1 -- maskiertes Zeichen wie \{ überspringen
      end
    elseif z == "{" then
      tiefe = tiefe + 1
    elseif z == "}" then
      tiefe = tiefe - 1
    end
    i = i + 1
  end
  table.insert(stuecke, text:sub(anfang))
  return stuecke
end

function Para(el)
  if not quarto.doc.is_format("revealjs") or #el.content ~= 1 then
    return nil
  end
  local formel = el.content[1]
  if formel.t ~= "Math" or formel.mathtype ~= "DisplayMath"
      or not formel.text:find("\\qquad", 1, true)
      or formel.text:find("\\begin", 1, true) then
    return nil
  end
  local formeln = pandoc.List()
  for _, stueck in ipairs(teile(formel.text)) do
    stueck = stueck:gsub("^%s+", ""):gsub("%s+$", "")
    if #stueck > 0 then
      formeln:insert(pandoc.Math("InlineMath", "\\displaystyle " .. stueck))
    end
  end
  if #formeln < 2 then
    return nil
  end
  return pandoc.Div({ pandoc.Plain(formeln) }, pandoc.Attr("", { "formelzeilen" }))
end
