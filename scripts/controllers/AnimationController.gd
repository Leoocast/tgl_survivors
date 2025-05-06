class_name AnimationController
extends Node

#Setup
var sprite : AnimatedSprite2D
var modulatedAttackColor := Color8(255, 98, 113)
var modulatedTakingDamageColor := Color(2, 2, 2)
var modulatedOriginalColor := Color8(255,255,255)

#Internal
const ANIMATIONS = Constants.ANIMATIONS

#-------------------------#
func setup(_sprite: AnimatedSprite2D) -> void:
	self.sprite = _sprite

func playDefault() -> void:
	var direction = InputHandler.getDirection()
	if direction != Vector2.ZERO:
		playRun()
	else:
		playIdle()

func play(animation: String) -> void:
	sprite.play(animation)

func playAndAwait(animation: String) -> void:
	sprite.play(animation)
	await sprite.animation_finished

func playIdle() -> void:
	sprite.play(ANIMATIONS.IDLE)

func playRun() -> void:
	sprite.play(ANIMATIONS.RUN)

func playAttack() -> void:
	sprite.play(ANIMATIONS.ATTACK)

func playTakeDamage() -> void:
	sprite.play(ANIMATIONS.TAKE_DAMAGE)

func playDeath() -> void:
	sprite.play(ANIMATIONS.DEATH)

func waitAnimationFinished() -> void:
	await sprite.animation_finished

func flipHorizontal(flip: bool) -> void:
	sprite.flip_h = flip

func modulateAttack() -> void:
	sprite.self_modulate = modulatedAttackColor

func modulateTakingDamage() -> void:
	sprite.self_modulate = modulatedTakingDamageColor

func modulateReset() -> void:
	sprite.self_modulate = modulatedOriginalColor
