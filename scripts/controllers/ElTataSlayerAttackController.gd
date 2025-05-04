class_name ElTataSlayerAttackController
extends Node

@onready var animationController := %AnimationController as ElTataSlayerAnimationController

#Setup
var entity : Player
var weapon : Weapon

#Internal
var isAttacking := false
var canAttack := true
var firstAttack := true

#Audio
var sfx_sword_1 = load("res://assets/audio/sound_effects/sword_effect_1.wav")
var sfx_sword_2 = load("res://assets/audio/sound_effects/sword_effect_2.wav")
#-------------------------#
func setup(_entity: Player, _weapon: Weapon) -> void:
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
		playSfxDelayed()
	else:
		entity.animationController.playAttack2(mouseDirection)
		await GameUtils.waitFor(0.1)
		AudioManager.playSoundEffect(sfx_sword_2)

	if executeAfterAttack.is_valid():
		executeAfterAttack.call()   
  
	await entity.animationController.waitAnimationFinished()

	if executeAfterAttackAnimation.is_valid():
		executeAfterAttackAnimation.call()   

	isAttacking = false
	# await GameUtils.waitFor(weapon.cooldown)
	canAttack = true

	if InputHandler.isAttacking():
		firstAttack = !firstAttack
	else:
		firstAttack = true

func playSfxDelayed() -> void:
	await GameUtils.waitFor(0.3)
	AudioManager.playSoundEffect(sfx_sword_1)

func executeLevelUpDamage() -> void:
	var enemiesInside = entity.levelUpDamageArea.get_overlapping_bodies()
	
	if enemiesInside.size() <= 0:
		return

	for enemy : Enemy in enemiesInside:
		enemy.takeDamage(entity.auraDamage, true)
