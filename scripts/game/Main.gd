class_name Main
extends Node2D

#Nodes
@onready var comboHud: HUDComboController = %HUDComboController as HUDComboController
@onready var levelUpUi: LevelUpUI = %LevelUpUI as LevelUpUI
@onready var player: Player = %Player as Player

#FIXME: Audio
var level1_music= load("res://assets/audio/music/Level_1_Music.ogg")

#-------------------------#
func _ready() -> void:	
	GameState.registerComboHud(comboHud)
	GameState.registerPlayer(player)
	GameState.registerLevelUpUI(levelUpUi)
	AudioManager.playMusic(level1_music)

func registerEnemy(enemy: Enemy) -> void:
	enemy.died.connect(comboHud.comboSystem.on_enemy_died)
