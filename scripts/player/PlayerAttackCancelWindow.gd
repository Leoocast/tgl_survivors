class_name AttackCancelWindow
extends RefCounted

signal can_cancel()
signal should_finish()

var cancel_frame := 10
var end_frame := 34
var sprite: AnimatedSprite2D

var _watching := false

func setup(_sprite: AnimatedSprite2D, _cancel_frame: int, _end_frame: int) -> void:
	sprite = _sprite
	cancel_frame = _cancel_frame
	end_frame = _end_frame
	_watching = true
	watch()

func watch() -> void:
	while _watching:
		await sprite.frame_changed
		var frame = sprite.frame

		if frame == cancel_frame:
			can_cancel.emit()

		if frame >= end_frame:
			should_finish.emit()
			_watching = false