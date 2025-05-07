class_name PlayerDashController
extends Node

#Config
const SPEED: float = 1500
const DURATION: float = 0.14
const COOLDOWN: float = 0.5

#Setup player
var player: Node2D
var playerCollider: CollisionShape2D

#Internal
var isDashing: bool = false
var canDash: bool = true
var dashDirection: Vector2 = Vector2.ZERO

#-------------------------#
func setupPlayer() -> void:
	self.player = GameUtils.getPlayer()
	self.playerCollider = GameUtils.getPlayerCollider()

func _physics_process(_delta: float) -> void:
	if isDashing:
		executeDash()
	
	playerCollider.set_deferred("disabled", isDashing)
	
func tryDash() -> void:
	if not canDash:
		return
	
	dashDirection = InputHandler.getDirection().normalized()
	isDashing = true
	canDash = false
	
	# Dash duration
	await GameUtils.waitFor(DURATION)
	isDashing = false
	
	await smoothStop()

	# Cooldown
	await GameUtils.waitFor(COOLDOWN)
	canDash = true

func executeDash() -> void:
	player.velocity = dashDirection * SPEED
	player.move_and_slide()

func smoothStop() -> void:
	var velocity = dashDirection * SPEED
	for i in 10:
		await get_tree().create_timer(0.01).timeout
		velocity *= 0.75
		player.velocity = velocity
		player.move_and_slide()