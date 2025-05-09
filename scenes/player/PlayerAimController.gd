class_name PlayerAimController
extends Node2D

var player: Player

func setupPlayer(_player: Player) -> void:
	self.player = _player

func _process(_delta: float) -> void:
	lookAtMouse()

func lookAtMouse() -> void:
	var mouse_pos = player.get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()
	self.rotation = direction.angle()
