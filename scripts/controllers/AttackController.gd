class_name AttackController
extends Node

#Config
var entity: Node2D
var weapon: Node2D

#Internal
var isAttacking: bool = false
var canAttack: bool = true

#Signal
signal attack_started()
signal attack_animation_started()
signal attack_animation_finished()
signal attack_finished()

#-------------------------#
func setup(_entity: Node2D, _weapon: Node2D) -> void:
	self.entity = _entity
	self.weapon = _weapon
	
func attack() -> void:
	if not canAttack: 
		return

	canAttack = false
	isAttacking = true

	attack_started.emit()

	weapon.shoot()
	
	attack_animation_started.emit()
  
	await entity.animationController.waitAnimationFinished()

	isAttacking = false
	
	attack_animation_finished.emit()

	await GameUtils.waitFor(weapon.cooldown)

	canAttack = true
	
	attack_finished.emit()