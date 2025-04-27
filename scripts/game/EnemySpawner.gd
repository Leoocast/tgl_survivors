extends Node2D

const SLIME_ASSET = preload("res://scenes/enemies/slime.tscn")
@onready var player = %Player
@onready var spawner = $Path2D/PathFollow2D

func _process(_delta):
	if player:
		global_position = player.global_position

func spawnEnemy() -> void:
	var slimeInstance = SLIME_ASSET.instantiate() as Slime
	slimeInstance.setupPlayer(player)
	spawner.progress_ratio = randf()
	slimeInstance.global_position = spawner.global_position
	get_parent().add_child(slimeInstance)

func _on_timer_timeout() -> void:
	spawnEnemy()
