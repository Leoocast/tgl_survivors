class_name PlayerStateIdle
extends PlayerState

func on_physics_process(_delta: float) -> void:
	var mousePosition = player.getMouseDirection()
	player.animationController.playIdleMouse(mousePosition)

func on_input(_event: InputEvent) -> void:
	
	if not InputHandler.isMoving():
		return
	
	stateMachine.enterState(states.PlayerStateRun)