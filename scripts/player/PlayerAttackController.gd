class_name PlayerAttackController
extends AttackController

@onready var comboTimer1 = $ComboTimer1
@onready var comboTimer2 = $ComboTimer2
@onready var allComboTimer = $AllComboTimer

#Internal
var currentAttackIndex: int = 1
var maxCombo: int = 3


#-------------------------#
# func _ready():
# 	connect("attack_finished", on_attack_finished)

# #Consumers
# func on_attack_finished() -> void:
	# if InputHandler.isAttacking():
	# 	firstAttack = !firstAttack
	# else:
	# 	firstAttack = true

#-------------------------#

func attack() -> void:
	if not canAttack: 
		return

	allComboTimer.start()
	
	if currentAttackIndex == 1:
		comboTimer1.start()
	
	if currentAttackIndex == 2:
		comboTimer2.start()

	canAttack = false
	isAttacking = true

	attack_started.emit()
	weapon.shoot()
	
	attack_animation_started.emit(currentAttackIndex)
  
	if currentAttackIndex == 1:
		await comboTimer1.timeout
	elif currentAttackIndex == 2:
		await comboTimer2.timeout
	else:
		await entity.animationController.waitAnimationFinished()

	isAttacking = false
	
	currentAttackIndex += 1
	if currentAttackIndex > maxCombo:
		currentAttackIndex = 1

	attack_animation_finished.emit()

	await GameUtils.waitFor(weapon.cooldown)
	canAttack = true
	attack_finished.emit()


# func attackFinishedRoutine

func on_level_up(_newLvl: int, _xpNextLvl: int, _currentXp: int) -> void:

	var enemiesInside = entity.levelUpDamageArea.get_overlapping_bodies()
	
	if enemiesInside.size() <= 0:
		return

	var player = entity as Player
	for enemy: Enemy in enemiesInside:
		enemy.takeDamage(player.attributes.auraDamage, true)
	
func damageEnemy(enemy: Enemy) -> void:
	var player = self.entity as Player

	var isCritic = randf() < player.currentCritProb as float

	var realDamage = player.weapon.damage * 2 if isCritic else player.weapon.damage  

	if player.weapon.hasKnockback:
		var knockback = calculateWeaponNockback(isCritic, enemy)
		enemy.applyKnockback(player.global_position, knockback)
	
	enemy.takeDamage(realDamage, false, isCritic)

func calculateWeaponNockback(isCritic : bool, enemy: Enemy) -> float:
	var knockback =  weapon.knockbackCriticPower if isCritic else weapon.knockbackPower
	var knockbackWhenBoss = knockback / 1.65

	return knockbackWhenBoss if enemy.isBoss else knockback

func changeWeapon(_weapon: PlayerWeapon) -> void:
	self.weapon = _weapon

func _on_all_combo_timer_timeout() -> void:
	currentAttackIndex = 1


func _on_combo_timer_2_timeout() -> void:
	pass # Replace with function body.

func _on_combo_timer_1_timeout() -> void:
	pass # Replace with function body.
