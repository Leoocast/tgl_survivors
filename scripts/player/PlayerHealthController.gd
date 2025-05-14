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

func takeDamageWithSource(enemy: Enemy) -> void:
	if not canTakeDamage or isDead:
		return

	if player.isInParryWindow and player.isEnemyInParryCone(enemy):
		player.triggerParry()
		enemy.disableAttackHitbox()
		enemy.takeDamage(2)
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