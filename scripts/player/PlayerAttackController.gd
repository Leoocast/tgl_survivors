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
func executeLevelUpDamage() -> void:
	var enemiesInside = entity.levelUpDamageArea.get_overlapping_bodies()
	
	if enemiesInside.size() <= 0:
		return

	for enemy : Enemy in enemiesInside:
		enemy.takeDamage(entity.auraDamage, true)
	
func damageEnemy(enemy: Enemy) -> void:
	var player = self.entity as Player

	var isCritic = randf() < player.critProb as float

	var realDamage = weapon.damage * 2 if isCritic else weapon.damage  

	enemy.takeDamage(realDamage, false, isCritic)