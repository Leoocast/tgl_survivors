class_name EnemyHealthBarController
extends Control

#Setup
var entity : Node2D
var healthController : HealthController
var color : Color
var isBoss := false

#Nodes
#0-Blackbar #1-Mainbar #2Whitebar
@export var normalBarArray : Array[ProgressBar]
@export var bossBarArray : Array[ProgressBar]

#Vars
var alreadyShowed := false

#-------------------------#
func setup(_entity: Node2D, _healthController: HealthController, _color: Color, _isBoss : bool = false) -> void:
	self.entity = _entity
	self.healthController = _healthController
	self.color = _color
	self.isBoss = _isBoss

	createMainBar()
	setupHealth()
	setupIsBoss()
	
func takeDamage(damage: float) -> void:
	flashWhenTakeDamage(normalBarArray, damage)
	flashWhenTakeDamage(bossBarArray, damage)

func hideBars() -> void:
	for bar in normalBarArray:
		bar.hide()

func showBars() -> void:
	for bar in normalBarArray:
		bar.show()
	createMainBar()
	alreadyShowed = true

func createMainBar() -> void:
	var stylebox = StyleBoxFlat.new()

	#FIXME:
	if not isBoss:
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

	normalBarArray[1].add_theme_stylebox_override("fill", stylebox)

func setupIsBoss() -> void:
	if isBoss:
		$Boss.show()
		$Normal.hide()
	else:
		$Normal.show()
		$Boss.hide()

func setupHealth() -> void:
	for bar in normalBarArray:
		bar.max_value = healthController.health
		bar.value = healthController.health

	for bar in bossBarArray:
		bar.max_value = healthController.health
		bar.value = healthController.health

func flashWhenTakeDamage(bars :  Array[ProgressBar], damage: float) -> void:
	var current = healthController.health

	var black = bars[0]
	var main = bars[1]
	var white = bars[2]

	main.value = current
	white.value = current + damage
	black.value = current + damage

	await GameUtils.showHide(white, 0.08)

	var tween = GameUtils.create_tween()
	tween.tween_property(black, "value", current, 0.3).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)