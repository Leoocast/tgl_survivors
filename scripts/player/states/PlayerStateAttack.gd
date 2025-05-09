class_name PlayerStateAttack
extends PlayerState

func enter() -> void:
	if not player.attackController.canAttack:
		return

	player.attackController.attack()

func on_physics_process(_delta: float) -> void:
	if not player.attackController.isAttacking and not InputHandler.isAttacking():
		if InputHandler.isMoving():
			stateMachine.enterState(states.PlayerStateRun)
		else:
			stateMachine.enterState(states.PlayerStateIdle)
	
	if InputHandler.isAttacking() and player.attackController.canAttack:
		player.attackController.attack()
	

