class_name Player
extends CharacterBody2D

#Controllers
@onready var healthController := %HealthController as HealthController
@onready var healthBarController := %HealthBar as HealthBarController
@onready var dashController := %DashController as DashController
@onready var attackController := %AttackController as AttackController
@onready var animationController := %PlayerAnimationController as AnimationController

#Nodes
@onready var fireBallPower = $FireBallPower

# Attributes
const HEALTH := 20
const HEALTH_COLOR := Color8(0, 158, 103)
const SPEED := 600
const ATTACK_DAMAGE := 1.0

@onready var ui_attackCdBar = $UI/AttackCdBar

func _ready() -> void:
	healthController.setup(self, HEALTH)
	attackController.setup(self, fireBallPower)
	dashController.setup(self, $CollisionShape2D)
	animationController.setup($AnimatedSprite2D)
	healthBarController.setup(self, healthController, HEALTH_COLOR)
	
func _physics_process(_delta: float) -> void:
	flipSpriteMouse()
	
	if not dashController.isDashing:
		move()
		
	if InputHelper.isDashing():
		dashController.tryDash()
	
	if not attackController.isAttacking and attackController.canAttack and InputHelper.isAttacking():
		attackController.attack(animateAttackCdBar)
	
	if not attackController.isAttacking:
		animationController.playDefault()
		
			
func flipSpriteMouse() -> void:
	var mouse_pos = get_global_mouse_position()
	animationController.flipHorizontal(mouse_pos.x < global_position.x)

func move() -> void:
	var direction = InputHelper.getDirection()
	self.velocity = direction * SPEED
	move_and_slide()

func animateAttackCdBar() -> void:
	ui_attackCdBar.value = 0
	var tween = GameHelper.create_tween()
	tween.tween_property(ui_attackCdBar, "value", 100, fireBallPower.cooldown + .4).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)

func takeDamage(damage: float) -> void:
	healthController.takeDamage(damage)
	healthBarController.takeDamage(damage)
