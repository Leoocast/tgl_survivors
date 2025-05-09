class_name Player
extends CharacterBody2D

#Controllers
@onready var healthController: PlayerHealthController = %HealthController as PlayerHealthController
@onready var dashController: PlayerDashController = %DashController as PlayerDashController
@onready var attackController: PlayerAttackController = %AttackController as PlayerAttackController
@onready var animationController: PlayerAnimationController = %AnimationController as PlayerAnimationController
@onready var weaponManager: PlayerWeaponManager = %WeaponManager as PlayerWeaponManager
@onready var levelUpUi: LevelUpUI= %LevelUpUI as LevelUpUI
@onready var trail: PlayerTrail= $TrailContainer as PlayerTrail

#Nodes
@onready var attackArea: Area2D = $Weapon/AttackArea as Area2D
@onready var levelUpDamageArea: Area2D = $LevelUpDamageArea as Area2D
@onready var expArea: Area2D = $ExpArea as Area2D
@onready var ssjAura: Node2D = $SsjAura as Node2D

# Attributes
@export var attributes: PlayerAttributesResource

#Config
var collisionAttackMap: PlayerAttackCollisionMap = PlayerAttackCollisionMap.new()

#Systems / Managers
var xpSystem: PlayerXPSystem = PlayerXPSystem.new()
var sfxManager: PlayerSFXManager = PlayerSFXManager.new()
var updatesManager: PlayerUpdatesManager = PlayerUpdatesManager.new()

#Internal
var currentSpeed: float
var currentCritProb: float

#Get/Set
var weapon: PlayerWeapon:
	get:
		return weaponManager.currentWeapon

#-------------------------#
func _ready() -> void:
	GameUtils.registerInGroup(self, GLOBALS.GROUPS.PLAYER)
	setupAttributes()
	setupComponents()
	disableAllAttackCollisions()

func setupAttributes() -> void:
	currentSpeed = attributes.speed
	currentCritProb = attributes.critProb

func setupComponents() -> void:
	weaponManager.setupPlayer(self)
	
	animationController.setupPlayer(self, ssjAura)
	healthController.setup(self, attributes.health)
	attackController.setup(self, weapon)
	dashController.setupPlayer()
	
	updatesManager.setupPlayer(self)
	sfxManager.setupPlayer(self)
	trail.setupPlayer(self)
	collisionAttackMap.setup(attackArea)

	healthSuscriptions()
	attackSuscriptions()
	xpSucriptions()
	
#Suscriptions
func healthSuscriptions() -> void: 
	healthController.died.connect(animationController.on_player_died)
	healthController.taking_damage_started.connect(animationController.on_taking_damage_started)
	healthController.taking_damage_finished.connect(animationController.on_taking_damage_finished)

func attackSuscriptions() -> void:
	attackController.attack_animation_started.connect(animationController.on_attack_animation_started)
	attackController.attack_animation_started.connect(sfxManager.on_attack_animation_started)

func xpSucriptions() -> void:
	xpSystem.level_up.connect(attackController.on_level_up)
	xpSystem.level_up.connect(healthController.on_level_up)
	xpSystem.level_up.connect(animationController.on_level_up)

func levelUpUiSuscriptions() -> void:
	levelUpUi.upgrade_completed.connect(healthController.on_upgrade_completed)

func _physics_process(_delta: float) -> void:
	if GameState.isNotRunning():
		return
	
	if healthController.isDead:
		return
	
	if InputHandler.isTryingSwapWeapons():
		weaponManager.swapWeapons()

	trail.drawTrail()

	if InputHandler.isDashing():
		dashController.tryDash()

	if not dashController.isDashing:
		move()
	
func move() -> void:
	var direction = InputHandler.getDirection()
	self.velocity = direction * currentSpeed
	move_and_slide()

func getMouseDirection() -> Vector2:
	return (get_global_mouse_position() - global_position).normalized()

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
	if area.is_in_group(GLOBALS.GROUPS.EXP_DROP):
		var expDrop = area as ExpDrop
		expDrop.flyToTarget(self)
