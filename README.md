# Maze Game

A simple but challenging procedural maze game made with Godot.

## About
In this game, the player must solve randomly generated mazes across difficulty levels from 1 to 10.  
Each run is different, which makes the game endlessly replayable.

## Features
- Procedurally generated mazes
- 10 difficulty levels
- Timer and statistics system
- Simple pixel art visuals
- Sound effects and background music
- Playable in the browser

## Controls
- **WASD** → Move
- **Mouse** → UI interaction

## Built With
- **Engine:** Godot
- **Language:** GDScript

## Project Structure
- `game.gd` → Main game flow and level transitions
- `map.gd` → Map scene setup and maze placement
- `maze.gd` → Maze generation logic (`Maze` class)
- `character.gd` → Player movement
- `gui.gd` → User interface logic
- `global.gd` → Shared game data and statistics
- `sounds.gd` → References to sound effect nodes for easier access

## Note
I wrote most of the code myself.  
Since I’m not very strong in mathematics, I used AI assistance in a few small parts and for a large portion of the maze generation algorithm.

## Play
You can play the game on itch.io:  
https://emin-1.itch.io/maze-game

## Assets

### Graphics
- [Nul Boy by PotatoOto](https://p4to.itch.io/nul-boy)
- [Jawbreaker by Adam Saltsman](https://adamatomic.itch.io/jawbreaker)

### Sound Effects
- [BK-Wind_G#5.WAV by Anillogic](https://freesound.org/people/Anillogic/sounds/122327/)
- [BELL BLIP.wav by looppool](https://freesound.org/people/looppool/sounds/13119/)
- [Metronome 1kHz (weak pulse) by unfa](https://freesound.org/people/unfa/sounds/243749/)
- [Tick Tock by StarNinjas37](https://freesound.org/people/StarNinjas37/sounds/547305/)
- [tick __ by waveplaySFX](https://freesound.org/people/waveplaySFX/sounds/201766/)

### Music
- [Atmospheric Adventures Music Pack by Rosentwig](https://rosentwig.itch.io/atmospheric-adventures-freebie)

### Font
- [monogram by datagoblin](https://datagoblin.itch.io/monogram)
