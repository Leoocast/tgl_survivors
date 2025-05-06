class_name PlayerHealthController
extends HealthController

func on_level_up(_newLvl: int, _xpNextLvl: int, _currentXp: int) -> void:
	stopTakingDamage()

func on_upgrade_completed() -> void:
	resumeTakingDamage()