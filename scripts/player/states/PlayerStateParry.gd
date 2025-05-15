class_name PlayerStateParry
extends PlayerState

var wasPerfectParry := false

func enter() -> void:
	player.currentSpeed = 0
	player.animationController.playParryDirection(player.aimController.lastAimDirection)

	# PROTECCIÓN extra: evita reconectar la señal si ya estaba conectada
	if player.animationController.sprite.animation_finished.is_connected(_on_parry_finished):
		player.animationController.sprite.animation_finished.disconnect(_on_parry_finished)

	# CONECTAR ANTES por si el parry es perfecto y termina ANTES de que tú lo hagas manual
	player.animationController.sprite.animation_finished.connect(_on_parry_finished, CONNECT_ONE_SHOT)

	# Ahora sí puedes entrar a la ventana de parry
	await startParryWindow()

func exit() -> void:
	player.currentSpeed = player.realSpeed

	if player.animationController.sprite.animation_finished.is_connected(_on_parry_finished):
		player.animationController.sprite.animation_finished.disconnect(_on_parry_finished)
	
	player.animationController.sprite.stop()

func on_process(_delta):
	if player.justParriedSuccessfully and player.isInPerfectParryWindow:
		player.justParriedSuccessfully = false  

		var parryAnim := player.animationController.sprite.animation
		var totalFrames := player.animationController.sprite.sprite_frames.get_frame_count(parryAnim)

		# Saltar al último frame de la animación de parry
		player.animationController.sprite.frame = totalFrames - 1

		# _on_parry_finished()
		
func _on_parry_finished() -> void:
	if InputHandler.isAttacking():
		stateMachine.enterState(states.PlayerStateAttack)
	elif InputHandler.isShielding():
		stateMachine.enterState(states.PlayerStateShielding)
	elif InputHandler.isDashing():
		stateMachine.enterState(states.PlayerStateDash)
	elif InputHandler.isMoving():
		stateMachine.enterState(states.PlayerStateRun)
	else:
		stateMachine.enterState(states.PlayerStateIdle)

func startParryWindow() -> void:
	player.isInParryWindow = true
	player.isInPerfectParryWindow = true

	await get_tree().create_timer(0.05).timeout  # ~3 frames a 60fps
	player.isInPerfectParryWindow = false    

	await get_tree().create_timer(0.15).timeout  # ~9 frames a 60fps
	player.isInParryWindow = false            
