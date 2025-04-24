class_name DashController
extends Node

# Config
const SPEED := 1500
const DURATION := 0.2
const COOLDOWN := 0.5

#Setup player
var player : Player
var playerCollider : CollisionShape2D

#Internal
var isDashing := false
var canDash := true
var dashDirection := Vector2.ZERO

#-------------------------#
func setup(_player: Player, _playerCollider: CollisionShape2D) -> void:
	self.player = _player
	self.playerCollider = _playerCollider

func _physics_process(_delta: float) -> void:
	if isDashing:
		executeDash()
	
	playerCollider.set_deferred("disabled", isDashing)
	
func tryDash() -> void:
	if not canDash:
		return
	
	dashDirection = InputHelper.getDirection().normalized()
	isDashing = true
	canDash = false
	
	# Dash duration
	await GameHelper.waitFor(DURATION)
	isDashing = false
	
	# Cooldown
	await GameHelper.waitFor(COOLDOWN)
	canDash = true

func executeDash() -> void:
	player.velocity = dashDirection * SPEED
	player.move_and_slide()
