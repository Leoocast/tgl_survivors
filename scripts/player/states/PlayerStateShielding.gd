class_name PlayerStateShielding
extends PlayerState

func enter() -> void:
	player.aimController.lastAimDirection = player.animationController.lastFacingDirection
	player.currentSpeed = player.shieldingSpeed

func exit() -> void:
	player.currentSpeed = player.realSpeed

func on_physics_process(_delta: float) -> void:

	if player.dashController.isDashing:
		return

	player.animationController.playWalkDirection(player.aimController.lastAimDirection)

	if InputHandler.isParry():
		stateMachine.enterState(states.PlayerStateParry)

	if not InputHandler.isShielding():
		if InputHandler.isMoving():
			stateMachine.enterState(states.PlayerStateRun)
		else:
			stateMachine.enterState(states.PlayerStateIdle)

	if InputHandler.isAttacking():
		stateMachine.enterState(states.PlayerStateAttack)

	if InputHandler.isDashing():
		stateMachine.enterState(states.PlayerStateDash)