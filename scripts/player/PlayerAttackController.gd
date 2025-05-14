class_name PlayerAttackController
extends AttackController

@onready var comboTimer: Timer = $ComboTimer
@onready var allComboTimer: Timer = $AllComboTimer

# Configuración de combos por índice
const attackEndFrames := {
	1: 0.6,
	2: 0.3,
	3: 1.1,
}

const attackImpulses := {
	1: 1000.0,
	2: 800.0,
	3: 100.0,
}

# Estado interno
var currentAttackIndex: int = 1
var maxCombo: int = 3
var comboExpired := false

#-------------------------#

func _ready() -> void:
	comboTimer.timeout.connect(_on_combo_timer_timeout)
	allComboTimer.timeout.connect(_on_all_combo_timer_timeout)

#-------------------------#

func attack() -> void:
	if not canAttack:
		return
	
	if comboExpired:
		currentAttackIndex = 1
		comboExpired = false

	allComboTimer.start()

	var attack_duration = attackEndFrames.get(currentAttackIndex, 0.25)
	comboTimer.start(attack_duration)

	canAttack = false
	isAttacking = true

	entity.velocity = Vector2.ZERO

	attack_started.emit()
	weapon.shoot()
	attack_animation_started.emit(currentAttackIndex)

#-------------------------#

func _on_combo_timer_timeout() -> void:
	attackFinishedRoutine()

func _on_all_combo_timer_timeout() -> void:
	comboExpired = true
	
func attackFinishedRoutine() -> void:
	isAttacking = false
	entity.velocity = Vector2.ZERO  # Frenamos completamente

	currentAttackIndex += 1
	if currentAttackIndex > maxCombo:
		currentAttackIndex = 1

	attack_animation_finished.emit()
	canAttack = true
	attack_finished.emit()

#-------------------------#
# Extras sin cambios

func on_level_up(_newLvl: int, _xpNextLvl: int, _currentXp: int) -> void:
	var enemiesInside = entity.levelUpDamageArea.get_overlapping_bodies()
	if enemiesInside.size() <= 0:
		return

	var player = entity as Player
	for enemy: Enemy in enemiesInside:
		enemy.takeDamage(player.attributes.auraDamage, true)

func damageEnemy(enemy: Enemy) -> void:
	var player = self.entity as Player
	var isCritic = randf() < player.currentCritProb as float
	var realDamage = player.weapon.damage * 2 if isCritic else player.weapon.damage

	if player.weapon.hasKnockback:
		var knockback = calculateWeaponNockback(isCritic, enemy)
		enemy.applyKnockback(player.global_position, knockback)

	enemy.takeDamage(realDamage, false, isCritic)

func calculateWeaponNockback(isCritic : bool, enemy: Enemy) -> float:
	var knockback = weapon.knockbackCriticPower if isCritic else weapon.knockbackPower
	var knockbackWhenBoss = knockback / 1.65
	return knockbackWhenBoss if enemy.isBoss else knockback

func changeWeapon(_weapon: PlayerWeapon) -> void:
	self.weapon = _weapon
