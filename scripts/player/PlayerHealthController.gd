class_name PlayerHealthController
extends HealthController

var player : Player :
	get:
		return entity

#-------------------------#
func on_level_up(_newLvl: int, _xpNextLvl: int, _currentXp: int) -> void:
	stopTakingDamage()

func on_upgrade_completed() -> void:
	resumeTakingDamage()

func takeDamageWithSource(enemy: Node) -> void:
	if not canTakeDamage or isDead:
		return

	if player.isInParryWindow and player.isEnemyInParryCone(enemy):
		#TODO Mover esto de aqui al attack o al player
		player.justParriedSuccessfully = true		
		player.animationController.boostWhenParry()
		player.triggerParry()
		enemy.disableAttackHitbox()
		#Todo Fix esta wea tambien
		enemy.takeDamage(2, false, false, true, player.isInPerfectParryWindow)
		enemy.applyKnockback(player.global_position, 600)
		# enemy.animationController.modulateReset() 
		# enemy.animationController.playFlashAnimation()
		return

	isTakingDamage = true
	taking_damage_started.emit()

	health -= enemy.weapon.damage

	if health < startHealth:
		isDamaged = true
		damaged.emit(enemy.weapon.damage)

	if health <= 0:
		isDead = true
		stopTakingDamage()

		died.emit()
		
	isTakingDamage = false
	taking_damage_finished.emit()
