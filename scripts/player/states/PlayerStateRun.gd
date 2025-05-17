class_name PlayerStateRun
extends PlayerState

func on_physics_process(_delta: float) -> void:
	# TODO Cuando holdee shift
	# var mousePosition = player.getMouseDirection()
	
	
	if player.dashController.isDashing:
		return

	var inputDirection = InputHandler.getDirection()
	player.animationController.playRunDirection(inputDirection)

func on_input(_event: InputEvent) -> void:
	
	if InputHandler.isAttacking():
		stateMachine.enterState(states.PlayerStateAttack)

	elif InputHandler.isShielding():
		stateMachine.enterState(states.PlayerStateShielding)

	elif not InputHandler.isMoving():
		stateMachine.enterState(states.PlayerStateIdle)
		
	elif InputHandler.isDashing() and not GameState.isNotRunning():
		stateMachine.enterState(states.PlayerStateDash)

	
