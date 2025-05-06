class_name HealthBarController
extends Control

#Config
var entity: Node2D
var healthController: HealthController
var color: Color
var isPlayerUI: bool = false

#Nodes
@onready var ui_mainBar: ProgressBar = $MainBar
@onready var ui_whiteBar: ProgressBar = $WhiteBar
@onready var ui_blackBar: ProgressBar = $Blackbar

#Internal
var alreadyShowed: bool = false

#-------------------------#
func setup(_entity: Node2D, _healthController: HealthController, _color: Color, _isPlayerUI: bool = false) -> void:
	self.entity = _entity
	self.healthController = _healthController
	self.color = _color
	self.isPlayerUI = _isPlayerUI
	createMainBar()
	setupHealth()
	
func takeDamage(damage: float) -> void:
	var current = healthController.health
	ui_mainBar.value = current
	ui_whiteBar.value = current + damage
	ui_blackBar.value = current + damage

	await GameUtils.showHide(ui_whiteBar, 0.08)

	var tween = GameUtils.create_tween()
	tween.tween_property(ui_blackBar, "value", current, 0.3).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)

func hideBars() -> void:
	ui_mainBar.hide()
	ui_whiteBar.hide()
	ui_blackBar.hide()

func showBars() -> void:
	ui_mainBar.show()
	ui_whiteBar.show()
	ui_blackBar.show()
	createMainBar()
	alreadyShowed = true

func createMainBar() -> void:
	var stylebox = StyleBoxFlat.new()

	#FIXME:
	if not isPlayerUI:
		stylebox.corner_radius_top_left = 8
		stylebox.corner_radius_top_right = 8
		stylebox.corner_radius_bottom_left = 8
		stylebox.corner_radius_bottom_right = 8
	
		stylebox.border_width_left = 2
		stylebox.border_width_top = 2
		stylebox.border_width_right = 2
		stylebox.border_width_bottom = 2
	else:
		stylebox.corner_radius_top_left = 2
		stylebox.corner_radius_top_right = 2
		stylebox.corner_radius_bottom_left = 2
		stylebox.corner_radius_bottom_right = 2

	stylebox.bg_color = color

	ui_mainBar.add_theme_stylebox_override("fill", stylebox)

func setupHealth() -> void:
	ui_mainBar.max_value = healthController.health
	ui_whiteBar.max_value = healthController.health
	ui_blackBar.max_value = healthController.health

	ui_mainBar.value = healthController.health
	ui_whiteBar.value = healthController.health
	ui_blackBar.value = healthController.health
