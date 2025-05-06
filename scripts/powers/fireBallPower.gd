extends Node2D

#Preload
const fireBall_asset = preload(PATHS.ASSETS.PROJECTILES.FIRE_BAll) 

#Config
const cooldown: float = 0.3
const DAMAGE: float = 1.0
const SPEED: float = 1150
const ATTACK_RANGE: float = 1000

#Internal
var canShoot: bool = true

#-------------------------#
func _process(_delta: float) -> void:
	lookAtMouse()
	
func shoot() -> void:
	var projectile = fireBall_asset.instantiate()
	var source = $Marker2D.global_position
	var direction = (get_global_mouse_position() - source).normalized()
	
	projectile.global_position = source
	projectile.rotation = direction.angle()
	projectile.setup(SPEED, ATTACK_RANGE, DAMAGE, direction)

	GameUtils.tree.current_scene.add_child(projectile)

func lookAtMouse() -> void:
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()
	self.rotation = direction.angle()
