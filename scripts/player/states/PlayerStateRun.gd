class_name PlayerStateRun
extends PlayerState

func on_physics_process(_delta: float) -> void:
	# TODO Cuando holdee shift
	# var mousePosition = player.getMouseDirection()
	
	
	if not player.dashController.isDashing:
		var inputDirection = InputHandler.getDirection()
		player.animationController.playRunDirection(inputDirection)

func on_input(_event: InputEvent) -> void:
	
	if InputHandler.isAttacking():
		stateMachine.enterState(states.PlayerStateAttack)

	if not InputHandler.isMoving():
		stateMachine.enterState(states.PlayerStateIdle)
		

	

	
