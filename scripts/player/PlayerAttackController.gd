class_name PlayerAttackController
extends AttackController

#Internal
var firstAttack: bool = true

#-------------------------#
func _ready():
	connect("attack_finished", on_attack_finished)

#Consumers
func on_attack_finished() -> void:
	if InputHandler.isAttacking():
		firstAttack = !firstAttack
	else:
		firstAttack = true

#-------------------------#
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