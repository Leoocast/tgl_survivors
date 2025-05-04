class_name Player
extends CharacterBody2D

#Controllers
@onready var healthController := %HealthController as HealthController
@onready var dashController := %DashController as PlayerDashController
@onready var attackController := %AttackController as ElTataSlayerAttackController

@onready var animationController := %AnimationController as ElTataSlayerAnimationController
@onready var game = get_parent() as GameState

#Nodes
@onready var expArea := $ExpArea
@onready var levelUpDamageArea := $LevelUpDamageArea
@onready var attackArea := $Weapon/AttackArea
@onready var ssjAura = $SsjAura
@onready var ui_attackCdBar = $UI/AttackCdBar
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

# Attributes
@export var health := 100 #20
@export var healthColor := Color8(150, 0, 0)
@export var baseSpeed := 550.0
@export var xpMultiplier = 1.3
@export var critProb := 0.1

#Internal
var speed := baseSpeed
var weapon : Weapon
var auraDamage := 3.0
var currentCritProb := critProb

#FIXME: Pasar esto a un controller de XP
#Exp System 
var xp := 0
var level := 1
var xpToNextLvl := 8
# var xpToNextLvl := 1

#Signals
signal take_damage_signal(damage: float)
signal lvl_up_signal(newLvl: int, xpNextLvl: int, currentXp: int)
signal add_xp_signal(xp: int)

#-------------------------#
func _ready() -> void:
	GameUtils.registerInGroup(self, Constants.GROUPS.PLAYER)
	weapon = Weapon.new(1, 0.5)
	setupControllers()
	disableAllAttackCollisions()

func setupControllers() -> void:
	animationController.setup($AnimatedSprite2D, ssjAura)
	healthController.setup(self, health)
	attackController.setup(self, weapon)
	dashController.setupPlayer()

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
		attackController.attack(mousePosition, animateAttackCdBar)

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

func takeDamage(damage: float) -> void:
	if healthController.isDead:
		return

	var mousePosition = calculateMousePosition()
	
	animationController.modulateTakingDamage()
		
	healthController.takeDamageTataSlayer(damage, mousePosition)
	take_damage_signal.emit(damage)

	await GameUtils.waitFor(0.1)
	animationController.modulateReset()
	
func animateAttackCdBar() -> void:
	ui_attackCdBar.value = 0
	var tween = GameUtils.create_tween()
	tween.tween_property(ui_attackCdBar, "value", 100, weapon.cooldown + .4).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)

func disableAllAttackCollisions() -> void:
	for collision: CollisionPolygon2D in attackArea.get_children():
		if healthController.isDead:
			collision.call_deferred("set_disabled", true)
		else:
			collision.disabled = true

#FIXME: XP System
func addExp(_xp : int) -> void:
	xp += _xp
	checkLvlUp()

func checkLvlUp() -> void:
	while xp >= xpToNextLvl:
		# Primero, llenar la barra al tope
		add_xp_signal.emit(xp)
		emit_signal("add_xp_signal", xpToNextLvl) # Llenar la barra visualmente
		
		xp -= xpToNextLvl
		
		# Subir nivel
		level += 1
		
		xpToNextLvl = int(xpToNextLvl * xpMultiplier)
		
		# Resetear barra para el siguiente nivel
		lvl_up_signal.emit(level, xpToNextLvl, 0) # XP a 0

	# Mostrar la experiencia sobrante
	add_xp_signal.emit(xp)

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
		collisionAttackMap[animationDirection].disabled = false

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
