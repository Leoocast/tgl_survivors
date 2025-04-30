extends Upgrade

@export var multiplier := 15

func _init() -> void:
	name = "Botas de Sonic I"
	description = "+15 Velocidad de Movimiento"

func apply(player: ElTataSlayer) -> void:
	player.increaseMovementSpeed(multiplier)