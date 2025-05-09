class_name PlayerStateIdle
extends PlayerState

func on_physics_process(_delta: float) -> void:
	var mousePosition = player.getMouseDirection()
	player.animationController.playIdleMouse(mousePosition)

func on_input(_event: InputEvent) -> void:
	if InputHandler.isAttacking():
		stateMachine.enterState(states.PlayerStateAttack)

	if InputHandler.isMoving():
		stateMachine.enterState(states.PlayerStateRun)