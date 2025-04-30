
#FIXME: Esto debe heredar de AnimationController
class_name ElTataSlayerAnimationController
extends Node

#Setup
const BASE_ATTACK_FPS := 8.0
var newFps := BASE_ATTACK_FPS
var sprite : AnimatedSprite2D
var modulatedTakingDamageColor := Color(2, 2, 2)
var modulatedOriginalColor := Color8(255,255,255)

#VFX
var levelUpAuraRed: AnimatedSprite2D
var levelUpAuraYellow: AnimatedSprite2D

#Internal
const ANIMATIONS = Constants.ANIMATIONS
var directions = {
	"up": "_up",
	"down": "_down",
	"left": "_left",
	"right": "_right",
}

#-------------------------#
func setup(_sprite: AnimatedSprite2D, ssjAura : Node2D) -> void:
	self.sprite = _sprite
	#FIXME: Mover a una constante los nombres de los nodos
	self.levelUpAuraRed = ssjAura.get_node("AuraRed") as AnimatedSprite2D
	self.levelUpAuraYellow = ssjAura.get_node("AuraYellow") as AnimatedSprite2D

func playDefault(mouseDirection: Vector2) -> void:
	var inputDirection = InputHandler.getDirection()
	if inputDirection != Vector2.ZERO:
		playRun(mouseDirection)
	else:
		playIdle(mouseDirection)

func play(animation: String) -> void:
	sprite.play(animation)

func playAndAwait(animation: String) -> void:
	sprite.play(animation)
	await sprite.animation_finished

func playIdle(direction: Vector2) -> void:
	matchDirection("idle", direction)

func playRun(direction: Vector2) -> void:
	matchDirection("run", direction)

func playAttack(mouseDirection: Vector2) -> void:
	matchDirection("attack", mouseDirection)

func playAttack2(mouseDirection: Vector2) -> void:
	matchDirection("attack_2", mouseDirection)

func playTakeDamage() -> void:
	print("Taking damage!")

func playDeath(mouseDirection: Vector2) -> void:
	matchDirection("death", mouseDirection)

func waitAnimationFinished() -> void:
	await sprite.animation_finished

func flipHorizontal(flip: bool) -> void:
	sprite.flip_h = flip

func matchDirection(animationName : String, direction: Vector2) -> void:
	var isHorizontal = abs(direction.x) > abs(direction.y)
	var isRight = direction.x > 0
	var isDown = direction.y > 0

	if isHorizontal:
		if isRight:
			sprite.play(animationName + directions.right)
		else:
			sprite.play(animationName + directions.left)
	else:
		if isDown:
			sprite.play(animationName + directions.down)
		else:
			sprite.play(animationName + directions.up)
	
func modulateTakingDamage() -> void:
	sprite.self_modulate = modulatedTakingDamageColor

func modulateReset() -> void:
	sprite.self_modulate = modulatedOriginalColor

func setAttackFpsMultiplier(multiplier: float) -> void:

	# 8 * 0.2 = 1.6
	var result = BASE_ATTACK_FPS * multiplier

	# 8 + 1.6 -> 9.6 + 1.6 -> 11.12 + 1.6, etc..
	newFps += result

	print("newFps", newFps)

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