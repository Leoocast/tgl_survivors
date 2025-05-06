class_name UpgradesManager
extends RefCounted

#Preload
const MOVEMENT_SPEED = preload(PATHS.PLAYER_UPGRADES.MOVEMENT_SPEED)
const ATTACK_DAMAGE = preload(PATHS.PLAYER_UPGRADES.ATTACK_DAMAGE)
const ATTACK_SPEED = preload(PATHS.PLAYER_UPGRADES.ATTACK_SPEED)

#Internal
var upgrades: Array[Upgrade] = [
		MOVEMENT_SPEED.new(),
		ATTACK_DAMAGE.new(),
		ATTACK_SPEED.new(),
	]

#-------------------------#
func getRandomUpgrades(count: int) -> Array[Upgrade]:
	var shuffled = upgrades.duplicate()
	shuffled.shuffle()
	return shuffled.slice(0, count)
