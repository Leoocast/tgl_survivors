extends Upgrade

@export var multiplier := 1.1

func _init() -> void:
	name = "Palito Pinchador"
	description = "+10% de daño"

func apply(player: ElTataSlayer) -> void:
	player.increaseAttackDamage(multiplier)