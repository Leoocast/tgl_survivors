
#FIXME: Esto debe heredar de AnimationController
class_name ElTataSlayerAnimationController
extends Node

#Setup
var sprite : AnimatedSprite2D

#Internal
const ANIMATIONS = Constants.ANIMATIONS
var directions = {
	"up": "_up",
	"down": "_down",
	"left": "_left",
	"right": "_right",
}

#-------------------------#
func setup(_sprite: AnimatedSprite2D) -> void:
	self.sprite = _sprite

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

func playDeath() -> void:
	print("I'm Death!")

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