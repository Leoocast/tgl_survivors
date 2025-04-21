extends CharacterBody2D

@onready var dashController = preload(GameConstants.CONTROLLERS.DashController).new()
@onready var fireBallPower = $FireBallPower

const speed = 700
var attacking = false

func _ready() -> void:
	add_child(dashController)

func _physics_process(delta: float) -> void:
	flipWithMouse()
	
	if InputHelper.isDashing():
		dashController.tryDash()
	
	if dashController.isDashing:
		dash()
	else:
		move()
	
	if not attacking and InputHelper.isAttacking():
		attack()
	
	if not attacking:
		playAnimations()
		
			
func flipWithMouse() -> void:
	var mouse_pos = get_global_mouse_position()
	$AnimatedSprite2D.flip_h = mouse_pos.x < global_position.x

func move() -> void:
	var direction = InputHelper.getDirection()
	velocity = direction * speed
	move_and_slide()

func dash() -> void:
	velocity = dashController.dashDirection * dashController.dashSpeed
	move_and_slide()
	
func playAnimations() -> void:
	var direction = InputHelper.getDirection()
	if direction != Vector2.ZERO:
		$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("idle")

func attack() -> void:
	attacking = true
	fireBallPower.shoot()
	$AnimatedSprite2D.play("attack")
	await $AnimatedSprite2D.animation_finished
	attacking = false
