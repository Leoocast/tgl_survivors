class_name PlayerWeapon
extends Weapon

#Export
@export var type : Enums.WeaponType

#Config
var player : Player :
	get:
		return owner
