class_name PlayerWeaponManager
extends Node

#Config
var player: Player
var currentWeapon: PlayerWeapon

#0-Sword, 1-Bow
var weapons : Array[PlayerWeapon]

#-------------------------#
func _ready():
	initialize()
	currentWeapon = weapons[0]

func initialize() -> void: 
	for child in get_children():
		if child is PlayerWeapon:
			weapons.append(child)

func setupPlayer(_player: Player) -> void:
	self.player = _player
	
func equipWeapon(weaponType: Enums.WeaponType) -> void:
	if currentWeapon.type == weaponType:
		return

	currentWeapon = findWeapon(weaponType)
	
func findWeapon(weaponType: Enums.WeaponType) -> PlayerWeapon:
	for weapon: PlayerWeapon in weapons:
		if weapon.type == weaponType:
			return weapon

	return null

func swapWeapons() -> void:
	print("Current: ", currentWeapon.name)

	if currentWeapon.type == Enums.WeaponType.MACHETE:
		equipWeapon(Enums.WeaponType.BOW)
		print("Equipped: ", currentWeapon.name)
		return
	
	if currentWeapon.type == Enums.WeaponType.BOW:
		equipWeapon(Enums.WeaponType.MACHETE)
		print("Equipped: ", currentWeapon.name)
		return
