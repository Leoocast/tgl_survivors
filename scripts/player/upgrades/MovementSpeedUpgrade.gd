extends Upgrade

var multiplier: float = 15

func _init() -> void:
	name = "Botas de Sonic I"
	description = "+15 Velocidad de Movimiento"

func apply(player: Player) -> void:
	player.updatesManager.increaseMovementSpeed(multiplier)