class_name PlayerStateParry
extends PlayerState

var wasPerfectParry := false

func enter() -> void:
	player.currentSpeed = 0
	player.animationController.playParryDirection(player.aimController.lastAimDirection)
	
	if player.animationController.sprite.animation_finished.is_connected(_on_parry_finished):
		player.animationController.sprite.animation_finished.disconnect(_on_parry_finished)

	wasPerfectParry = false
	await startParryWindow()

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

func onParryCancel() -> void:
	if InputHandler.isAttacking():
		stateMachine.enterState(states.PlayerStateAttack)
	elif InputHandler.isDashing():
		stateMachine.enterState(states.PlayerStateDash)
	elif InputHandler.isMoving():
		stateMachine.enterState(states.PlayerStateRun)

func startParryWindow() -> void:
	player.isInParryWindow = true
	player.isInPerfectParryWindow = true

	await get_tree().create_timer(0.05).timeout  # ~3 frames a 60fps
	player.isInPerfectParryWindow = false    

	# Si el parry fue perfecto y ya se consumó, cancela la animación aquí
	if wasPerfectParry:
		print("ANIMATION CANCELED!!")
		onParryCancel()
		player.isInParryWindow = false  
		return

	await get_tree().create_timer(0.15).timeout  # ~9 frames a 60fps
	player.isInParryWindow = false            
