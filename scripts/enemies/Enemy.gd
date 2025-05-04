class_name Enemy
extends CharacterBody2D

#Preload
const DAMAGE_LABEL_ASSET = preload("res://scenes/game/damage_label.tscn")

#Nodes
@onready var healthController := %HealthController as HealthController
@onready var healthBarController := %HealthBar as EnemyHealthBarController
@onready var attackController := %AttackController as AttackController
@onready var animationController := %AnimationController as AnimationController

#Config
var speed : float 
var stopDistance : float
var weapon: Weapon
var player: Player
var game : GameState
var isBoss := false
#Internal
var isTakingDamage := false
var isPlayerInRange := false

#SFX
@onready var soundEffectPlayer := AudioStreamPlayer.new()
var sfx_hurt : AudioStream

#-------------------------#
func setup(data: Dictionary) -> void:
	self.speed = data.speed
	self.stopDistance = data.stopDistance 
	self.weapon = data.weapon
	self.sfx_hurt = data.sfx_hurt

	#FIXME:
	if isBoss:
		data.health *= 2
		data.weapon.damage *= 2

	healthController.setup(self, data.health)
	healthBarController.setup(self, healthController, data.healthColor, isBoss)
	attackController.setup(self, data.weapon)
	animationController.setup(data.sprite)
	add_child(soundEffectPlayer)

#FIXME:
func setupPlayer(_game : GameState, zIndex : int = 0 ) -> void:
	self.player = GameUtils.getPlayer()
	self.game = _game
	self.z_index = zIndex

func moveTowardsPlayer() -> void:
	if player == null or healthController.isDead or attackController.isAttacking or isTakingDamage: return
	if self.global_position == Vector2.ZERO: return

	var distance = global_position.distance_to(player.global_position)

	if distance > stopDistance:
		var direction = global_position.direction_to(player.global_position)
		self.velocity = direction * speed
		move_and_slide()

func takeDamage(damage: float, damageByLevelUp: bool = false, isCritic : bool = false) -> void:
	isTakingDamage = true
	healthController.takeDamage(damage)

	showDamageLabel(damage, isCritic)

	animationController.playTakeDamage()
	sfx_playHurt()
	GameUtils.flash(animationController.sprite)
	healthBarController.takeDamage(damage)
	if healthController.isDead:
		death(damageByLevelUp)
	else:
		await animationController.waitAnimationFinished()
		animationController.playIdle()
	isTakingDamage = false

func attackPlayer() -> void:
	if not isPlayerInRange or healthController.isDead or attackController.isAttacking: 
		return
	
	await attackController.attack(func ():, animationController.playIdle)
	

#VFX
func showDamageLabel(damage: float, isCritic : bool = false) -> void:
	var label = DAMAGE_LABEL_ASSET.instantiate() as DamageLabel
	label.global_position = self.global_position + Vector2(0, -20)
	GameUtils.tree.current_scene.add_child(label)
	label.setup(damage, isCritic)

#SFX
func sfx_playHurt() -> void:
	soundEffectPlayer.stream = sfx_hurt
	soundEffectPlayer.play()

func death(_damageByLevelUp : bool = false) -> void:
	pass

func convertIntoMiniBoss() -> void:
	self.isBoss = true
	self.scale *= 1.7
