class_name Player
extends CharacterBody2D

#Controllers
@onready var healthController: PlayerHealthController = %HealthController as PlayerHealthController
@onready var dashController: PlayerDashController = %DashController as PlayerDashController
@onready var attackController: PlayerAttackController = %AttackController as PlayerAttackController
@onready var animationController: PlayerAnimationController = %AnimationController as PlayerAnimationController
@onready var aimController: PlayerAimController = $AimController as PlayerAimController
@onready var weaponManager: PlayerWeaponManager = %WeaponManager as PlayerWeaponManager
@onready var levelUpUi: LevelUpUI= %LevelUpUI as LevelUpUI
@onready var trail: PlayerTrail= $TrailContainer as PlayerTrail
@onready var stateMachine: StateMachine = $StateMachine as StateMachine

#Nodes
@onready var attackArea: Area2D = $Weapon/AttackArea as Area2D
@onready var levelUpDamageArea: Area2D = $LevelUpDamageArea as Area2D
@onready var expArea: Area2D = $ExpArea as Area2D
@onready var ssjAura: Node2D = $SsjAura as Node2D
@onready var camera: PlayerCamera = $Camera2D as PlayerCamera

# Attributes
@export var attributes: PlayerAttributesResource

#Config
var collisionAttackMap: PlayerAttackCollisionMap = PlayerAttackCollisionMap.new()

#Systems / Managers
var xpSystem: PlayerXPSystem = PlayerXPSystem.new()
var sfxManager: PlayerSFXManager = PlayerSFXManager.new()
var updatesManager: PlayerUpdatesManager = PlayerUpdatesManager.new()

#Internal
var realSpeed: float
var currentSpeed: float
var shieldingSpeed: float = 300
var currentCritProb: float

#Get/Set
var weapon: PlayerWeapon:
	get:
		return weaponManager.currentWeapon

var attack_impulse := Vector2.ZERO
var apply_attack_impulse := false

var isInParryWindow: bool = false
var isInPerfectParryWindow: bool = false
var parryType: String = ""
var justParriedSuccessfully = false
var wantsToShield := false
#-------------------------#
func _ready() -> void:
	# var joypads = Input.get_connected_joypads()
	# print("Joypads conectados: ", joypads)
	GameUtils.registerInGroup(self, GLOBALS.GROUPS.PLAYER)
	setupAttributes()
	setupComponents()
	disableAllAttackCollisions()
	#TODO
	# aimController.hide()

func setupAttributes() -> void:
	realSpeed = attributes.speed
	currentSpeed = attributes.speed
	currentCritProb = attributes.critProb

func setupComponents() -> void:
	weaponManager.setupPlayer(self)
	
	animationController.setupPlayer(self, ssjAura)
	healthController.setup(self, attributes.health)
	attackController.setup(self, weapon)
	dashController.setupPlayer()
	aimController.setupPlayer(self)
	
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

	weaponManager.weaponChanged.connect(on_weapon_changed)

func xpSucriptions() -> void:
	xpSystem.level_up.connect(attackController.on_level_up)
	xpSystem.level_up.connect(healthController.on_level_up)
	xpSystem.level_up.connect(animationController.on_level_up)

func levelUpUiSuscriptions() -> void:
	levelUpUi.upgrade_completed.connect(healthController.on_upgrade_completed)


# func _input(event):
# 	pass
	# if event is InputEventJoypadButton:
	# 	print("Botón presionado: ", event.button_index, " | Presionado: ", event.pressed)

	# if event is InputEventJoypadMotion:
	# 	print("Joystick: ", event.axis, " | Valor: ", event.axis_value)

func _physics_process(_delta: float) -> void:

	# InputHandler.debugJoypad()

	if GameState.isNotRunning():
		return
	
	if healthController.isDead:
		return

	wantsToShield = InputHandler.isShielding()

	# if InputHandler.isShielding():
	# 	currentSpeed = 300.0
	# else:
	# 	currentSpeed = realSpeed
	
	trail.drawTrail()

	if apply_attack_impulse:
		self.velocity = attack_impulse
		move_and_slide()
	elif not dashController.isDashing and not attackController.isAttacking:
		move()
	elif not dashController.isDashing:
		move_and_slide()
	
func move() -> void:
	var direction = InputHandler.getDirection()
	self.velocity = direction * currentSpeed

	if direction != Vector2.ZERO:
		move_and_slide()
	# move_and_slide()

func applyAttackImpulse(direction: Vector2, force: float) -> void:
	attack_impulse = direction.normalized() * force
	apply_attack_impulse = true
	await get_tree().process_frame
	attack_impulse = Vector2.ZERO
	apply_attack_impulse = false
	
func getMouseDirection() -> Vector2:

	var rightStickDirection = InputHandler.getRightStickDirection()

	if rightStickDirection != Vector2.ZERO:
		return rightStickDirection
	
	return (get_global_mouse_position() - global_position).normalized()

func disableAllAttackCollisions() -> void:
	for collision: CollisionPolygon2D in attackArea.get_children():
		if healthController.isDead:
			collision.call_deferred("set_disabled", true)
		else:
			collision.disabled = true

func triggerParry() -> void:

	print("PARRIED!")
	await GameUtils.freezeFrames(8)
	await GameUtils.applySlowMotion(0.4, 10, camera)

	# # await get_tree().create_timer(0.02).timeout
	# Engine.time_scale = 0.2
	
	# for i in range(4):  # 6 frames con slow-mo
	# 	await get_tree().process_frame

	# Engine.time_scale = 1.0

func isEnemyInParryCone(enemy: Node2D, maxAngleDeg := 90.0) -> bool:
	var toEnemy = (enemy.global_position - global_position).normalized()
	var aim = aimController.lastAimDirection.normalized()

	var angleBetween = rad_to_deg(aim.angle_to(toEnemy))

	return abs(angleBetween) <= maxAngleDeg

#Events
func _on_attack_area_body_entered(enemy: Enemy) -> void:

	attackController.damageEnemy(enemy)

	var sprite = animationController.sprite
	
	var first = sprite.animation.contains("1")
	var second = sprite.animation.contains("2")
	var third = sprite.animation.contains("3")

	if first:
		await GameUtils.freezeFrames(3)
	elif second:
		await GameUtils.freezeFrames(2)
	elif third:
		await GameUtils.freezeFrames(5)
	
	camera.shake(4, 4)
	

#Activate attack collisions
func _on_animated_sprite_2d_frame_changed() -> void:
	
	# TODO Esto hace 3 cosas, hay que separarlo y calcular
	# 1.- Activar los collider de ataque
	# 2.- Activar los impulsos de ataque
	# 1.- Activar que se detenga despues del impulso por frame

	var sprite = animationController.sprite
	var animationDirection = sprite.animation.replace("attack_", "")

	var isAttacking = sprite.animation.contains("attack")
	var currentFrame = sprite.frame

	var activationFrame = 6
	
	if animationDirection.contains("2"):
		activationFrame = 2
	
	if animationDirection.contains("3"):
		activationFrame = 3
	
	disableAllAttackCollisions()

	if isAttacking and currentFrame == activationFrame:
		collisionAttackMap.map[animationDirection].disabled = false

		# 2. Aplicar impulso
		var dir = InputHandler.getDirection()
		if dir == Vector2.ZERO:
			dir = animationController.lastFacingDirection

		var force = attackController.attackImpulses.get(attackController.currentAttackIndex, 150.0)
		applyAttackImpulse(dir, force)

	# Solamente la 3er animacion llega a mas de 9
	if sprite.animation.contains("3") and currentFrame == 6:
		self.velocity = Vector2.ZERO

func _on_exp_area_area_entered(area: Area2D) -> void:
	if area.is_in_group(GLOBALS.GROUPS.EXP_DROP):
		var expDrop = area as ExpDrop
		expDrop.flyToTarget(self)

func on_weapon_changed(weaponType: Enums.WeaponType) -> void:

	attackController.changeWeapon(weapon)

	if weaponType == Enums.WeaponType.BOW:
		aimController.show()
		return
	
	aimController.hide()
