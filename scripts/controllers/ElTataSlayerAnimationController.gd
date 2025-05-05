
class_name PlayerAnimationController
extends AnimationController

#Setup
const BASE_ATTACK_FPS := 10.0
var newFps := BASE_ATTACK_FPS
var player : Player

#VFX
var levelUpAuraRed: AnimatedSprite2D
var levelUpAuraYellow: AnimatedSprite2D

#Internal
var directions = {
	"up": "_up",
	"down": "_down",
	"left": "_left",
	"right": "_right",
}

#-------------------------#
func setupPlayer(_player: Player , ssjAura : Array[Node2D]) -> void:
	self.player = _player
	self.setup(player.get_node("AnimatedSprite2D"))
	
	self.levelUpAuraRed = ssjAura[0] as AnimatedSprite2D
	self.levelUpAuraYellow = ssjAura[1] as AnimatedSprite2D

#Consumers
func on_player_died() -> void:
	var mousePosition = player.calculateMousePosition()
	playDeathDirection(mousePosition)

func on_taking_damage_started() -> void:
	modulateTakingDamage()

func on_taking_damage_finished() -> void:
	await GameUtils.waitFor(0.1)
	modulateReset()

func on_attack_animation_started() -> void:
	var mousePosition = player.calculateMousePosition() 

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
