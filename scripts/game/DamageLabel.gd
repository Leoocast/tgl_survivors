class_name DamageLabel
extends Node2D

#Export
@export var damageLabel: Label
@export var criticLabel: Label
@export var shadow: Label
@export var parryLabel : Label
@export var criticSprite: Sprite2D

#Config
const LIFETIME: float = 0.8
const FADE_TIME: float = 0.2
const FLOAT_SPEED: float = 30.0

#Internal
var velocity: Vector2 = Vector2.UP * FLOAT_SPEED

#-------------------------#
func setup(damage: float, isCritic: bool = false, isParry: bool = false, perfectParry: bool = false) -> void:

	if isParry:
		hideLabels()
		parryLabel.show()

	if isCritic:
		damageLabel.hide()
		parryLabel.hide()
		criticSprite.show()

	if not isParry:
		var formatted: String = "%.2f" % damage
		formatted = formatted.rstrip("0").rstrip(".")
		
		assignTextToLabels(formatted)
		damageLabelEffect()

	# TODO Arregla esto ta bien qlero
	if isParry:
		if perfectParry:
			parryLabel.text = "PERFECT!"
			(parryLabel.get_node("ParryLabel") as Label).text = "PERFECT!"
		else:
			parryLabel.text = "GOOD!"
			(parryLabel.get_node("ParryLabel") as Label).text = "GOOD!"

	parryLabelEffect(perfectParry)

func parryLabelEffect(isPerfect: bool) -> void:

	if isPerfect:
		scale = Vector2.ONE * 2
	else:
		scale = Vector2.ONE 

	var tween: Tween = create_tween()

	# Scale back to normal
	tween.tween_property(self, "scale", Vector2.ONE,  0.5 * 0.25).set_delay( 0.5 * 0.25)

	await get_tree().create_timer( 0.5 - FADE_TIME * 2).timeout

	# Fade out
	tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, FADE_TIME)
	await tween.finished

	queue_free()

func damageLabelEffect() -> void:
	# Comienza invisible
	modulate.a = 0.0
	# Tamaño normal al inicio
	scale = Vector2.ONE  

	# Fade in + Scale up
	var tween: Tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, FADE_TIME)
	tween.parallel().tween_property(self, "scale", Vector2.ONE * 1.4, LIFETIME * 0.25)

	# Scale back to normal
	tween.tween_property(self, "scale", Vector2.ONE, LIFETIME * 0.25).set_delay(LIFETIME * 0.25)

	await get_tree().create_timer(LIFETIME - FADE_TIME * 2).timeout

	# Fade out
	tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, FADE_TIME)
	await tween.finished

	queue_free()

func assignTextToLabels(text: String) -> void:
	damageLabel.text = text
	criticLabel.text = text
	shadow.text = text

func _process(delta: float) -> void:
	global_position += velocity * delta

func hideLabels() -> void:
	damageLabel.hide()
	shadow.hide()
	criticSprite.hide()
	criticLabel.hide()