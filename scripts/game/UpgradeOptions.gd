extends Panel

var panelHoverStyle = theme.get_stylebox("hover", "Panel")
var panelNormalStyle = theme.get_stylebox("normal", "Panel")

func _ready():
	add_theme_stylebox_override("panel", panelNormalStyle)

func _on_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.08, 1.08), 0.1)
	add_theme_stylebox_override("panel", panelHoverStyle)

func _on_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)
	add_theme_stylebox_override("panel", panelNormalStyle)


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2(.95, .95), 0.1)
		add_theme_stylebox_override("panel", panelNormalStyle)
		onClickUpgrade()

	if event is InputEventMouseButton and not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)

func onClickUpgrade() -> void:
	#FIXME:
	var game = GameUtils.getGame()
	var lvlUpUi = game.get_node("LvlUpUI")
	lvlUpUi.hide()
	game.resume()
