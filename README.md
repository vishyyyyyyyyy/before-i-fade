# 👻 Before I Fade 👻

<img width="1000" height="664" alt="Screenshot 2026-03-26 073152" src="https://github.com/user-attachments/assets/5a3b27b5-d658-456a-a573-74ae22a20009" />



**Before I Fade** is a murder mystery themed, 2D visual novel game where you play as a ghost, waking up one month after your death. Explore your home to uncover memories and piece together the truth behind your murder _before you fade_.

```⠀⠀⠀⠀
      ⠀⢀⣴⣿⣿⣿⣦⠀
⠀⠀⠀⠀⣰⣿⡟⢻⣿⡟⢻⣧
⠀⠀⠀⣰⣿⣿⣇⣸⣿⣇⣸⣿
⠀⠀⣴⣿⣿⣿⣿⠟⢻⣿⣿⣿
⣠⣾⣿⣿⣿⣿⣿⣤⣼⣿⣿⠇  🕯️๋࣭ ⭑𓍯𓂃
⢿⡿⢿⣿⣿⣿⣿⣿⣿⣿⡿⠀
⠀⠀⠈⠿⠿⠋⠙⢿⣿⡿⠁⠀
```

---

## About the Game
You play as a ghost, and your goal is to collect diary pages to find clues about who murdered you and why. Explore the entire house and complete puzzles within time limits to find them. Visiting each room floods your memories, forcing you to relive fragments of what happened in the past, moving you one step closer towards solving this murder mystery.

As the truth comes into focus, you’re faced with one final choice:  
**let the past fade away, or make sure it’s finally heard.**

There are **two possible endings**.

---

## Controls

<img width="1000" height="644" alt="Screenshot 2026-03-14 232730" src="https://github.com/user-attachments/assets/6c1bc373-018f-4aa4-9e75-872b902e4262" />


- **Arrow Keys / WASD** - Move around the house  
- **Left Click / Click + Drag / E** - Interact with objects and puzzles
- **Space / Enter** - Skip dialogues
- **ESC** - Access in game settings menu

  

---

## Core Systems

**Puzzles:**

<img width="1000" height="644" alt="Screenshot 2026-03-18 184311" src="https://github.com/user-attachments/assets/f079db39-c92c-4ecf-b88b-8a5547ce4088" />

- Built using Area2D with collision shapes and Texture2D buttons to detect input
- Puzzle state stored using lists and dictionaries
- Solutions checked dynamically
- Utilize Godot signals to connect subscript challenges to main script for story progression

**Timer:**

<img width="1000" height="644" alt="Screenshot 2026-03-18 184546" src="https://github.com/user-attachments/assets/adb81bfd-6b5e-475a-8328-00a92d8ebc89" />

- Timer node updated every frame using process() and displayed in a label
- Force updating timer color theme with ```add_theme_color_override``` on even numbered seconds remaining

**Interactions:**

<img width="1000" height="644" alt="Screenshot 2026-03-18 184038" src="https://github.com/user-attachments/assets/4b9686ed-4d97-4326-a26b-cc7adc3d4947" />

- Player interactions detected using Area2D Zones
- Mapping input to esc, space, e, and left click

**Dialogues:**

<img width="1000" height="644" alt="Screenshot 2026-03-18 183932" src="https://github.com/user-attachments/assets/f6b66ee1-5e93-4f43-b8e9-8f868d022ae2" />

- dialogues accessed using ```seek()``` in animation player to allow user input space for skip
- keyframing visibility and characters displayed
- storing time start and time end segments to seek to when input pressed
- ```end_dialogue()``` called for immediate next story progression

**Reusable scenes:**
- managed global variables to increment scene counters for correct scene triggers

**Visual Effects:**
- Camera shake effects
- Modulations to add ghostly effects 
- Animated overlays and hover states

**Challenge Lives**

<img width="1000" height="644" alt="Screenshot 2026-03-14 233135" src="https://github.com/user-attachments/assets/b891c7f1-f45d-4791-acae-d806b8d62680" />

- Heart UI dynamically updated when fail at a puzzle
- When hearts are all broken, system triggers a transition to reset scene
- Global variables used to track puzzle fail state and time loop dialogue

---

## Tools and Languages

- Godot Engine
- GDScript
- Aseprite
- HTML5 build
---

## Why We Made This

We wanted to make a game showcasing the theme, "changing of time",  through multiple ways

```
“what about something like find out why you die
like you be the ghost and you try to retrace your steps and figure out what happened to you”
```
Quote straight from our planning doc

We were really drawn to the murder mystery concept and wanted the changing of time to be physical, emotional and in every puzzle.

We included the "changing of time" through
- Being able to travel between present and past memories with the obvious gloomy present color scheme vs the bright and joyful past color scheme
- Calendar detailing
- Timers in puzzles
- Time loop paradox (iykyk >⩊<)

---

## Credits

Created by [Vishalya Sairam](https://github.com/vishyyyyyyyyy) and [Aadityan Anbumani](https://github.com/AadityanAnbumani)

Art:
- Hand drawn by Vishalya Sairam (✿◠‿◠)

Music & Sound (from Pixabay):

- Phone Ringing — Dragon Studio

- Police Siren — Dragon Studio

- Story of Maple — Final Gate Studios

- Correct Buzzer — u_a5z4rtk6yn

- Incorrect Buzzer — logicallism

- Piano notes — u_c58whxla22
  
- Horror — SoundGalleryByDmitryTaras

- Horror Playhouse — geoffharvey Spooked — geoffharvey

- Kerosene — LBDLPROD

- Puzzle Game — Cyberwave-Orchestra
  

Video Overlay:
- Damage Film Effects — Atomic Dreams

Fonts:

- Pixel Operator — Webfontfree
  
Engine:
- Made with love in Godot💖
---

## Play now on itch.io! (´▽`ʃ♡ƪ)

https://vishyyyyyyyyy.itch.io/before-i-fade

---
