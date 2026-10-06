-- Intervallklammern wie ]2; 5[ oder ]-∞; 5[ richtig setzen (PDF, HTML, Folien).
--
-- Typst und MathJax halten „[“ immer für eine öffnende und „]“ immer für eine
-- schließende Klammer. Bei [2; 5[ fehlt dann der Abstand vor „=“, bei ]-∞ wird
-- das Minus als Rechenzeichen mit Abständen gesetzt. Dieser Filter gibt jeder
-- eckigen Klammer ihre tatsächliche Rolle: Steht direkt davor eine Zahl, ein
-- Buchstabe, ∞ oder eine Klammer zu, schließt sie das Intervall, sonst öffnet sie es.

local function schliesst(davor)
  davor = davor:gsub("%s+$", "")
  return davor:match("[%w%)}]$") ~= nil
end

-- Befehle, deren eckige Klammern nicht angefasst werden dürfen
local function geschuetzt(davor)
  if davor:match("\\$") then return true end -- \[ oder \]
  local befehl = davor:gsub("%s+$", ""):match("\\(%a+)$")
  return befehl ~= nil and (befehl == "left" or befehl == "right"
    or befehl:match("^[Bb]igg?[lr]?$") ~= nil)
end

local function typst(el)
  -- Dezimalkomma {,} ohne Abstand setzen (siehe dezimalkomma.lua)
  el.text = el.text:gsub("{,}", "\\text{DEZIMALKOMMA}")
  local code = pandoc.write(pandoc.Pandoc({ pandoc.Plain({ el }) }), "typst")
  code = code:gsub("%s+$", "")
  code = code:gsub('upright%("DEZIMALKOMMA"%)', 'class("normal", \\,)')
  code = code:gsub("()\\([%[%]])", function(pos, klammer)
    local rolle = schliesst(code:sub(1, pos - 1)) and "closing" or "opening"
    return ' class("' .. rolle .. '", \\' .. klammer .. ") "
  end)
  -- kleiner Abstand nach dem Strichpunkt: [2; 5] statt [2;5]
  code = code:gsub("\\;", "\\; thin ")
  -- Inline-Formeln dürfen nicht mit "$ " beginnen, sonst setzt Typst sie abgesetzt
  if el.mathtype == "InlineMath" then
    code = "$" .. code:match("^%$%s*(.-)%s*%$$") .. "$"
  end
  return pandoc.RawInline("typst", code)
end

local function latex(el)
  local text = el.text
  el.text = text:gsub("()([%[%]])", function(pos, klammer)
    local davor = text:sub(1, pos - 1)
    if geschuetzt(davor) then return nil end
    local rolle = schliesst(davor) and "\\mathclose" or "\\mathopen"
    return rolle .. "{" .. klammer .. "}"
  end)
  return el
end

function Math(el)
  -- \sqrt[3]{x} u. Ä. nicht verändern
  if not el.text:find("[%[%]]") or el.text:find("\\sqrt%s*%[") then
    return nil
  end
  if quarto.doc.is_format("typst") then
    return typst(el)
  end
  return latex(el)
end
