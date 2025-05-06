class_name Main
extends Node2D

#Nodes
@onready var comboHud = %HUDComboController as HUDComboController

#FIXME: Audio
var reawakeR = load("res://assets/audio/music/ReawakeR_-Instrumental-.ogg")

#-------------------------#
func _ready() -> void:
	GameState.registerComboHud(comboHud)
	# AudioManager.playMusic(reawakeR)

func registerEnemy(enemy: Enemy) -> void:
	enemy.died.connect(comboHud.comboSystem.on_enemy_died)
