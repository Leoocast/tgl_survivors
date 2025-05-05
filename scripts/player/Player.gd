class_name Player
extends CharacterBody2D

#Controllers
@onready var healthController := %HealthController as HealthController
@onready var dashController := %DashController as PlayerDashController
#TODO: PENDIENTE EL PLAYER
@onready var attackController := %AttackController as ElTataSlayerAttackController
@onready var animationController := %AnimationController as ElTataSlayerAnimationController
#TODO: REVISAR ESTO
@onready var game = get_parent() as GameState

#Nodes
@onready var attackArea := $Weapon/AttackArea
@onready var collisionAttackMap := PlayerAttackCollisionMap.new()
@onready var levelUpDamageArea := $LevelUpDamageArea
@onready var expArea := $ExpArea
@onready var ssjAura = $SsjAura

#TODO: Revisar si esto va aqui? Lo necesitamos aun?
@onready var ui_attackCdBar = $UI/AttackCdBar

# Attributes
@export var health := 5 #20
@export var healthColor := Color8(150, 0, 0)
@export var baseSpeed := 550.0
@export var critProb := 0.1

#Systems
var xpSystem: PlayerXPSystem = PlayerXPSystem.new()

#Internal
var speed := baseSpeed
var weapon : Weapon
var auraDamage := 3.0
var currentCritProb := critProb

#-------------------------#
func _ready() -> void:
	GameUtils.registerInGroup(self, Constants.GROUPS.PLAYER)
	collisionAttackMap.setup(attackArea)
	weapon = Weapon.new(1, 0.5)
	setupControllers()
	disableAllAttackCollisions()

func setupControllers() -> void:
	animationController.setup($AnimatedSprite2D, ssjAura)
	healthController.setup(self, health)
	attackController.setup(self, weapon)
	dashController.setupPlayer()

	healthController.connect("died", on_player_died)
	healthController.connect("taking_damage_started", on_taking_damage_started)
	healthController.connect("taking_damage_finished", on_taking_damage_finished)

func _physics_process(_delta: float) -> void:

	drawTrail()

	if game.isPaused:
		return

	if healthController.isDead:
		return
	
	var mousePosition = calculateMousePosition()
	
	if InputHandler.isDashing():
		dashController.tryDash()

	if not dashController.isDashing:
		move()
		
	if not attackController.isAttacking and attackController.canAttack and InputHandler.isAttacking():
		attackController.attack(mousePosition)

	if not attackController.isAttacking:
		animationController.playDefault(mousePosition)
	
func move() -> void:
	var direction = InputHandler.getDirection()
	self.velocity = direction * speed
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

#Consumers #FIXME: Pasar esto al animation controller
func on_player_died() -> void:
	var mousePosition = calculateMousePosition()
	animationController.playDeath(mousePosition)

func on_taking_damage_started() -> void:
	animationController.modulateTakingDamage()

func on_taking_damage_finished() -> void:
	await GameUtils.waitFor(0.1)
	animationController.modulateReset()

#Updates FIXME:, mover a UpdatesController
func increaseMovementSpeed(multiplier: float) -> void:
	speed += multiplier

func increaseAttackDamage(multiplier: float) -> void:
	weapon = Weapon.new(weapon.damage * multiplier, weapon.cooldown)

func increaseAttackSpeed(multiplier: float) -> void:
	animationController.setAttackFpsMultiplier(multiplier)

#Signals
func _on_attack_area_body_entered(enemy: Enemy) -> void:
	var isCritic := randf() < critProb

	var realDamage = weapon.damage * 2 if isCritic else weapon.damage  

	enemy.takeDamage(realDamage, false, isCritic)

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


#Trail
@export var trail : Line2D
var trailQueue : Array
var trailMaxLenth = 20

func drawTrail() -> void:
	var tween := create_tween()

	if dashController.isDashing:
		tween.tween_property(trail, "modulate:a", 1.0, 0.1)
	else:
		tween.tween_property(trail, "modulate:a", 0.0, 0.3)

	var localPos = trail.to_local(global_position) + Vector2(40, 40)
	trailQueue.push_front(localPos)

	if trailQueue.size() > trailMaxLenth:
		trailQueue.pop_back()

	trail.clear_points()
	for point in trailQueue:
		trail.add_point(point)
