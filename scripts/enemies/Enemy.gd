class_name Enemy
extends CharacterBody2D

#Preload
const DAMAGE_LABEL_ASSET = preload(PATHS.SCENES.DAMAGE_LABEL)

#Nodes
@onready var healthController: HealthController = %HealthController as HealthController
@onready var attackController: AttackController = %AttackController as AttackController
@onready var animationController: EnemyAnimationController = %AnimationController as EnemyAnimationController
@onready var healthBarController: EnemyHealthBarController = %HealthBar as EnemyHealthBarController
@onready var weapon: Weapon = %Weapon as Weapon
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var separationArea : Area2D = $SeparationArea

#Attributes
@export var attributes: EnemyAttributesResource

#Config
@export var isBoss: bool = false
var player: Player 
var knockbackVelocity: Vector2 = Vector2.ZERO

#Internal
var isPlayerInRange: bool = false
var currentHealth: float = 1

#SFX
@onready var soundEffectPlayer: AudioStreamPlayer = AudioStreamPlayer.new()

#Signals
signal died()

#-------------------------#
func setupPlayer() -> void:
	player = GameUtils.getPlayer()

func setup() -> void:
	
	setupPlayer()
	GameUtils.validateEnemyAttributes(attributes, self)
	setupComponents()
	attackSuscriptions()
	
	animationController.playIdle()
	healthBarController.hideBars()

	disableAttackHitbox()
	add_child(soundEffectPlayer)

	if isBoss:
		convertIntoMiniBoss()

func setupComponents() -> void:
	currentHealth = attributes.health
	healthController.setup(self, currentHealth)
	healthBarController.setup(self, healthController, attributes.healthColor, isBoss)
	attackController.setup(self, weapon)
	animationController.setup(sprite)

func attackSuscriptions() -> void:
	attackController.connect("attack_animation_started", on_attack_animation_started)
	attackController.connect("attack_animation_finished", on_attack_animation_finished)

func defaultProcess(delta : float, repulsion : Vector2 = Vector2.ZERO) -> void:
	if GameState.isNotRunning():
		return

	moveTowardsPlayer(repulsion)
	flipTowardsPlayer()
	attackPlayer()

	# if healthController.isDamaged && not healthBarController.alreadyShowed:
	# 	healthBarController.showBars()
	
	knockbackVelocity = knockbackVelocity.move_toward(Vector2.ZERO, 1000 * delta)

func setupZIndex(zIndex: int = 0 ) -> void:
	self.z_index = zIndex

func moveTowardsPlayer(repulsion : Vector2 = Vector2.ZERO) -> void:
	if player == null or healthController.isDead or attackController.isAttacking or healthController.isTakingDamage:
		return
	
	if global_position == Vector2.ZERO:
		return

	var direction = global_position.direction_to(player.global_position)

	# Se mueve con knockback siempre
	var move_vector = knockbackVelocity

	# Solo agrega movimiento hacia el jugador si está lejos
	if global_position.distance_to(player.global_position) > attributes.stopDistance:
		move_vector += direction * attributes.speed

	if repulsion != Vector2.ZERO:
		move_vector += repulsion

	self.velocity = move_vector.limit_length(attributes.speed * 2)
	move_and_slide()

func takeDamage(damage: float, damageByLevelUp: bool = false, isCritic: bool = false) -> void:
	healthController.isTakingDamage = true
	healthController.takeDamage(damage)

	showDamageLabel(damage, isCritic)

	animationController.playTakeDamage()
	sfx_playHurt()

	animationController.playFlashAnimation()
	
	healthBarController.takeDamage(damage)
	if healthController.isDead:
		death(damageByLevelUp)
	else:
		await animationController.waitAnimationFinished()
		animationController.playIdle()
	healthController.isTakingDamage = false

func attackPlayer() -> void:
	if not isPlayerInRange or healthController.isDead or attackController.isAttacking: 
		return
	
	await attackController.attack()
	
func isntantiateDrop() -> void:
	var instance = attributes.exp_drop_scene.instantiate()
	instance.global_position = self.global_position
	get_parent().add_child(instance)
	GameUtils.fadeIn(instance, 0.3)

func enableAttackHitbox() -> void:
	$AttackArea/AttackCollision.call_deferred("set_disabled", false)
	
func disableAttackHitbox() -> void:
	$AttackArea/AttackCollision.call_deferred("set_disabled", true)


func fadeOutAndDisapear():
	var tween = create_tween()
	tween.tween_property(sprite, "modulate:a", 0.0, 0.5)
	tween.tween_callback(Callable(self, "queue_free"))

func flipTowardsPlayer():
	var shouldFlip = self.global_position.x > player.global_position.x

	GameUtils.flipColliderHorizontal($AttackArea/AttackCollision, shouldFlip)
	animationController.flipHorizontal(shouldFlip)

func calculateSeparation() -> Vector2:
	var result = Vector2.ZERO

	var overlappingBoddies = separationArea.get_overlapping_bodies()

	for body in overlappingBoddies:
		if body is not Enemy: continue

		var offset = (global_position - body.global_position) as Vector2
		var distance = offset.length()

		if distance > 0:
			result += offset.normalized() / distance
	
	return result * attributes.hordeSeparationStrength

func applyKnockback(from_position: Vector2, strength: float) -> void:
	var direction = (global_position - from_position).normalized()
	knockbackVelocity = direction * strength

#Consumers
#TODO si crece: Crear EnemyAnimationController
func on_attack_animation_started() -> void:
	animationController.playAttack()
	animationController.modulateAttack()

func on_attack_animation_finished() -> void:
	animationController.modulateReset()
	animationController.playIdle()

func on_area_2d_body_entered_default(body: Node2D) -> void:
	if body is not Player:
		return
	isPlayerInRange = true
	attackPlayer()

func on_attack_area_body_entered_default(body: Node2D) -> void:
	if body is Player:
		player.healthController.takeDamage(weapon.damage)

func on_area_2d_body_exited_default(body: Node2D) -> void:
	if body is not Player:
		return
	isPlayerInRange = false

#VFX
func showDamageLabel(damage: float, isCritic: bool = false) -> void:
	var label = DAMAGE_LABEL_ASSET.instantiate() as DamageLabel
	label.global_position = self.global_position + Vector2(0, -20)
	GameUtils.tree.current_scene.add_child(label)
	label.setup(damage, isCritic)

#SFX
func sfx_playHurt() -> void:
	soundEffectPlayer.stream = attributes.sfx_hurt
	soundEffectPlayer.play()

func convertIntoMiniBoss() -> void:
	call_deferred("_deferredMiniBoss")

func _deferredMiniBoss() -> void:
	self.isBoss = true
	self.weapon.increaseDamageByMultiplier(2)
	self.scale *= 1.7
	healthController.health = currentHealth * 2
	healthBarController.setup(self, healthController, attributes.healthColor, isBoss)

func death(_damageByLevelUp: bool = false) -> void:
	defaultDeath()

func defaultDeath(_damageByLevelUp: bool = false) -> void:
	died.emit()
	healthBarController.hideBars()
	await animationController.waitAnimationFinished()
	animationController.playDeath()
# if not _damageByLevelUp: 
	isntantiateDrop()
	
	fadeOutAndDisapear()
	$CollisionShape2D.queue_free()
