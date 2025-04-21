extends Node

class_name DashController

var isDashing := false
var canDash := true
var dashDirection := Vector2.ZERO

# Config
const dashSpeed := 1500
const dashDuration := 0.2
const dashCooldown := 0.5

func tryDash() -> void:
	if not canDash:
		return
	
	dashDirection = InputHelper.getDirection().normalized()
	isDashing = true
	canDash = false
	
	# Dash duration
	var game = get_tree()
	await game.create_timer(dashDuration).timeout
	isDashing = false
	
	# Cooldown
	await game.create_timer(dashCooldown).timeout
	canDash = true
