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

func takeDamage(damage: float) -> void:
	if not canTakeDamage or isDead:
		return

	if player.isInParryWindow:
		player.triggerParry()
		return

	isTakingDamage = true
	taking_damage_started.emit()

	health -= damage

	if health < startHealth:
		isDamaged = true
		damaged.emit(damage)

	if health <= 0:
		isDead = true
		stopTakingDamage()

		died.emit()
		
	isTakingDamage = false
	taking_damage_finished.emit()