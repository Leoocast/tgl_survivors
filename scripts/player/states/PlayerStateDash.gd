class_name PlayerStateDash
extends PlayerState

func enter() -> void:
	player.dashController.tryDash()
	
func on_physics_process(_delta: float) -> void:

	if player.dashController.isDashing:
		return

	if InputHandler.isAttacking() and player.attackController.canAttack:
		stateMachine.enterState(states.PlayerStateAttack)
	
	if InputHandler.isShielding():
		stateMachine.enterState(states.PlayerStateShielding)
	elif InputHandler.isMoving():
		stateMachine.enterState(states.PlayerStateRun)
	else:
		stateMachine.enterState(states.PlayerStateIdle)