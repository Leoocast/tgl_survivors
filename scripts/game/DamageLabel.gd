class_name DamageLabel
extends Node2D

#Export
@export var damageLabel: Label
@export var criticLabel: Label
@export var shadow: Label
@export var criticSprite: Sprite2D

#Config
const LIFETIME: float = 0.8
const FADE_TIME: float = 0.2
const FLOAT_SPEED: float = 30.0

#Internal
var velocity: Vector2 = Vector2.UP * FLOAT_SPEED

#-------------------------#
func setup(damage: float, isCritic: bool = false) -> void:

	if isCritic:
		damageLabel.hide()
		criticSprite.show()

	var formatted: String = "%.2f" % damage
	formatted = formatted.rstrip("0").rstrip(".")
	
	assignTextToLabels(formatted)

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
