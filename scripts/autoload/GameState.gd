extends Node

#States
enum GamePhase {
	INIT,
	RUNNING,
	PAUSED,
	PLAYER_UPGRADE_SELECTION,
	PLAYER_DEAD,
	GAME_OVER,
	VICTORY
}

#Signals
signal phase_changed(newPhase: GamePhase)
signal game_paused()
signal game_resumed()

#Internal
var currentPhase: GamePhase = GamePhase.RUNNING
var isPaused: bool = false

#Ref Inyection
var comboHud: HUDComboController
var player: Player

func registerComboHud(_comboHud: HUDComboController) -> void:
	self.comboHud = _comboHud

func registerPlayer(_player: Player) -> void:
	self.player = _player

#-------------------------#
func setPhase(newPhase: GamePhase) -> void:
	if currentPhase == newPhase:
		return

	currentPhase = newPhase
	phase_changed.emit(newPhase)

func pause() -> void:
	isPaused = true
	setPhase(GamePhase.PAUSED)
	comboHud.comboSystem.pauseTimer()
	game_paused.emit()

func resume() -> void:
	if not isPaused:
		return
	
	setPhase(GamePhase.RUNNING)
	comboHud.comboSystem.resumeTimer()
	game_resumed.emit()

#Enter States
func enterUpgradeSelection() -> void:
	setPhase(GamePhase.PLAYER_UPGRADE_SELECTION)
	# pause() #? Deberia pausar?

func playerDied() -> void:
	setPhase(GamePhase.PLAYER_DEAD)
	isPaused = true

#Process conditions
func isNotRunning() -> bool:
	return currentPhase != GamePhase.RUNNING