class_name Weapon
extends Node2D

#Setup
@export var damage: float
@export var cooldown: float
@export var weaponName: String
@export var hasKnockback: bool = false
@export var knockbackPower: float = 1
@export var knockbackCriticPower: float = 1

#-------------------------#
func setup(_damage: float, _cooldown: float):
	self.damage = _damage
	self.cooldown = _cooldown

func increaseDamageByMultiplier(multiplier: float) -> void:
	var result = damage * multiplier
	self.damage += result

func shoot() -> void:
	pass