class_name DashController
extends Node2D


#Trail
@export var trail : Line2D
var trailQueue : Array
var trailMaxLenth : int

#Config
const SPEED := 1500
const DURATION := 0.2
const COOLDOWN := 0.5

#Setup player
var player : Node2D
var playerCollider : CollisionShape2D

#Internal
var isDashing := false
var canDash := true
var dashDirection := Vector2.ZERO


#-------------------------#
#FIXME: Que ElTataSlayer herede de player
func setup(_player: Node2D, _playerCollider: CollisionShape2D) -> void:
	self.player = _player
	self.playerCollider = _playerCollider

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
	
	# Cooldown
	await GameUtils.waitFor(COOLDOWN)
	canDash = true

func executeDash() -> void:
	player.velocity = dashDirection * SPEED
	player.move_and_slide()
