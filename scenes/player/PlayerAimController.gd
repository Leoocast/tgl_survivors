class_name PlayerAimController
extends Node2D

#Config
var player: Player

#Internal
var lastAimDirection := Vector2.RIGHT 
#-------------------------#
func setupPlayer(_player: Player) -> void:
	self.player = _player

func _process(_delta: float) -> void:
	lookAtMouse()

func lookAtMouse() -> void:
	var rightStickDirection = InputHandler.getRightStickDirection()
	
	if InputHandler.isShielding():
		if rightStickDirection != Vector2.ZERO:
			lastAimDirection = rightStickDirection
		self.rotation = lastAimDirection.angle()
	else:
		self.rotation = player.animationController.lastFacingDirection.angle()
