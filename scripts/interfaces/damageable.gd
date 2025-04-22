class_name Damageable

extends Node

var canTakeDamage = true

func debugDamage(damage: float, node: Node) -> void:
    print(node.name, " got ", damage)

func stopTakingDamage() -> void:
    canTakeDamage = false

