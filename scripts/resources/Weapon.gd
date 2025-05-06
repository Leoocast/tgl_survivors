class_name Weapon
extends Node2D

#Setup
@export var damage : float
@export var cooldown : float
@export var weaponName: String

#-------------------------#
func setup(_damage: float, _cooldown: float):
	self.damage = _damage
	self.cooldown = _cooldown

func increaseDamageByMultiplier(multiplier: float) -> void:
	var result = damage * multiplier
	self.damage += result

func shoot() -> void:
	pass