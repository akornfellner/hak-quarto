"""Gemeinsamer Stil der matplotlib-Grafiken in allen Skripten.

Wird von `_python/grafiken.py` des jeweiligen Skripts importiert. Dort stehen
die Zeichnungen der Klasse, hier nur, was für alle Klassen gleich ist.

Stil laut regeln.md: Linien schwarz, Flächen hellrot, Schrift sans-serif,
weißer Hintergrund (damit die Grafik auch im dunklen HTML-Modus lesbar ist).
"""

import matplotlib.pyplot as plt
import numpy as np

SCHWARZ = "#000000"
ROT = "#CE1F2C"
HELLROT = "#EBA5AB"

plt.rcParams.update({
    "font.family": "sans-serif",
    "font.size": 13,
    "mathtext.fontset": "dejavusans",
    "figure.facecolor": "white",
    "savefig.facecolor": "white",
    "savefig.bbox": "tight",
})


def zahl(x):
    """Zahl österreichisch formatieren: Dezimalkomma, echtes Minuszeichen."""
    if float(x).is_integer():
        text = str(int(x))
    else:
        text = f"{x:g}".replace(".", ",")
    return text.replace("-", "−")


def tausender(n):
    """Ganze Zahl mit Leerzeichen als Tausendertrennzeichen: 1092 → „1 092“."""
    # \u2009 = schmales Leerzeichen
    return f"{n:,}".replace(",", "\u2009").replace("-", "−")
