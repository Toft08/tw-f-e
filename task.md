## Twenty-forty-eight

It is April 2014, and the popular game "2048" has not yet been released. Your task is to implement the game before the official release. The objective of the game is to slide numbered tiles on a grid to combine them and create a tile with the number 2048.

<center>
<img src="./resources/2048.01.png?raw=true" style = "width: 228px !important; height: 328px !important;"/>
</center>

### Instructions

To complete this exercise, you will need to do the following:

- Create the 4x4 grid and fill it with `tiles` valued at either 2 or 4.
- The game must start with 3-4 `tiles` randomly placed on the board.
- Implement the ability for players to swipe the `tiles` in any of the four directions and have them move as far as possible in the chosen direction.
- Use [animation](https://docs.flutter.dev/development/ui/widgets/animation) to smoothly move the `tiles`. You are free to choose the colors for the `tiles`.
- If two `tiles` with the same value collide, they should merge into one tile with twice the value, and the score must be updated accordingly.
- After each move, a new `tile` must appear randomly in an empty slot on the board.
- The game ends when no legal moves are possible (i.e., the grid is full, and no adjacent `tiles` have the same value).
- You must add a `restart` button so that the player can restart the game and try to achieve a higher score.
- Include functionality to track and display the `current` and `best scores` live during gameplay.
- Update the `best score` if necessary when the game is over.

Remember to follow best practices for coding and game development, and be sure to document your code and any decisions made during the development process.

### Bonus

To enhance the game, you can consider implementing the following features:

- Design a user interface (UI) for the game, including buttons for moving the `tiles` and displaying scores.
- Add difficulty levels or additional gameplay options, such as the ability to choose `tile` values (e.g. 2, 4, 8, ...) or customize the grid size (e.g. 4x4, 5x5, 6x6, ...).
- Incorporate sound effects or background music to improve the gameplay experience.
- Ensure the game is responsive and supports different devices and screen sizes.

## Audit
#### Functional

> In order to run and hot reload the app either on emulator or device, follow the [instructions](https://docs.flutter.dev/get-started/test-drive?tab=androidstudio#run-the-app)

###### Does the app run without crashing?

###### Does the game start with a 4x4 grid and 3-4 `tiles` randomly placed?

###### Are those `tiles` valued at either 2 or 4?

###### Can players swipe the `tiles` in any of the four directions, and do they move as far as possible in that direction?

###### Do `tiles` with the same value merge into one `tile` with twice the value when they collide?

###### Is the score updated when `tiles` are merged?

###### Does a new `tile` appear randomly on the board after each move?

###### Are animations used to smoothly move and merge the `tiles`?

###### Does the game stop when no legal moves are possible and does it allow the user to restart?

###### Does the game include a functionality to track and display the current and best scores.

###### Is the current score displayed during gameplay?

###### Is the best score updated if necessary when the game is over?

#### Bonus

###### +Does the game contain a user interface (UI), including buttons for moving "pieces" and displaying scores?

###### +Does the game have difficulty levels or other gameplay options, such as the ability to choose the value of the `tiles` (e.g. 2, 4, 8, etc.) or the size of the board (e.g. 4x4, 5x5, 6x6, etc.).

###### +Does the game have sound effects or background music to enhance the gameplay experience.

###### +Does the game support different devices and screen sizes like tablets or smartphones?