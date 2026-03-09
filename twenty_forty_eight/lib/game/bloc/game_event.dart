abstract class GameEvent {}

class StartGame extends GameEvent {}

class RestartGame extends GameEvent {}

class LoadBestScore extends GameEvent {}

// Swipe directions
class SwipeLeft extends GameEvent {}

class SwipeRight extends GameEvent {}

class SwipeUp extends GameEvent {}

class SwipeDown extends GameEvent {}