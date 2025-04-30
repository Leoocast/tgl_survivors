class_name UpgradesController
extends Node

#Preload
const MOVEMENT_SPEED_UPGRADE = preload("res://scripts/upgrades/MovementSpeedUpgrade.gd")

#Internal
var upgrades: Array[Upgrade]

func _ready():
    upgrades = [
        MOVEMENT_SPEED_UPGRADE.new(),
        MOVEMENT_SPEED_UPGRADE.new(),
        MOVEMENT_SPEED_UPGRADE.new(),
        MOVEMENT_SPEED_UPGRADE.new(),
        MOVEMENT_SPEED_UPGRADE.new(),
	]

func getRandomUpgrades(count: int) -> Array[Upgrade]:
    var shuffled = upgrades.duplicate()
    shuffled.shuffle()
    return shuffled.slice(0, count)