class_name ElTataSlayer
extends CharacterBody2D

#Controllers
@onready var healthController := %HealthController as HealthController
@onready var healthBarController := %HealthBar as HealthBarController
@onready var dashController := %DashController as DashController
@onready var attackController := %AttackController as ElTataSlayerAttackController
@onready var animationController := %AnimationController as ElTataSlayerAnimationController

#Nodes
@onready var attackArea := $Weapon/AttackArea
@onready var collisionAttackMap := {
	"up": attackArea.get_node("UpCollision"),
	"down": attackArea.get_node("DownCollision"),
	"left": attackArea.get_node("LeftCollision"),
	"right": attackArea.get_node("RightCollision"),
	
	"2_up": attackArea.get_node("UpCollision2"),
	"2_down": attackArea.get_node("DownCollision2"),
	"2_left": attackArea.get_node("LeftCollision2"),
	"2_right": attackArea.get_node("RightCollision2"),
}
@onready var ui_attackCdBar = $UI/AttackCdBar

# Attributes
const HEALTH := 20
const HEALTH_COLOR := Color8(0, 158, 103)
const SPEED := 800
var weapon : Weapon

func _ready() -> void:
	weapon = Weapon.new(1, 0.1)
	setupControllers()
	disableAllAttackCollisions()

func setupControllers() -> void:
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
		attackController.attack(mousePosition, animateAttackCdBar)

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

func animateAttackCdBar() -> void:
	ui_attackCdBar.value = 0
	var tween = GameUtils.create_tween()
	tween.tween_property(ui_attackCdBar, "value", 100, weapon.cooldown + .4).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)

func disableAllAttackCollisions() -> void:
	for collision: CollisionPolygon2D in attackArea.get_children():
		collision.disabled = true

func _on_attack_area_body_entered(enemy: Enemy) -> void:
	enemy.takeDamage(weapon.damage)

#Activate attack collisions
func _on_animated_sprite_2d_frame_changed() -> void:
	var sprite = animationController.sprite
	var animationDirection = sprite.animation.replace("attack_", "")
	var isAttacking = sprite.animation.contains("attack")
	var currentFrame = sprite.frame
	var activationFrame = 2 if animationDirection.contains("2") else 4

	disableAllAttackCollisions()

	if isAttacking and currentFrame == activationFrame:
		collisionAttackMap[animationDirection].disabled = false
