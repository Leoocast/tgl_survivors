class_name LevelUpUI
extends CanvasLayer

#Preloads
var UPGRADE_SCENE = preload("res://scenes/UI/upgrade_option.tscn")

#Nodes
@onready var boxContainer = $CenterContainer/HBoxContainer
@onready var player: Player = %Player as Player

#Managers
var upgradesManager: UpgradesManager = UpgradesManager.new()

#Signals
signal upgrade_completed()

#-------------------------#
func _ready():
	player.xpSystem.level_up.connect(on_level_up)

func setup(upgrades : Array[Upgrade]) -> void:
	clearContainer()
	for upgrade in upgrades:
		var option = UPGRADE_SCENE.instantiate() as UpgradeOption
		boxContainer.add_child(option)

		option.custom_minimum_size = Vector2(500, 500)

		option.upgrade = upgrade
		option.setup(upgrade.name, upgrade.description)
		option.upgrade_selected_signal.connect(on_upgrade_selected)
	
func clearContainer() -> void:
	for child in boxContainer.get_children():
		child.queue_free()

#Signals
func on_upgrade_selected(upgrade: Upgrade) -> void:
	upgrade.apply(player)
	hide()
	
	await GameUtils.waitFor(0.1)
	upgrade_completed.emit()

func on_level_up(_newLvl: int, _xpNextLvl: int, _currentXp: int) -> void:
	var randomUpgrades = upgradesManager.getRandomUpgrades(3)
	setup(randomUpgrades)

	await get_tree().process_frame
	await GameUtils.waitFor(0.3)

	show()
