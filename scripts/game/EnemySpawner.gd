extends Node

const SLIME_ASSET = preload("res://scenes/enemies/slime.tscn")


func spawnEnemy() -> void:
	var slimeInstance = SLIME_ASSET.instantiate()
	slimeInstance.player = %Player
	%EnemySpawner.progress_ratio = randf()
	slimeInstance.global_position = %EnemySpawner.global_position
	add_child(slimeInstance)
	

# func _on_timer_timeout() -> void:
# 	spawnEnemy()


# func _on_player_player_died() -> void:
# 	var tree = get_tree()
# 	tree.paused = true
