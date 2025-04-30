extends CanvasLayer

#Preloads
var UPGRADE_SCENE = preload("res://scenes/game/upgrade_option.tscn")

#Nodes
@onready var boxContainer = $CenterContainer/HBoxContainer

#Setup
var player : ElTataSlayer

func setup(_player: ElTataSlayer, upgrades : Array[Upgrade]) -> void:
	self.player = _player

	clearContainer()
	for upgrade in upgrades:
		var option = UPGRADE_SCENE.instantiate() as UpgradeOption
		boxContainer.add_child(option)

		option.custom_minimum_size = Vector2(500, 500)

		option.upgrade = upgrade
		option.setup(upgrade.name, upgrade.description)
		option.upgrade_selected_signal.connect(_on_upgrade_selected)
	
func clearContainer() -> void:
	for child in boxContainer.get_children():
		child.queue_free()

#Signals
func _on_upgrade_selected(upgrade: Upgrade) -> void:
	upgrade.apply(player)
	var game = GameUtils.getGame()
	var lvlUpUi = game.get_node("LvlUpUI")
	lvlUpUi.hide()
	await GameUtils.waitFor(0.1)
	game.resume()
