extends CanvasLayer

@onready var playerHealthBar := %PlayerHealthBar as HealthBarController
@onready var player := %Player as Player
@onready var xpLabel := $Control/XPLvl
@onready var comboLabel := $Control/Combo
@onready var playerXPBar := $Control/PlayerXP
@onready var lvlUpUi = %LvlUpUI
@onready var game = get_parent() as GameState
@onready var upgradesController = %UpgradesController as UpgradesController

#Internal
#TODO: Combo controller
var comboCounter := 0

#-------------------------#
func _ready():
	player.healthController.connect("damaged", _on_health_changed)
	player.xpSystem.connect("level_up", on_lvl_up)
	player.xpSystem.connect("add_xp", on_add_xp)

	playerHealthBar.setup(player, player.healthController, player.healthColor, true)
	playerXPBar.max_value = player.xpSystem.xpToNextLevel

func showLevelUpUI():

	player.attackController.executeLevelUpDamage()

	game.pause()

	#FIXME: Esto no se donde deba ir??
	player.z_index = 99
	player.healthController.canTakeDamage = false
	await player.animationController.playAndAwaitSsj()
	player.z_index = 1
	
	var randomUpgrades = upgradesController.getRandomUpgrades(3)
	lvlUpUi.setup(player, randomUpgrades)
	lvlUpUi.show()

	#FIXME: Esto no se donde deba ir??
	player.healthController.canTakeDamage = true

#Consumers
func _on_health_changed(damage: float) -> void:
	playerHealthBar.takeDamage(damage)

func on_add_xp(xp: int) -> void:
	playerXPBar.value = clamp(xp, 0, playerXPBar.max_value)

func on_lvl_up(newLvl : int, xpToNextLvl : int, currentXp : int) -> void:
	xpLabel.text = str(newLvl)
	playerXPBar.max_value = xpToNextLvl
	playerXPBar.value = clamp(currentXp, 0, xpToNextLvl)
	showLevelUpUI()
