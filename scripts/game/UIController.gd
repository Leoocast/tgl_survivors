extends CanvasLayer

@onready var playerHealthBar := %PlayerHealthBar as HealthBarController
@onready var player := %Player as ElTataSlayer
@onready var xpLabel := $Control/XPLvl
@onready var comboLabel := $Control/Combo
@onready var playerXPBar := $Control/PlayerXP
@onready var lvlUpUi = %LvlUpUI
@onready var game = get_parent() as GameState
@onready var upgradesController = %UpgradesController as UpgradesController

#Internal
var comboCounter := 0

func _ready():
	player.connect("take_damage_signal", _on_health_changed)
	player.connect("lvl_up_signal", _on_lvl_up)
	player.connect("add_xp_signal", _on_add_xp)

	playerHealthBar.setup(player, player.healthController, player.HEALTH_COLOR, true)
	playerXPBar.max_value = player.xpToNextLvl

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

#Signal Event
func _on_health_changed(damage: float) -> void:
	playerHealthBar.takeDamage(damage)

func _on_add_xp(xp: int) -> void:
	playerXPBar.value = clamp(xp, 0, playerXPBar.max_value)

func _on_lvl_up(newLvl : int, xpToNextLvl : int, currentXp : int) -> void:
	xpLabel.text = str(newLvl)
	playerXPBar.max_value = xpToNextLvl
	playerXPBar.value = clamp(currentXp, 0, xpToNextLvl)
	showLevelUpUI()
