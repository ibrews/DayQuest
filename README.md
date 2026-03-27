# DayQuest ⚔️

**Your daily calendar, reimagined as a charming 8-bit RPG.**

DayQuest transforms the boring act of checking your calendar into a tiny adventure. Each morning (or night before), walk your pixel-art hero through the events of your day — meetings become council gatherings, phone calls become carrier pigeons, and coffee breaks become visits to the alchemist's shop.

## The Idea

What if reviewing your calendar was actually fun? What if, instead of a list of abstract time blocks, you could *play through* your day as a mini-game?

**DayQuest gives you:**
- A cheerful, positive mindset before your day begins
- A mnemonic device that helps you remember what's happening and in what order
- Fun associations with even the boring parts of your day

Inspired by Stardew Valley's charm, The Sims' life simulation, Nathan Fielder's *The Rehearsal*, and Charlie Kaufman's *Synecdoche, New York*. Simulacrum as goal.

## How It Works

1. **See your day** — Events appear as a quest list with RPG-style icons
2. **Walk through it** — Guide your character along a village path to each event
3. **Interact** — Choose fun responses at each stop ("Feast heartily!" / "Sample the specials!")
4. **Collect stats** — Earn Teamwork, Wisdom, Energy, and more
5. **Complete the quest** — See your total stats at the end

## Screenshots

The app features:
- Pixel art sprites generated entirely in code (PICO-8 color palette)
- SpriteKit game engine with SwiftUI shell
- Top-down RPG village with trees, flowers, and animated NPCs
- Dialogue system with branching choices
- Randomized fake calendar for demo purposes

## Tech Stack

- **Swift / SwiftUI** — App shell, overview & completion screens
- **SpriteKit** — Game engine, pixel art rendering, animations
- **No external dependencies** — All sprites are procedurally generated from pixel arrays
- **iOS 17+** — iPhone and iPad

## What's Next

- [ ] Real calendar integration (EventKit / Google Calendar)
- [ ] Character customization
- [ ] More event types and interaction scenarios
- [ ] Persistent stats and streaks
- [ ] Presentation rehearsal mode — upload slides/scripts and walk through them as game scenarios
- [ ] Memory palace mechanics — silly visual mnemonics tied to each event

## Building

Open `DayQuest.xcodeproj` in Xcode 15+ and run on an iOS 17+ device or simulator.

## License

MIT
