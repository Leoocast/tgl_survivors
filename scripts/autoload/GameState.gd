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

#Test
var isTestMode = false

#Signals
signal phase_changed(newPhase: GamePhase)
signal game_paused()
signal game_resumed()

#Internal
var currentPhase: GamePhase = GamePhase.RUNNING
var isPaused: bool = false

#Ref Inyection
var comboHud: HUDComboController
var levelUpUI: LevelUpUI
var player: Player

func registerComboHud(_comboHud: HUDComboController) -> void:
	self.comboHud = _comboHud

func registerPlayer(_player: Player) -> void:
	self.player = _player
	player.xpSystem.level_up.connect(on_player_level_up)

func registerLevelUpUI(_levelUpUI: LevelUpUI) -> void:
	self.levelUpUI = _levelUpUI
	levelUpUI.upgrade_completed.connect(on_upgrade_completed)
	levelUpUI.upgrade_completed.connect(player.healthController.on_upgrade_completed)

#-------------------------#

func _ready():
	pass
	# useTestMode()

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

#Signals
func on_player_level_up(_newLvl: int, _xpNextLvl: int, _currentXp: int) -> void:
	isPaused = true
	GameState.setPhase(GamePhase.PLAYER_UPGRADE_SELECTION)
	comboHud.comboSystem.pauseTimer()

func on_upgrade_completed() -> void:
	resume()

func useTestMode() -> void:
	push_warning("<< USING TEST MODE >>")
	push_warning("Player will not available with: GameUtils.getPlayer()")
	isTestMode = true
