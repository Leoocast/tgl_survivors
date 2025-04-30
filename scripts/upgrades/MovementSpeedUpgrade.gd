extends Upgrade

@export var multiplier := 1.15

func _init() -> void:
	name = "Botas de Sonic I"
	description = "+15% velocidad de movimiento"

func apply(player: ElTataSlayer) -> void:
	player.increaseMovementSpeed(multiplier)