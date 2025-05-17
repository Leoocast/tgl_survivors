class_name PlayerAttackCollisionMap
extends RefCounted

#Config
var map: Dictionary

#-------------------------#
func setup(attackArea: CollisionObject2D) -> void:
	map = {
		"up_1": attackArea.get_node("UpCollision"),
		"up_2": attackArea.get_node("UpCollision"),
		"up_3": attackArea.get_node("UpCollision"),
		
		"up_left_1": attackArea.get_node("LeftCollision"),
		"up_left_2": attackArea.get_node("LeftCollision"),
		"up_left_3": attackArea.get_node("LeftCollision"),
		
		"up_right_1": attackArea.get_node("RightCollision"),
		"up_right_2": attackArea.get_node("RightCollision"),
		"up_right_3": attackArea.get_node("RightCollision"),
				
		"down_1": attackArea.get_node("DownCollision"),
		"down_2": attackArea.get_node("DownCollision"),
		"down_3": attackArea.get_node("DownCollision"),

		
		"down_left_1": attackArea.get_node("LeftCollision"),
		"down_left_2": attackArea.get_node("LeftCollision"),
		"down_left_3": attackArea.get_node("LeftCollision"),
		
		"down_right_1": attackArea.get_node("RightCollision"),
		"down_right_2": attackArea.get_node("RightCollision"),
		"down_right_3": attackArea.get_node("RightCollision"),

		"left_1": attackArea.get_node("LeftCollision"),
		"left_2": attackArea.get_node("LeftCollision"),
		"left_3": attackArea.get_node("LeftCollision"),

		"right_1": attackArea.get_node("RightCollision"),
		"right_2": attackArea.get_node("RightCollision"),
		"right_3": attackArea.get_node("RightCollision"),
	}

func getDirection(direction: String) -> CollisionObject2D:
	return map[direction]