extends Node2D

const fireBall_asset = preload(GameConstants.ASSETS.PROJECTILES.FIRE_BAll) 

var canShoot := true
var cooldown := 0.3

func _process(delta: float) -> void:
	lookAtMouse()
	
func shoot() -> void:
	var projectile = fireBall_asset.instantiate()
	var source = $Marker2D.global_position
	
	projectile.global_position = source
	
	var mousePosition = get_global_mouse_position()
	var direction = (mousePosition - source).normalized()
	projectile.direction = direction
	projectile.rotation = direction.angle()

	var game = get_tree()
	game.current_scene.add_child(projectile)

func lookAtMouse() -> void:
	var mouse_pos = get_global_mouse_position()
	var dir = (mouse_pos - global_position).normalized()
	self.rotation = dir.angle()
