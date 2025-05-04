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
var isTakingDamage := false

#Signals
signal died
signal damaged

#-------------------------#
func setup(_entity: Node2D, _health: float) -> void:
	self.entity = _entity
	self.health = _health
	self.startHealth = _health

func takeDamage(damage: float, executeAtEnd: Callable = func ():) -> void:
	if not canTakeDamage:
		return

	isTakingDamage = true

	health -= damage

	if health < startHealth:
		isDamaged = true
		damaged.emit()

	if health <= 0:
		isDead = true
		canTakeDamage = false
		stopTakingDamage()

		died.emit()
		
	isTakingDamage = false
	executeAtEnd.call()

func stopTakingDamage() -> void:
	canTakeDamage = false


func takeDamageTataSlayer(damage: float, mouseDirection: Vector2) -> void:
	if not canTakeDamage or isDead:
		return

	isTakingDamage = true

	health -= damage

	if health < startHealth:
		isDamaged = true

	if health <= 0:
		isDead = true
		stopTakingDamage()

		if entity.animationController.playDeath.is_valid:
			entity.animationController.playDeath(mouseDirection)

	isTakingDamage = false
