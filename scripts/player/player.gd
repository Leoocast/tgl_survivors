class_name Player

extends CharacterBody2D

# Crear un health controller
var damageable := Damageable.new()
var health := 20

@onready var ui_greenBar := $HealthBar/GreenBar
@onready var ui_whiteBar := $HealthBar/WhiteBar
@onready var ui_blackBar := $HealthBar/Blackbar

@onready var dashController = preload(GameConstants.CONTROLLERS.DashController).new()
@onready var fireBallPower = $FireBallPower
@onready var ui_attackCdBar = $Control/AttackCdBar

const speed := 700
var attacking := false
var canAttack = true

func _ready() -> void:
	add_child(dashController)
	setupHealthUI()

func _physics_process(_delta: float) -> void:
	flipWithMouse()
	
	if InputHelper.isDashing():
		dashController.tryDash()
	
	if dashController.isDashing:
		$CollisionShape2D.disabled = true
		dash()
	else:
		$CollisionShape2D.disabled = false
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
	if not canAttack: 
		return

	canAttack = false
	attacking = true
	fireBallPower.shoot()
	$AnimatedSprite2D.play("attack")
	animateAttackCdBar()
	await $AnimatedSprite2D.animation_finished
	playAnimations()
	await GameHelper.waitFor(fireBallPower.cooldown)
	canAttack = true
	attacking = false

func animateAttackCdBar() -> void:
	ui_attackCdBar.value = 0
	var tween = GameHelper.create_tween()
	tween.tween_property(ui_attackCdBar, "value", 100, fireBallPower.cooldown + .4).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)

func takeDamage(damage: int) -> void:
	health -= damage
	updateHealthUI()

func setupHealthUI() -> void:
	ui_greenBar.max_value = health
	ui_whiteBar.max_value = health
	ui_blackBar.max_value = health

	ui_greenBar.value = health
	ui_whiteBar.value = health
	ui_blackBar.value = health

func updateHealthUI() -> void:
	ui_greenBar.value = health
	ui_whiteBar.value = health + 1
	ui_blackBar.value = health + 1

	await GameHelper.showHide(ui_whiteBar, 0.08)
	
	var tween = GameHelper.create_tween()
	tween.tween_property(ui_blackBar, "value", health, 0.3).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
