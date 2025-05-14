class_name PlayerCamera
extends Camera2D

var shake_intensity := 0.0
var shake_duration := 0
var original_offset := Vector2.ZERO

func shake(intensity: float = 8.0, duration_frames: int = 6) -> void:
	shake_intensity = intensity
	shake_duration = duration_frames
	original_offset = offset

func _process(_delta: float) -> void:
	if shake_duration > 0:
		offset = original_offset + Vector2(
			randf_range(-shake_intensity, shake_intensity),
			randf_range(-shake_intensity, shake_intensity)
		)
		shake_duration -= 1
	else:
		offset = original_offset