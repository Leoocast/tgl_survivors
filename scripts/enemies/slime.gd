class_name Slime
extends Enemy

#Preload
const EXP_DROP_ASSET = preload(Constants.ASSETS.DROP.XP)

#Config
const SPEED := 200.0
const STOP_DISTANCE := 70.0
const HEALTH := 2.0
var SLIME_WEAPON : Weapon

#Signals
signal died_signal

#-------------------------#
func _ready():
	SLIME_WEAPON = Weapon.new(1, 0.4)
	
	self.setup({
		"speed": SPEED,
		"stopDistance": STOP_DISTANCE,
		"health": HEALTH, 
		"healthColor": Color8(214,0,71),
		"weapon": SLIME_WEAPON,
		"sprite": $AnimatedSprite2D
	})

	animationController.playIdle()
	healthBarController.hideBars()
	disableAttackHitbox()

func _physics_process(_delta):
	moveTowardsPlayer()
	flipTowardsPlayer()
	attackPlayer()

	if healthController.isDamaged && not healthBarController.alreadyShowed:
		healthBarController.showBars()

func flipTowardsPlayer():
	var shouldFlip = self.global_position.x > player.global_position.x

	GameUtils.flipColliderHorizontal($AttackArea/AttackCollision, shouldFlip)
	animationController.flipHorizontal(shouldFlip)

func death() -> void:
	emit_signal("died_signal")
	healthBarController.hideBars()
	await animationController.waitAnimationFinished()
	animationController.playDeath()
	isntantiateDrop()
	fadeOutAndDisapear()
	$CollisionShape2D.queue_free()
	
func enableAttackHitbox() -> void:
	$AttackArea/AttackCollision.call_deferred("set_disabled", false)
	
func disableAttackHitbox() -> void:
	$AttackArea/AttackCollision.call_deferred("set_disabled", true)

func fadeOutAndDisapear():
	var tween = create_tween()
	tween.tween_property($AnimatedSprite2D, "modulate:a", 0.0, 0.5)
	tween.tween_callback(Callable(self, "queue_free"))

func isntantiateDrop() -> void:
	var instance = EXP_DROP_ASSET.instantiate()
	instance.global_position = self.global_position
	get_parent().add_child(instance)
	GameUtils.fadeIn(instance, 0.3)

#Signals -------------------------#
func _on_animated_sprite_2d_frame_changed() -> void:
	if $AnimatedSprite2D.animation == "attack":
		var current_frame = $AnimatedSprite2D.frame
		if current_frame == 3:
			enableAttackHitbox()
		else:
			disableAttackHitbox()

# Cuando entra al rango empieza atacar
func _on_area_2d_body_entered(body:Node2D) -> void:
	if body is not ElTataSlayer:
		return
	isPlayerInRange = true
	attackPlayer()

#Si esta a rango del collider de ataque, recibe da;o
func _on_attack_area_body_entered(body:Node2D) -> void:
	if body is ElTataSlayer:
		player.takeDamage(weapon.damage)

func _on_area_2d_body_exited(body:Node2D) -> void:
	if body is not ElTataSlayer:
		return
	isPlayerInRange = false
