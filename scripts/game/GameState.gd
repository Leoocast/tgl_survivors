class_name GameState
extends Node2D

#Nodes
@onready var hudComboController = %HudComboController as HudComboController

#FIXME: Audio
var reawakeR = load("res://assets/audio/music/ReawakeR_-Instrumental-.ogg")

#PAUSA
var isPaused := false

#-------------------------#
func _ready() -> void:
	pass
	# AudioManager.playMusic(reawakeR)

func pause() -> void:
	isPaused = true
	hudComboController.comboSystem.pauseTimer()
	AudioManager.fadeOutMusic()
	
func resume() -> void:
	isPaused = false
	hudComboController.comboSystem.resumeTimer()
	AudioManager.fadeInMusic()

func registerEnemy(enemy: Enemy) -> void:
	enemy.died.connect(hudComboController.comboSystem.on_enemy_died)
