extends Node2D

#Preload
const fireBall_asset = preload(Constants.ASSETS.PROJECTILES.FIRE_BAll) 

#Config
const damage := 1.0
const cooldown := 0.3

#Internal
var canShoot := true

func _process(_delta: float) -> void:
	lookAtMouse()
	
func shoot() -> void:
	var projectile = fireBall_asset.instantiate()
	var source = $Marker2D.global_position
	
	projectile.global_position = source
	
	var mousePosition = get_global_mouse_position()
	var direction = (mousePosition - source).normalized()
	projectile.direction = direction
	projectile.rotation = direction.angle()
	projectile.damage = damage
	var game = get_tree()
	game.current_scene.add_child(projectile)

func lookAtMouse() -> void:
	var mouse_pos = get_global_mouse_position()
	var dir = (mouse_pos - global_position).normalized()
	self.rotation = dir.angle()
