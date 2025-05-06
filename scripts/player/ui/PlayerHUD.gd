extends CanvasLayer

@onready var playerHealthBar: HealthBarController = %PlayerHealthBar as HealthBarController
@onready var xpLabel: Label = $Control/XPLvl as Label
@onready var playerXPBar: ProgressBar = $Control/PlayerXP as ProgressBar
@onready var player: Player = %Player as Player

#-------------------------#
func _ready():
	playerHealthBar.setup(player, player.healthController, player.attributes.healthColor, true)
	playerXPBar.max_value = player.xpSystem.xpToNextLevel

	setupSuscriptions()

func setupSuscriptions() -> void:
	player.healthController.damaged.connect(on_health_changed)
	player.xpSystem.level_up.connect(on_lvl_up)
	player.xpSystem.add_xp.connect(on_add_xp)

#Signall
func on_health_changed(damage: float) -> void:
	playerHealthBar.takeDamage(damage)

func on_add_xp(xp: int) -> void:
	playerXPBar.value = clamp(xp, 0, playerXPBar.max_value)

func on_lvl_up(newLvl: int, xpToNextLvl: int, currentXp: int) -> void:
	xpLabel.text = str(newLvl)
	playerXPBar.max_value = xpToNextLvl
	playerXPBar.value = clamp(currentXp, 0, xpToNextLvl)
