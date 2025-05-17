class_name PlayerStateShielding
extends PlayerState

func enter() -> void:

	print("Entrando!")

	player.aimController.lastAimDirection = player.animationController.lastFacingDirection
	player.currentSpeed = player.shieldingSpeed

func exit() -> void:
	player.currentSpeed = player.realSpeed

func on_physics_process(_delta: float) -> void:

	if player.dashController.isDashing:
		return

	player.animationController.playWalkDirection(player.aimController.lastAimDirection)

	if InputHandler.isAttacking():
		stateMachine.enterState(states.PlayerStateAttack)
	elif InputHandler.isParry():
		stateMachine.enterState(states.PlayerStateParry)
	elif InputHandler.isDashing():
		stateMachine.enterState(states.PlayerStateDash)
	elif not InputHandler.isShielding():
		if InputHandler.isMoving():
			stateMachine.enterState(states.PlayerStateRun)
		else:
			stateMachine.enterState(states.PlayerStateIdle)