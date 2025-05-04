class_name PlayerAttackCollisionMap
extends RefCounted

var map : Dictionary

func setup(attackArea: CollisionObject2D) -> void:
	map = {
		"up": attackArea.get_node("UpCollision"),
		"down": attackArea.get_node("DownCollision"),
		"left": attackArea.get_node("LeftCollision"),
		"right": attackArea.get_node("RightCollision"),
		
		"2_up": attackArea.get_node("UpCollision2"),
		"2_down": attackArea.get_node("DownCollision2"),
		"2_left": attackArea.get_node("LeftCollision2"),
		"2_right": attackArea.get_node("RightCollision2"),
	}

func getDirection(direction: String) -> CollisionObject2D:
	return map[direction]