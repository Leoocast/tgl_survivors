extends Control

@onready var game := get_tree() as SceneTree

func _on_play_pressed() -> void:
	game.change_scene_to_file(Constants.SCENES.GAME)

func _on_options_pressed() -> void:
	game.change_scene_to_file(Constants.SCENES.MENU_OPTIONS)

func _on_quit_pressed() -> void:
	game.quit()
