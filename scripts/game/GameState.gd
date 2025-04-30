class_name GameState
extends Node2D

#Nodes
@onready var comboTimer = $HUD/Control/Combo/Timer
@onready var comboLabel = $HUD/Control/Combo/Label
@onready var comboTimeBar = $HUD/Control/Combo/ProgressBar


#Config
const KILL_TRESHOLDS := [15, 30, 50, 75, 100, 150, 250]
const KILL_MESSAGES := ["DIRTY", "CRAZY","BRUTAL", "ANARCHY", "SAVAGE", "SSADISTIC", "SSSENSATIONAL"]
const MESSAGE_DURATION := 2.0

#Internal
var killCount := 0
var killTimer := 0.0
var comboKillCount := 0
var currentTreshHold := 0

#FIXME: Audio
var this_game_is_over = load("res://assets/audio/voice_lines/This_game_is_Over.ogg")
var reawakeR = load("res://assets/audio/music/ReawakeR_-Instrumental-.ogg")
var announcerAudios = [
	load("res://assets/audio/announcer/Dirty.mp3"),
	load("res://assets/audio/announcer/Crazy.mp3"),
	load("res://assets/audio/announcer/Brutal.mp3"),
	load("res://assets/audio/announcer/Anarchy.mp3"),
	load("res://assets/audio/announcer/Savage.mp3"),
	load("res://assets/audio/announcer/SSadistic.mp3"),
	load("res://assets/audio/announcer/SSSensational.mp3")
	
]
var pauseMusic = load("res://assets/audio/music/ReawakeR_loop.ogg")

#PAUSA
var isPaused := false

#--------------------------------------------------------#

func _ready() -> void:
	hideComboStuff()
	# await AudioManager.playAndAwaitVoice(this_game_is_over)
	# AudioManager.playMusic(reawakeR)

func _process(_delta):
	updateComboBar()

func pause() -> void:
	isPaused = true
	AudioManager.fadeOutMusic()
	# AudioManager.playSelectionUpdateMusic(pauseMusic)
	push_warning("GAME PAUSED")

func resume() -> void:
	isPaused = false
	AudioManager.fadeInMusic()
	# AudioManager.stopSelectionUpdateMusic()
	push_warning("GAME RESUMED")

func registerEnemy(enemy: Enemy) -> void:
	enemy.died_signal.connect(_on_enemy_died_suscription)

func showComboStuff() -> void:
	comboLabel.show()
	comboTimeBar.show()

func hideComboStuff() -> void:
	comboLabel.hide()
	comboTimeBar.hide()

func updateComboBar() -> void:
	if comboTimer.is_stopped():
		return

	var remaining = comboTimer.time_left
	var total = comboTimer.wait_time
	comboTimeBar.value = remaining / total * comboTimeBar.max_value

#Signals
func _on_enemy_died_suscription() -> void:
	killCount += 1
	comboKillCount += 1
	if comboKillCount == KILL_TRESHOLDS[currentTreshHold]:
		comboLabel.text = KILL_MESSAGES[currentTreshHold]
		AudioManager.playAnnouncer(announcerAudios[currentTreshHold])
		showComboStuff()
		comboTimer.start()

		if currentTreshHold < KILL_TRESHOLDS.size() - 1:
			currentTreshHold += 1 


func _on_combo_timer_timeout() -> void:
	comboKillCount = 0
	currentTreshHold = 0
	hideComboStuff()
