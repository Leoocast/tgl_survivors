
class_name PlayerAnimationController
extends AnimationController

#Config
const BASE_ATTACK_FPS: float = 10.0
var newFps: float = BASE_ATTACK_FPS
var player: Player

#VFX
var levelUpAuraRed: AnimatedSprite2D
var levelUpAuraYellow: AnimatedSprite2D

#Internal
var directions: Dictionary = {
	"up": "_up",
	"down": "_down",
	"left": "_left",
	"right": "_right",
}

var bowDirections: Dictionary = {
	"up": "_bow_up",
	"down": "_bow_down",
	"left": "_bow_left",
	"right": "_bow_right",
}

#-------------------------#
func setupPlayer(_player: Player , ssjAura: Node2D) -> void:
	self.player = _player
	self.setup(player.get_node("AnimatedSprite2D"))
	
	self.levelUpAuraRed = ssjAura.get_node("AuraRed") as AnimatedSprite2D
	self.levelUpAuraYellow = ssjAura.get_node("AuraYellow") as AnimatedSprite2D

#Consumers
func on_player_died() -> void:
	var mousePosition = player.getMouseDirection()
	playDeathDirection(mousePosition)

func on_taking_damage_started() -> void:
	modulateTakingDamage()

func on_taking_damage_finished() -> void:
	await GameUtils.waitFor(0.1)
	modulateReset()

func on_level_up(_newLvl: int, _xpNextLvl: int, _currentXp: int) -> void:
	player.z_index = 99
	await playAndAwaitSsj()
	player.z_index = 1

func on_attack_animation_started() -> void:
	var mousePosition = player.getMouseDirection() 

	if player.weapon.type == Enums.WeaponType.BOW:
		playAttackMouse(mousePosition)
		return

	if player.attackController.firstAttack:
		playAttackMouse(mousePosition)
		# sfxManager.playAttackSword1Delayed()
	else:
		playAttack2Mouse(mousePosition)
		# await GameUtils.waitFor(0.1)
		# sfxManager.playAttackSword2()

#-------------------------#
func playDefaultMouse(mouseDirection: Vector2) -> void:
	var inputDirection = InputHandler.getDirection()
	if inputDirection != Vector2.ZERO:
		playRunMouse(mouseDirection)
	else:
		playIdleMouse(mouseDirection)

func playIdleMouse(direction: Vector2) -> void:
	matchDirection("idle", direction)

func playRunMouse(direction: Vector2) -> void:
	matchDirection("run", direction)

func playAttackMouse(mouseDirection: Vector2) -> void:
	matchDirection("attack", mouseDirection)

func playAttack2Mouse(mouseDirection: Vector2) -> void:
	matchDirection("attack_2", mouseDirection)

func playDeathDirection(mouseDirection: Vector2) -> void:
	matchDirection("death", mouseDirection)

func waitAnimationFinished() -> void:
	await sprite.animation_finished

func flipHorizontal(flip: bool) -> void:
	sprite.flip_h = flip

func matchDirection(animationName: String, direction: Vector2) -> void:
	var isHorizontal = abs(direction.x) > abs(direction.y)
	var isRight = direction.x > 0
	var isDown = direction.y > 0

	var isBow: bool = player.weapon.type == Enums.WeaponType.BOW

	var suffix: String

	if isHorizontal:
		suffix = directions.right if isRight else directions.left
	else:
		suffix = directions.down if isDown else directions.up

	if isBow:
		suffix = bowDirections.get(suffix.substr(1))
	
	sprite.play(animationName + suffix)

	
func setAttackFpsMultiplier(multiplier: float) -> void:

	# 8 * 0.2 = 1.6
	var result = BASE_ATTACK_FPS * multiplier

	# 8 + 1.6 -> 9.6 + 1.6 -> 11.12 + 1.6, etc..
	newFps += result
	
	sprite.sprite_frames.set_animation_speed("attack_up", newFps)
	sprite.sprite_frames.set_animation_speed("attack_down", newFps)
	sprite.sprite_frames.set_animation_speed("attack_left", newFps)
	sprite.sprite_frames.set_animation_speed("attack_right", newFps)
	
	sprite.sprite_frames.set_animation_speed("attack_2_up", newFps)
	sprite.sprite_frames.set_animation_speed("attack_2_down", newFps)
	sprite.sprite_frames.set_animation_speed("attack_2_left", newFps)
	sprite.sprite_frames.set_animation_speed("attack_2_right", newFps)

func playAndAwaitSsj() -> void:

	levelUpAuraRed.show()
	levelUpAuraYellow.show()

	levelUpAuraRed.play("default")
	levelUpAuraYellow.play("default")

	await levelUpAuraYellow.animation_finished

	levelUpAuraRed.hide()
	levelUpAuraYellow.hide()

#Consumers
