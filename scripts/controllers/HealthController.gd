class_name HealthController
extends Node

#Setup
var entity : Node2D
var health : float

#Internal
var canTakeDamage := true
var isDead := false

#-------------------------#
func setup(_entity: Node2D, _health: int) -> void:
    self.entity = _entity
    self.health = _health

func takeDamage(damage: float, callback: Callable = func ():) -> void:
    if not canTakeDamage:
        return

    health -= damage

    if health <= 0:
        isDead = true
        stopTakingDamage()
        
    callback.call()
    
func stopTakingDamage() -> void:
    canTakeDamage = false