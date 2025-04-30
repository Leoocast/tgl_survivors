class_name DamageLabel
extends Node2D

@onready var damage_label := $DamageLabel

const LIFETIME := 0.8
const FADE_TIME := 0.2
const FLOAT_SPEED := 30.0

var velocity := Vector2.UP * FLOAT_SPEED

func setup(damage: float) -> void:
	var formatted := "%.2f" % damage
	formatted = formatted.rstrip("0").rstrip(".")
	damage_label.text = formatted
	# damage_label.text = str(int(round(damage)))
	modulate.a = 0.0  # Comienza invisible

	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 1.0, FADE_TIME)  # Fade in

	await get_tree().create_timer(LIFETIME - FADE_TIME * 2).timeout

	tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, FADE_TIME)  # Fade out
	await tween.finished

	queue_free()

func _process(delta: float) -> void:
	global_position += velocity * delta
