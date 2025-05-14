class_name EnemyAnimationController
extends AnimationController

#Config
var shaderMaterial : ShaderMaterial
var animationPlayer : AnimationPlayer

#Signals
signal take_damage_animation_finished

#-------------------------#
func setup(_sprite: AnimatedSprite2D) -> void:
	self.sprite = _sprite
	self.animationPlayer = sprite.get_node("AnimationPlayer")

	sprite.material = sprite.material.duplicate()
	self.shaderMaterial = sprite.material as ShaderMaterial
	
func playTakeDamage() -> void:
	modulateReset()
	sprite.play(ANIMATIONS.TAKE_DAMAGE)

	if not sprite.animation_finished.is_connected(_on_take_damage_animation_finished):
		sprite.animation_finished.connect(_on_take_damage_animation_finished, CONNECT_ONE_SHOT)

func _on_take_damage_animation_finished():
	take_damage_animation_finished.emit()

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

