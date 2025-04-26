class_name ElTataSlayer
extends CharacterBody2D

#Controllers
@onready var healthController := %HealthController as HealthController
@onready var healthBarController := %HealthBar as HealthBarController
@onready var dashController := %DashController as DashController
@onready var attackController := %AttackController as AttackController
@onready var animationController := %AnimationController as ElTataSlayerAnimationController

@onready var ui_attackCdBar = $UI/AttackCdBar

# Attributes
const HEALTH := 20
const HEALTH_COLOR := Color8(0, 158, 103)
const SPEED := 800
var weapon : Weapon

func _ready() -> void:
	weapon = Weapon.new(5, 0.1)
	healthController.setup(self, HEALTH)
	attackController.setup(self, weapon)
	dashController.setup(self, $CollisionShape2D)
	animationController.setup($AnimatedSprite2D)
	healthBarController.setup(self, healthController, HEALTH_COLOR)

func _physics_process(_delta: float) -> void:
	var mousePosition = calculateMousePosition()
	
	if InputHandler.isDashing():
		dashController.tryDash()

	if not dashController.isDashing:
		move()
		
	if not attackController.isAttacking and attackController.canAttack and InputHandler.isAttacking():
		attackController.elTataSlayerAttack(mousePosition)

	if not attackController.isAttacking:
		animationController.playDefault(mousePosition)
		
func move() -> void:
	var direction = InputHandler.getDirection()
	self.velocity = direction * SPEED
	move_and_slide()

func calculateMousePosition() -> Vector2:
	var mousePosition = get_global_mouse_position()
	var directionToMouse = (mousePosition - global_position).normalized()
	return directionToMouse

func takeDamage(damage: float) -> void:
	healthController.takeDamage(damage)
	healthBarController.takeDamage(damage)
