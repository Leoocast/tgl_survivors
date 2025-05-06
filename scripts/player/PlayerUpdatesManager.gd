class_name PlayerUpdatesManager
extends RefCounted

#Config
var player : Player

#-------------------------#
func setupPlayer(_player: Player) -> void:
	self.player = _player

func increaseMovementSpeed(multiplier: float) -> void:
	player.currentSpeed += multiplier

func increaseAttackDamage(multiplier: float) -> void:
	player.weapon.increaseDamageByMultiplier(multiplier)

func increaseAttackSpeed(multiplier: float) -> void:
	player.animationController.setAttackFpsMultiplier(multiplier)
