class_name PlayerStateParry
extends PlayerState

func enter() -> void:
	player.currentSpeed = 0
	player.animationController.playParryDirection(player.aimController.lastAimDirection)
	
	await parryWindow()
	
	player.animationController.sprite.animation_finished.connect(_on_parry_finished, CONNECT_ONE_SHOT)



func exit() -> void:
	player.currentSpeed = player.realSpeed

	if player.animationController.sprite.animation_finished.is_connected(_on_parry_finished):
		player.animationController.sprite.animation_finished.disconnect(_on_parry_finished)
	

func _on_parry_finished() -> void:
	if InputHandler.isShielding():
		stateMachine.enterState(states.PlayerStateShielding)
	elif InputHandler.isDashing():
		stateMachine.enterState(states.PlayerStateDash)
	elif InputHandler.isAttacking():
		stateMachine.enterState(states.PlayerStateAttack)
	elif InputHandler.isMoving():
		stateMachine.enterState(states.PlayerStateRun)
	else:
		stateMachine.enterState(states.PlayerStateIdle)

func parryWindow() -> void:
	# Activa la ventana durante N frames o tiempo
	player.isInParryWindow = true
	await get_tree().create_timer(0.2).timeout 
	player.isInParryWindow = false