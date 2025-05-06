class_name UpgradesManager
extends RefCounted

#Preload
const MOVEMENT_SPEED_UPGRADE = preload("res://scripts/player/upgrades/MovementSpeedUpgrade.gd")
const ATTACK_DAMAGE_UPGRADE = preload("res://scripts/player/upgrades/AttackDamageUpgrade.gd")
const ATTACK_sPEED_UPGRADE = preload("res://scripts/player/upgrades/AttackSpeedUpgrade.gd")

#Internal
var upgrades: Array[Upgrade]  = [
		MOVEMENT_SPEED_UPGRADE.new(),
		ATTACK_DAMAGE_UPGRADE.new(),
		ATTACK_sPEED_UPGRADE.new(),
	]

func getRandomUpgrades(count: int) -> Array[Upgrade]:
	var shuffled = upgrades.duplicate()
	shuffled.shuffle()
	return shuffled.slice(0, count)
