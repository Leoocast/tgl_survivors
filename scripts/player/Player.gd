class_name Player
extends CharacterBody2D

#Controllers
@onready var healthController := %HealthController as HealthController
@onready var dashController := %DashController as PlayerDashController
@onready var attackController := %AttackController as PlayerAttackController
@onready var animationController := %AnimationController as PlayerAnimationController
@onready var trail = $TrailContainer as PlayerTrail

#TODO: REVISAR ESTO
@onready var game = get_parent() as GameState

#Nodes
@onready var weapon: Weapon = $Weapon 
@onready var collisionAttackMap := PlayerAttackCollisionMap.new()
@onready var attackArea := $Weapon/AttackArea
@onready var levelUpDamageArea := $LevelUpDamageArea
@onready var expArea := $ExpArea
@onready var ssjAura = $SsjAura

# Attributes
@export var attributes : PlayerAttributesResource

#Systems / Managers
var xpSystem: PlayerXPSystem = PlayerXPSystem.new()
var sfxManager: PlayerSFXManager = PlayerSFXManager.new()
var updatesManager: PlayerUpdatesManager = PlayerUpdatesManager.new()

#Internal
var currentSpeed: float
var currentCritprob: float

#-------------------------#
func _ready() -> void:
	GameUtils.registerInGroup(self, Constants.GROUPS.PLAYER)
	setupAttributes()
	setupComponents()
	disableAllAttackCollisions()

func setupAttributes() -> void:
	currentSpeed = attributes.speed
	currentCritprob = attributes.critProb

func setupComponents() -> void:
	animationController.setupPlayer(self, ssjAura)
	healthController.setup(self, attributes.health)
	attackController.setup(self, weapon)
	dashController.setupPlayer()
	
	updatesManager.setupPlayer(self)
	sfxManager.setupPlayer(self)
	trail.setupPlayer(self)
	weapon.setup(1,0)
	collisionAttackMap.setup(attackArea)

	healthSuscriptions()
	attackSuscriptions()
	
#Suscriptions
func healthSuscriptions() -> void: 
	healthController.connect("died", animationController.on_player_died)
	healthController.connect("taking_damage_started", animationController.on_taking_damage_started)
	healthController.connect("taking_damage_finished", animationController.on_taking_damage_finished)

func attackSuscriptions() -> void:
	attackController.connect("attack_animation_started", animationController.on_attack_animation_started)
	attackController.connect("attack_animation_started", sfxManager.on_attack_animation_started)

func _physics_process(_delta: float) -> void:
	if game.isPaused:
		return

	if healthController.isDead:
		return
	
	trail.drawTrail()

	var mousePosition = calculateMousePosition()
	
	if InputHandler.isDashing():
		dashController.tryDash()

	if not dashController.isDashing:
		move()
		
	if not attackController.isAttacking and attackController.canAttack and InputHandler.isAttacking():
		attackController.attack()

	if not attackController.isAttacking:
		animationController.playDefaultMouse(mousePosition)
	
func move() -> void:
	var direction = InputHandler.getDirection()
	self.velocity = direction * currentSpeed
	move_and_slide()

func calculateMousePosition() -> Vector2:
	var mousePosition = get_global_mouse_position()
	var directionToMouse = (mousePosition - global_position).normalized()
	return directionToMouse

func disableAllAttackCollisions() -> void:
	for collision: CollisionPolygon2D in attackArea.get_children():
		if healthController.isDead:
			collision.call_deferred("set_disabled", true)
		else:
			collision.disabled = true

#Events
func _on_attack_area_body_entered(enemy: Enemy) -> void:
	attackController.damageEnemy(enemy)

#Activate attack collisions
func _on_animated_sprite_2d_frame_changed() -> void:
	var sprite = animationController.sprite
	var animationDirection = sprite.animation.replace("attack_", "")
	var isAttacking = sprite.animation.contains("attack")
	var currentFrame = sprite.frame
	var activationFrame = 2 if animationDirection.contains("2") else 4

	disableAllAttackCollisions()

	if isAttacking and currentFrame == activationFrame:
		collisionAttackMap.map[animationDirection].disabled = false

func _on_exp_area_area_entered(area: Area2D) -> void:
	if area.is_in_group(Constants.GROUPS.EXP_DROP):
		var expDrop = area as ExpDrop
		expDrop.flyToTarget(self)
