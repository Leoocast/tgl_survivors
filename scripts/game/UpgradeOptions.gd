class_name UpgradeOption
extends Panel

#Nodes
@onready var nameLabel: Label = $MarginContainer/Name as Label
@onready var descLabel: Label = $MarginContainer2/Description as Label

#Exports
@export var upgrade: Upgrade

#Config
var panelHoverStyle: StyleBox = theme.get_stylebox("hover", "Panel")
var panelNormalStyle: StyleBox = theme.get_stylebox("normal", "Panel")

#Signals
signal upgrade_selected_signal(upgrade: Upgrade)

#-------------------------#
func setup(_name: String, _desc: String) -> void:
	nameLabel.text = _name
	descLabel.text = _desc

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
	upgrade_selected_signal.emit(upgrade)
