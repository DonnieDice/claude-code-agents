# Distributor Descriptions

This directory contains markdown-formatted descriptions for various addon distribution platforms.

## Structure

Each addon has its own subdirectory containing platform-specific descriptions:

```
distributor-descriptions/
├── FFLU/
│   ├── curseforge.md
│   ├── wago.md
│   └── wowinterface.md
├── BLU/
│   ├── curseforge.md
│   └── wago.md
└── [other-addons]/
```

## Platforms

- **CurseForge** - Full markdown with HTML color spans
- **Wago.io** - Markdown with limited HTML support
- **WoWInterface** - Basic BBCode formatting
- **GitHub** - Full markdown for README.md

## Brand Standards

All descriptions follow the RGX Mods Brand Standards:
- RGX: `#8B1538` (burgundy)
- "ealm" in RealmGX: `#7598b6` (blue)
- Mods: `#4ecdc4` (teal)
- Separators: `#3598db` (blue)

## Usage

Use the brand-formatter agent to ensure consistent formatting:
```powershell
claude-agent deploy brand-formatter
```

Then format any description to match brand standards.