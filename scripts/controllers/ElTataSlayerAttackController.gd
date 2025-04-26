class_name ElTataSlayerAttackController
extends Node

#Setup
var entity : Node2D
var weapon : Node2D

#Internal
var isAttacking := false
var canAttack := true
var firstAttack := true

#-------------------------#
func setup(_entity: Node2D, _weapon: Node2D) -> void:
	self.entity = _entity
	self.weapon = _weapon
	
func attack(mouseDirection : Vector2, executeAfterAttack: Callable = func():, executeAfterAttackAnimation: Callable = func():) -> void:
	if not canAttack: 
		return

	canAttack = false
	isAttacking = true
	weapon.shoot()

	if firstAttack:
		entity.animationController.playAttack(mouseDirection)
	else:
		entity.animationController.playAttack2(mouseDirection)

	if executeAfterAttack.is_valid():
		executeAfterAttack.call()   
  
	await entity.animationController.waitAnimationFinished()

	if executeAfterAttackAnimation.is_valid():
		executeAfterAttackAnimation.call()   

	isAttacking = false
	await GameUtils.waitFor(weapon.cooldown)
	canAttack = true

	if InputHandler.isAttacking():
		firstAttack = !firstAttack
	else:
		firstAttack = true