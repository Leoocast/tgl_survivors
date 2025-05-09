class_name PlayerStateRun
extends PlayerState

func on_physics_process(_delta: float) -> void:
	var mousePosition = player.getMouseDirection()
	player.animationController.playRunMouse(mousePosition)

func on_input(_event: InputEvent) -> void:
	
	if InputHandler.isMoving():
		return

	stateMachine.enterState(states.PlayerStateIdle)