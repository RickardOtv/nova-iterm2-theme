#!/usr/bin/env python3
"""Builds the iTerm2 colors + dynamic profile from the Herdr theme (herdr-theme.json).

Usage: python3 iterm2/build.py [background-image-path [profile-out-path]]
No args: refreshes the committed iterm2/nova.json + iterm2/Nova.itermcolors
(no background, no machine paths). With profile-out-path: writes only that file.
"""
import json
import plistlib
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
NAME = "Nova"
GUID = "6F1C3B0E-4E7A-4F8A-9D2C-3E5B7A1C0D42"

theme = json.loads((HERE / "herdr-theme.json").read_text())
ui = theme["colors"]


def color(hex_):
    h = hex_.lstrip("#")
    r, g, b = (int(h[i:i + 2], 16) / 255 for i in (0, 2, 4))
    return {"Color Space": "sRGB", "Red Component": r, "Green Component": g,
            "Blue Component": b, "Alpha Component": 1.0}


colors = {f"Ansi {i} Color": color(c) for i, c in enumerate(theme["ansi"])}
colors.update({
    "Background Color": color(theme["background"]),
    "Foreground Color": color(theme["foreground"]),
    "Bold Color": color("#ffffff"),
    "Cursor Color": color(theme["cursor"]),
    "Cursor Text Color": color(ui["accent_foreground"]),
    "Cursor Guide Color": color(ui["raised"]),
    "Selection Color": color(theme["selection"]),
    "Selected Text Color": color("#ffffff"),
    "Link Color": color(ui["working"]),
    "Badge Color": color(ui["accent"]),
    "Underline Color": color(ui["input"]),
    "Tab Color": color(ui["chrome"]),
})

profile = {
    "Name": NAME,
    "Guid": GUID,
    "Tags": ["nova"],
    **colors,
    "Use Tab Color": True,
    "Use Separate Colors for Light and Dark Mode": False,
    # Font: Share Tech Mono, same as Herdr cyberpunk.
    "Normal Font": "ShareTechMono-Regular 15",
    "Non Ascii Font": "ShareTechMono-Regular 15",
    "Use Non-ASCII Font": False,
    "ASCII Ligatures": False,
    "Horizontal Spacing": 1.0,
    "Vertical Spacing": 1.2,
    "Use Bold Font": True,
    "Use Bright Bold": False,
    "Minimum Contrast": 0.0,
    # Cursor: solid yellow block, no blink.
    "Cursor Type": 2,
    "Blinking Cursor": False,
    # Window: dark, slightly see-through, padded like Herdr panes.
    "Transparency": 0.05,
    "Blur": True,
    "Blur Radius": 8.0,
    "Side Margins": 14,
    "Top/Bottom Margins": 10,
    "Columns": 140,
    "Rows": 40,
    # Left option = Alt (Herdr: option_as_alt = left).
    "Option Key Sends": 2,
    "Right Option Key Sends": 0,
    "Unlimited Scrollback": True,
    "Silence Bell": True,
}

if len(sys.argv) > 1:
    profile.update({
        "Background Image Location": sys.argv[1],
        "Background Image Mode": 2,  # scale to fill
        "Blend": 0.25,  # skyline faint behind text, like Herdr panes
    })

text = json.dumps({"Profiles": [profile]}, indent=2) + "\n"
if len(sys.argv) > 2:
    # Install: write only the profile, never touch repo files.
    Path(sys.argv[2]).write_text(text)
else:
    # Repo build: refresh the committed files.
    (HERE / "nova.json").write_text(text)
    with open(HERE / f"{NAME}.itermcolors", "wb") as f:
        plistlib.dump(colors, f)
print(f"Built {NAME}")
