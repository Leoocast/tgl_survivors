class_name AttackController
extends Node

#Setup
var entity : Node2D
var weapon : Node2D

#Internal
var isAttacking := false
var canAttack := true

#-------------------------#
func setup(_entity: Node2D, _weapon: Node2D) -> void:
	self.entity = _entity
	self.weapon = _weapon
	
func attack(executeAfterAttack: Callable = func():, executeAfterAttackAnimation: Callable = func():) -> void:
	if not canAttack: 
		return

	canAttack = false
	isAttacking = true
	weapon.shoot()
	entity.animationController.playAttack()
	entity.animationController.modulateAttack()
  
	if executeAfterAttack.is_valid():
		executeAfterAttack.call()   
  
	await entity.animationController.waitAnimationFinished()
	entity.animationController.modulateReset()
	
	if executeAfterAttackAnimation.is_valid():
		executeAfterAttackAnimation.call()   

	isAttacking = false
	await GameUtils.waitFor(weapon.cooldown)
	canAttack = true
	
func elTataSlayerAttack(mouseDirection : Vector2, executeAfterAttack: Callable = func():, executeAfterAttackAnimation: Callable = func():) -> void:
	if not canAttack: 
		return

	canAttack = false
	isAttacking = true
	weapon.shoot()
	entity.animationController.playAttack(mouseDirection)
  
	if executeAfterAttack.is_valid():
		executeAfterAttack.call()   
  
	await entity.animationController.waitAnimationFinished()

	if executeAfterAttackAnimation.is_valid():
		executeAfterAttackAnimation.call()   

	isAttacking = false
	await GameUtils.waitFor(weapon.cooldown)
	canAttack = true