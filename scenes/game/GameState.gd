class_name GameState
extends Node2D

#Nodes
@onready var comboLabel = $HUD/Control/Combo

#Config
const KILL_TRESHOLDS := [2, 4, 6, 8, 10, 12, 14, 16]
const KILL_MESSAGES := ["DIRTY", "CRAZY","BRUTAL", "ANARCHY", "SAVAGE", "SADISTIC", "SUPPRESSIVE", "ASSASSINATION"]
const MESSAGE_DURATION := 2.0

#Internal
var killCount := 0
var killTimer := 0.0
var currentTreshHold = 0

#Signals

#--------------------------------------------------------#
func _ready() -> void:
	comboLabel.hide()

func registerEnemy(enemy: Enemy) -> void:
	enemy.died_signal.connect(_on_enemy_died_suscription)

#Signals
func _on_enemy_died_suscription() -> void:
	killCount += 1
	if killCount == KILL_TRESHOLDS[currentTreshHold]:
		comboLabel.text = KILL_MESSAGES[currentTreshHold]
		comboLabel.show()

		if currentTreshHold < KILL_TRESHOLDS.size() - 1:
			currentTreshHold += 1 
