extends Node2D

const fireball_scene = preload(PATHS.SCENES.PROJECTILES.FIRE_BAll) 

@onready var source = $Marker2D
@onready var weapon = $Weapon as Weapon



@export var speed: float = 1500
@export var attackRange: float = 1000

func _on_timer_timeout() -> void:
	var fireball = fireball_scene.instantiate()
	
	var direction = Vector2(-1, 0).normalized()

	fireball.global_position = source.global_position
	fireball.rotation = direction.angle()
	fireball.setup(self, speed, attackRange, direction, weapon)

	GameUtils.tree.current_scene.add_child(fireball)