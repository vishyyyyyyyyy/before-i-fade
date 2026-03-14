# 👻 Before I Fade

<img width="1900" height="1100" alt="Screenshot 2026-03-07 100537" src="https://github.com/user-attachments/assets/977c6b43-aa4b-4bdc-ba54-bb440089ce4e" />


**Before I Fade** is a murder mystery themed, 2D visual novel game where you play as a ghost, waking up one month after your death. Explore your home to uncover memories and piece together the truth behind your murder _before you fade_.

---

## 🕯️ About the Game
You play as a ghost, and your goal is to collect diary pages to find clues about who murdered you and why. Explore the entire house and complete puzzles within time limits to find them. Visiting each room floods your memories, forcing you to relive fragments of what happened in the past, moving you one step closer towards solving this murder mystery.

As the truth comes into focus, you’re faced with one final choice:  
**let the past fade away, or make sure it’s finally heard.**

There are **two possible endings**.

---

## 🎮 Controls

<img width="1000" height="700" alt="Screenshot 2026-03-11 085118" src="https://github.com/user-attachments/assets/201d1b4b-55de-48fc-b363-abda16fe0ce2" />


- **Arrow Keys / WASD** - Move around the house  
- **Left Click / Click + Drag / E** - Interact with objects and puzzles
- **Space / Enter** - Skip dialogues
- **ESC** - Access in game settings menu

  

---

## ⚙️ Core Systems
Puzzles:
- Built using Area2D with collision shapes and Texture2D buttons to detect input
- Puzzle state stored using lists and dictionaries
- Solutions checked dynamically
- Utilize Godot signals to connect subscript challenges to main script for story progression

Timer:
- Timer node updated every frame using process() and displayed in a label
- Force updating timer color theme with ```add_theme_color_override``` on even numbered seconds remaining

Interactions:
- Player interactions detected using Area2D Zones
- Mapping input to esc, space, e, and left click

Dialogues:
- dialogues accessed using ```seek()``` in animation player to allow user input space for skip
- keyframing visibility and characters displayed
- storing time start and time end segments to seek to when input pressed
- ```end_dialogue()``` called for immediate next story progression

Reusable scenes:
- managed global variables to increment scene counters for correct scene triggers

Visual Effects: 
- Camera shake effects
- Modulations to add ghostly effects 
- Animated overlays and hover states

---

## 💻Tools and Languages

- Godot Engine
- GDScript
- Aseprite
- HTML5 build
---

## 💭 Why We Made This

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
- Time loop paradox (iykyk😉)

---

## 🔮 Future Improvements

We are currently working on creating a new release with even better features to make the game more enjoyable! Expect these changes soon~
- Adding a more detailed ending 2
- Adding camera properties for dramatic effects
- Incorporating a lives system during challenges
- Loading splash screen
- Moving closer to objects to interact 
- Rereading diary page entries
- Settings menu from in game
- Mobile support c:

---

## 🎶 Credits

This game was created for Codédex's Monthly Challenge Game Jam under the theme: the changing of time

Created by [Vishalya Sairam](https://github.com/vishyyyyyyyyy) and [Aadityan Anbumani](https://github.com/AadityanAnbumani)

All art in the game is hand drawn by me! (✿◠‿◠)

Music & Sound (from pixabay):

- Phone Ringing — Dragon Studio

- Police Siren -Dragon Studio

- Story of Maple — Final Gate Studios

- Correct Buzzer — u_a5z4rtk6yn

- Incorrect Buzzer — logicallism

- Piano notes — u_c58whxla22

Fonts:

- Pixel Operator — Webfontfree
  
Engine:
- Made with love in Godot💖
---

## ▶️Where to play

**Play directly on itch.io (´▽`ʃ♡ƪ):**  
https://vishyyyyyyyyy.itch.io/before-i-fade

---
