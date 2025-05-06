extends Upgrade

var multiplier: float = .1

func _init() -> void:
	name = "Palito Pinchador"
	description = "+10% de daño"

func apply(player: Player) -> void:
	player.updatesManager.increaseAttackDamage(multiplier)