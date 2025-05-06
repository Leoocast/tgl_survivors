extends Upgrade

var multiplier: float = .15

func _init() -> void:
	name = "Arco Recurvado"
	description = "+15% de Velocidad de Ataque"

func apply(player: Player) -> void:
	player.updatesManager.increaseAttackSpeed(multiplier)
