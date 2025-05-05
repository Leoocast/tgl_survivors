class_name ElTataSlayerAttackController
extends AttackController

#Internal
var firstAttack: bool = true

#-------------------------#
func _ready():
	connect("attack_finished", on_attack_finished)

func executeLevelUpDamage() -> void:
	var enemiesInside = entity.levelUpDamageArea.get_overlapping_bodies()
	
	if enemiesInside.size() <= 0:
		return

	for enemy : Enemy in enemiesInside:
		enemy.takeDamage(entity.auraDamage, true)

#Consumers
func on_attack_finished() -> void:
	if InputHandler.isAttacking():
		firstAttack = !firstAttack
	else:
		firstAttack = true