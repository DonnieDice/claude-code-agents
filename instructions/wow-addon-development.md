# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This repository contains multiple World of Warcraft addons developed by DonnieDice. Each addon is a standalone project with its own directory structure:

- **BLU** - Better Level-Up! - Plays custom game sounds for various WoW events
- **CoordinationCloakUtility** - Automates teleportation cloak gear swaps
- **FFLU** - Final Fantasy Level-Up! - Plays FF level-up sound
- **QuestPlates** - Quest-related nameplate enhancements
- **Remove_Nameplate_Debuffs** - Removes debuffs from nameplates
- **SRLU** - Simple sound addon for level-ups

## Architecture

### World of Warcraft Addon Structure
Each addon follows WoW addon conventions:
- **`.toc` files** - Table of Contents files defining addon metadata and file load order
- **`data/` directory** - Contains Lua source files
- **`sounds/` directory** - Contains audio files (`.ogg` format)
- **`images/` directory** - Contains textures and icons
- **`docs/` directory** - Documentation and changelogs

### Core Files Pattern
Most addons follow this file structure in `data/`:
- `core.lua` - Main addon logic and event handlers
- `initialization.lua` - Addon initialization and setup
- `localization.lua` - Text strings and translations
- `options.lua` - Configuration UI using Ace3
- `sounds.lua` - Sound definitions and mappings
- `utils.lua` - Utility functions

### Library Dependencies
Addons use the Ace3 library framework:
- **AceAddon-3.0** - Core addon framework
- **AceEvent-3.0** - Event handling
- **AceDB-3.0** - Saved variables management
- **AceConfig-3.0** - Configuration interface
- **AceGUI-3.0** - GUI components

## Development Workflow

### VSCode Integration
For optimal development experience, use VSCode with these extensions:

**Essential Extensions:**
- **WoW Bundle** (`Septh.wow-bundle`) - Complete WoW addon development toolkit
  - WoW-specific Lua grammar with API knowledge
  - .toc file syntax highlighting and grammar
  - Blizzard Lua extensions (table.wipe(), strjoin(), etc.)
  - Combat-restricted function awareness
- **WoW API** (`ketho.wow-api`) - IntelliSense for WoW API functions
  - Auto-activates when opening folders with .toc files
  - API autocomplete and documentation
  - Function signature hints

**Setup:**
1. Install both extensions from VSCode marketplace
2. Open addon folder containing .toc files
3. Extensions auto-activate for WoW development context

### No Build System
These are WoW addons with no build process - they run directly from Lua source files. Testing requires:
1. Copy addon folder to WoW's `Interface/AddOns/` directory
2. Restart WoW or reload UI with `/reload`
3. Test in-game functionality

### Version Management
- Version numbers follow `vX.Y.Z` format
- ToC files contain WoW interface version numbers
- Multiple ToC files support different WoW versions (Retail, Classic, Cataclysm)

### Documentation Standards
Based on `docs/guidelines_changelog.md`:
- **Added** - New features/files
- **Updated** - Enhancements to existing features
- **Fixed** - Bug corrections
- **Removed** - Deleted features/files
- **Renamed** - File/variable name changes
- **Moved** - File relocations
- **Restructured** - Organizational changes

### Sound Integration (BLU addon)
Per `docs/guidelines_sounds.md`:
- Audio files in OGG format with three volume levels (`_low`, `_med`, `_high`)
- Normalized to -23.0 LUFS using Audacity
- 48kHz sample rate, mono channel
- Files placed in `sounds/` directory
- Sound definitions in `sounds.lua` file

## Important Notes

### File Handling
- Use forward slashes in file paths
- Include file extensions in documentation
- ToC files are critical for addon loading order

### WoW API Usage
- Code uses WoW's Lua API and events
- Event handling through Ace3 framework
- Saved variables for persistent settings

### Multi-Version Support
- Separate ToC files for different WoW versions
- Feature compatibility varies by WoW version (Retail vs Classic)