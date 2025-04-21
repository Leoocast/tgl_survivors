extends Control

@onready var game := get_tree() as SceneTree

func _on_back_pressed() -> void:
	game.change_scene_to_file(GameConstants.SCENES.MENU)
