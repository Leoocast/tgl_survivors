class_name Main
extends Node2D

#Nodes
@onready var comboHud: HUDComboController = %HUDComboController as HUDComboController
@onready var levelUpUi: LevelUpUI = %LevelUpUI as LevelUpUI
@onready var player: Player = %Player as Player

#FIXME: Audio
var reawakeR = load("res://assets/audio/music/ReawakeR_-Instrumental-.ogg")

#-------------------------#
func _ready() -> void:	
	GameState.registerComboHud(comboHud)
	GameState.registerPlayer(player)
	GameState.registerLevelUpUI(levelUpUi)
	# AudioManager.playMusic(reawakeR)

func registerEnemy(enemy: Enemy) -> void:
	enemy.died.connect(comboHud.comboSystem.on_enemy_died)
