class_name HealthController
extends Node

#Config
var entity: Node2D
var health: float
var startHealth: float

#Internal
var canTakeDamage: bool = true
var isDead: bool = false
var isDamaged: bool = false
var isTakingDamage: bool = false

#Signals
signal died()
signal taking_damage_started()
signal taking_damage_finished()
signal damaged(damage: float)

#-------------------------#
func setup(_entity: Node2D, _health: float) -> void:
	self.entity = _entity
	self.health = _health
	self.startHealth = _health

func takeDamage(damage: float) -> void:
	if not canTakeDamage or isDead:
		return

	isTakingDamage = true
	taking_damage_started.emit()

	health -= damage

	if health < startHealth:
		isDamaged = true
		damaged.emit(damage)

	if health <= 0:
		isDead = true
		stopTakingDamage()

		died.emit()
		
	isTakingDamage = false
	taking_damage_finished.emit()

func stopTakingDamage() -> void:
	canTakeDamage = false

func resumeTakingDamage() -> void:
	canTakeDamage = true