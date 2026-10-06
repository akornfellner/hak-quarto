-- Im PDF nur bis Ebene 2 nummerieren (1.1), so wie number-depth: 2 im HTML.
-- orange-book ignoriert number-depth und würde sonst 1.1.4.2 usw. anzeigen.
function Header(h)
  if quarto.doc.is_format("typst") and h.level >= 3 then
    h.classes:insert("unnumbered")
  end
  return h
end
