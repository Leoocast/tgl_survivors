extends Control

@onready var game: SceneTree = get_tree() as SceneTree

func _on_back_pressed() -> void:
	game.change_scene_to_file(PATHS.SCENES.MENU)
