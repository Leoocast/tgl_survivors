class_name HealthController
extends Node

#Setup
var entity : Node2D
var health : float
var startHealth : float

#Internal
var canTakeDamage := true
var isDead := false
var isDamaged := false

#-------------------------#
func setup(_entity: Node2D, _health: int) -> void:
    self.entity = _entity
    self.health = _health
    self.startHealth = _health

func takeDamage(damage: float, callback: Callable = func ():) -> void:
    if not canTakeDamage:
        return

    health -= damage

    if health < startHealth:
        isDamaged = true

    if health <= 0:
        isDead = true
        stopTakingDamage()
        
    callback.call()
    
func stopTakingDamage() -> void:
    canTakeDamage = false