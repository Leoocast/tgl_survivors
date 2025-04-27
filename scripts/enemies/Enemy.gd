class_name Enemy
extends CharacterBody2D

#Nodes
@onready var healthController := %HealthController as HealthController
@onready var healthBarController := %HealthBar as HealthBarController
@onready var attackController := %AttackController as AttackController
@onready var animationController := %AnimationController as AnimationController

#Config
var speed : float 
var stopDistance : float
var weapon: Weapon
var player: ElTataSlayer

#Internal
var isTakingDamage := false
var isPlayerInRange := false

#-------------------------#
func setup(data: Dictionary) -> void:
	self.speed = data.speed
	self.stopDistance = data.stopDistance 
	self.weapon = data.weapon

	healthController.setup(self, data.health)
	healthBarController.setup(self, healthController, data.healthColor)
	attackController.setup(self, data.weapon)
	animationController.setup(data.sprite)

func setupPlayer(_player: Node2D) -> void:
	self.player = _player


func moveTowardsPlayer() -> void:
	if player == null or healthController.isDead or attackController.isAttacking or isTakingDamage: return
	if self.global_position == Vector2.ZERO: return

	var distance = global_position.distance_to(player.global_position)

	if distance > stopDistance:
		var direction = global_position.direction_to(player.global_position)
		self.velocity = direction * speed
		move_and_slide()

func takeDamage(damage: float) -> void:
	isTakingDamage = true
	healthController.takeDamage(damage)
	animationController.playTakeDamage()
	GameUtils.flash(animationController.sprite)
	healthBarController.takeDamage(damage)
	if healthController.isDead:
		death()
	else:
		await animationController.waitAnimationFinished()
		animationController.playIdle()
	isTakingDamage = false

func attackPlayer() -> void:
	if not isPlayerInRange or healthController.isDead: 
		return
	
	await attackController.attack(func ():, animationController.playIdle)
   
func death() -> void:
	pass
