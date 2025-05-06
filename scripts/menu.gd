extends Control

@onready var game: SceneTree = get_tree() as SceneTree

func _on_play_pressed() -> void:
	game.change_scene_to_file(PATHS.SCENES.GAME)

func _on_options_pressed() -> void:
	game.change_scene_to_file(PATHS.SCENES.MENU_OPTIONS)

func _on_quit_pressed() -> void:
	game.quit()
