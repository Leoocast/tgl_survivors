class_name Weapon
extends Node2D

var damage : float
var cooldown : float

func _init(_damage: float, _cooldown: float):
    self.damage = _damage
    self.cooldown = _cooldown

func shoot() -> void:
    pass