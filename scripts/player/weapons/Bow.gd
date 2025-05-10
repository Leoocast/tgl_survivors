class_name Bow
extends PlayerWeapon

#Preload
const fireball_scene = preload(PATHS.SCENES.PROJECTILES.FIRE_BAll) 

#Config
@export var speed: float = 1500
@export var attackRange: float = 1000

#-------------------------#
func shoot() -> void:
	var fireball = fireball_scene.instantiate()
	var source = player.aimController.get_node("Source") as Marker2D

	var direction = (get_global_mouse_position() - source.global_position).normalized()

	fireball.global_position = source.global_position
	fireball.rotation = direction.angle()
	fireball.setup(self, speed, attackRange, direction)

	GameUtils.tree.current_scene.add_child(fireball)
