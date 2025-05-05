class_name Weapon
extends Node2D

#Setup
var damage : float
var cooldown : float

#-------------------------#
func _init(_damage: float, _cooldown: float):
	self.damage = _damage
	self.cooldown = _cooldown

func setup(_damage: float, _cooldown: float):
	self.damage = _damage
	self.cooldown = _cooldown

func increaseDamageByMultiplier(multiplier: float) -> void:
	self.damage *= multiplier
	push_warning("Damage: ", damage)

func shoot() -> void:
	pass