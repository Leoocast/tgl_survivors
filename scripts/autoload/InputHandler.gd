extends Node

func getDirection() -> Vector2:
	var direction = Input.get_vector("left", "right", "up", "down")
	return direction

func getDirectionX() -> float:
	var direction = getDirection()
	return direction.x

func isAttacking() -> bool:
	return Input.is_action_pressed("attack")
	
func isDashing() -> bool:
	return Input.is_action_just_pressed("dash")

func isTryingSwapWeapons() -> bool:
	return Input.is_action_just_pressed("swap_weapon")
