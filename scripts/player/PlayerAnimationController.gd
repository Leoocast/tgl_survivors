
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
var direction_vectors : Dictionary = {
	"up": Vector2(0, -1),
	"up_right": Vector2(1, -1).normalized(),
	"right": Vector2(1, 0),
	"down_right": Vector2(1, 1).normalized(),
	"down": Vector2(0, 1),
	"down_left": Vector2(-1, 1).normalized(),
	"left": Vector2(-1, 0),
	"up_left": Vector2(-1, -1).normalized(),
}

var lastFacingDirection: Vector2 = Vector2.ZERO

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

func on_attack_animation_started(index : int = 1) -> void:
	# var mousePosition = player.getMouseDirection() 

	var direction : Vector2

	if InputHandler.isShielding():
		direction = player.aimController.lastAimDirection
		playAttackByDirection(direction, index)
		return

	direction = InputHandler.getDirection()

	if direction == Vector2.ZERO:
		playAttackByDirection(lastFacingDirection, index)
		return
	
	playAttackByDirection(direction, index)

	# if player.weapon.type == Enums.WeaponType.BOW:
	# 	playAttackMouse(mousePosition)
	# 	return

	# if player.attackController.firstAttack:
	# 	playAttackMouse(mousePosition)
	# 	# sfxManager.playAttackSword1Delayed()
	# else:
	# 	playAttack2Mouse(mousePosition)
	# 	# await GameUtils.waitFor(0.1)
	# 	# sfxManager.playAttackSword2()

#-------------------------#
# func playDefaultByDirection() -> void:
# 	var inputDirection = InputHandler.getDirection()
# 	if inputDirection != Vector2.ZERO:
# 		playRunMouse(inputDirection)
# 	else:
# 		playIdleMouse(inputDirection)

func playIdleDirection() -> void:
	matchDirection("idle", lastFacingDirection)

func playDashDirection() -> void:
	matchDirection("dash", lastFacingDirection)

func playRunDirection(direction: Vector2) -> void:
	matchDirection("run", direction)
	lastFacingDirection = direction.normalized()

func playWalkDirection(direction: Vector2) -> void:
	matchDirection("walk", direction)
	lastFacingDirection = direction.normalized()

func playParryDirection(direction: Vector2) -> void:
	matchDirection("parry", direction)

func playAttackByDirection(direction: Vector2, attack_number: int) -> void:
	var dir_str = getClosestDirection(direction)
	var anim_name = "attack_%s_%d" % [dir_str, attack_number]
	sprite.play(anim_name)

# func playAttackByDirection(mouseDirection: Vector2) -> void:
# 	matchDirection("attack", mouseDirection)

func playDeathDirection(mouseDirection: Vector2) -> void:
	matchDirection("death", mouseDirection)

func waitAnimationFinished() -> void:
	await sprite.animation_finished

func flipHorizontal(flip: bool) -> void:
	sprite.flip_h = flip

func matchDirection(animationName: String, direction: Vector2) -> void:
	var closestDir = getClosestDirection(direction)

	var animationWillPlay = "%s_%s" % [animationName, closestDir]

	sprite.play(animationWillPlay)

func getClosestDirection(inputDir: Vector2) -> String:
	# if inputDir == Vector2.ZERO:
	# 	return "down"  # fallback o puedes usar la última dirección

	var bestDot := -INF
	var bestDirection := "down"

	for key in direction_vectors.keys():
		var dir = direction_vectors[key]
		var dot = inputDir.normalized().dot(dir)
		if dot > bestDot:
			bestDot = dot
			bestDirection = key

	return bestDirection
	
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

func getCurrentAttackFrame() -> int:
	if str(sprite.animation).begins_with("attack"):
		return sprite.frame
	
	return 0