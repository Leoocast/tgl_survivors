extends Upgrade

@export var multiplier := .15

func _init() -> void:
	name = "Arco Recurvado"
	description = "+15% de Velocidad de Ataque"

func apply(player: ElTataSlayer) -> void:
	player.increaseAttackSpeed(multiplier)