extends CharacterBody2D

# Esto es slime, pasar enemy a una clase para heredar de ella
class_name Enemy

const speed := 200.0
const attackCd := 0.4
const stop_distance = 70.0
const attackDamage := 2

var damageable := Damageable.new()
var health := 3
var isDead := false
var isTakingDamage := false
var isAttacking := false
var isPlayerInRange := false


@onready var ui_redBar := $HealthBar/RedBar
@onready var ui_whiteBar := $HealthBar/WhiteBar
@onready var ui_blackBar := $HealthBar/Blackbar

# Esto va a cambiar cuando se tengan que instanciar, por el momento lo dejamos
# agarrandolo del arbol al iniciar
# var player: Player
@onready var player: Player = %Player

func _ready() -> void:
	$AnimatedSprite2D.play("idle")
	setupHealthUI()

func _physics_process(_delta: float):
	if player == null or isDead or isAttacking or isTakingDamage: return
	if self.global_position == Vector2.ZERO: return
	flipTowardsPlayer()

	var distance = global_position.distance_to(player.global_position)

	if distance > stop_distance:
		var direction = global_position.direction_to(player.global_position)
		self.velocity = direction * speed
		move_and_slide()

func takeDamage() -> void:
	if not damageable.canTakeDamage:
		return

	isTakingDamage = true
	health -= 1
	$AnimatedSprite2D.play("take_damage")
	flash()
	updateHealthUI()
	if health <= 0:
		death()
	else:
		await $AnimatedSprite2D.animation_finished
		$AnimatedSprite2D.play("idle")
	isTakingDamage = false

func flipTowardsPlayer() -> void:
	if self.global_position.x > player.global_position.x:
		$AttackArea/AttackCollision.position.x = -abs($AttackArea/AttackCollision.position.x)
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
		$AttackArea/AttackCollision.position.x = abs($AttackArea/AttackCollision.position.x)

func setupHealthUI() -> void:
	ui_redBar.max_value = health
	ui_whiteBar.max_value = health
	ui_blackBar.max_value = health

	ui_redBar.value = health
	ui_whiteBar.value = health
	ui_blackBar.value = health

func updateHealthUI() -> void:
	ui_redBar.value = health
	ui_whiteBar.value = health + 1
	ui_blackBar.value = health + 1

	await GameHelper.showHide(ui_whiteBar, 0.08)
	
	var tween = GameHelper.create_tween()
	tween.tween_property(ui_blackBar, "value", health, 0.3).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)

func flash() -> void:
	var originalColor = $AnimatedSprite2D.self_modulate
	$AnimatedSprite2D.self_modulate = Color(2,2,2)
	await GameHelper.waitFor(0.2)
	$AnimatedSprite2D.self_modulate = originalColor

func death()-> void:
	isDead = true
	damageable.stopTakingDamage()
	ui_redBar.hide() 
	ui_whiteBar.hide() 
	ui_blackBar.hide() 
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.play("death") 
	fadeOutAndDisapear()
	$CollisionShape2D.queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is not Player:
		return
	isPlayerInRange = true
	attackPlayer()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is not Player:
		return
	isPlayerInRange = false


func attackPlayer() -> void:
	if not isPlayerInRange: 
		return

	isAttacking = true
	$AnimatedSprite2D.play("attack") 
	await $AnimatedSprite2D.animation_finished
	isAttacking = false
	$AnimatedSprite2D.play("idle")
	await GameHelper.waitFor(attackCd)
	
	if isPlayerInRange:
		attackPlayer()
	

func enableAttackHitbox() -> void:
	$AttackArea/AttackCollision.disabled = false


func disableAttackHitbox() -> void:
	$AttackArea/AttackCollision.disabled = true

func _on_animated_sprite_2d_frame_changed() -> void:
	if $AnimatedSprite2D.animation == "attack":
		var current_frame = $AnimatedSprite2D.frame
		if current_frame == 3:
			enableAttackHitbox()
		else:
			disableAttackHitbox()


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body is Player:
		player.takeDamage(attackDamage)

func fadeOutAndDisapear():
	var tween = create_tween()
	tween.tween_property($AnimatedSprite2D, "modulate:a", 0.0, 0.5)
	tween.tween_callback(Callable(self, "queue_free"))
