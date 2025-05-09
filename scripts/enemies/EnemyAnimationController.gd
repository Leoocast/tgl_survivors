class_name EnemyAnimationController
extends AnimationController

#Config
var shaderMaterial : ShaderMaterial
var animationPlayer : AnimationPlayer

#-------------------------#
func setup(_sprite: AnimatedSprite2D) -> void:
	self.sprite = _sprite
	self.animationPlayer = sprite.get_node("AnimationPlayer")

	sprite.material = sprite.material.duplicate()
	self.shaderMaterial = sprite.material as ShaderMaterial
	
func playTakeDamage() -> void:
	modulateReset()
	sprite.play(ANIMATIONS.TAKE_DAMAGE)

func modulateAttack() -> void:
	activateShaderAttack(true)

func modulateReset() -> void:
	activateShaderAttack(false)
	
func playFlashAnimation() -> void:
	animationPlayer.play("flash")

func playDeath() -> void:
	sprite.play(ANIMATIONS.DEATH)
	animationPlayer.play("death")

func activateShaderAttack(activate : bool) -> void:
	shaderMaterial.set_shader_parameter("isAttacking", activate)
