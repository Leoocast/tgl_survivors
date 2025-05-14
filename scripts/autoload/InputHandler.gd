extends Node

func getRightStickDirection() -> Vector2:
	var x = Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
	var y = Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)

	var dir = Vector2(x, y)
	if dir.length() > 0.2: # zona muerta para evitar ruido
		return dir.normalized()
		
	return Vector2.ZERO

func getDirection() -> Vector2:
	var direction = Input.get_vector("left", "right", "up", "down")
	return direction

func isMoving() -> bool:
	var direction = getDirection()
	return direction != Vector2.ZERO

func isShielding() -> bool:
	return (
		Input.get_action_strength("shield") > 0.5 or 
		Input.get_joy_axis(0, JOY_AXIS_TRIGGER_LEFT) > 0.5
	)

func getDirectionX() -> float:
	var direction = getDirection()
	return direction.x

func isAttacking() -> bool:
	return Input.is_action_pressed("attack")
	
func isDashing() -> bool:
	return Input.is_action_just_pressed("dash")

func isTryingSwapWeapons() -> bool:
	return Input.is_action_just_pressed("swap_weapon")

#Controller
func debugJoypad():
	for i in range(0, 15): # Asume máximo 15 botones
		if Input.is_joy_button_pressed(0, i):
			print("Botón presionado: ", i)