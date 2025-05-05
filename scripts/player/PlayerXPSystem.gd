class_name PlayerXPSystem
extends RefCounted

#Config
var level: int = 1
var xp: float = 0
# var xpToNextLevel: float = 8
var xpToNextLevel: float = 1
var xpMultiplier: float = 1.3

#Signals
signal add_xp(xp: int)
signal level_up(newLvl: int, xpNextLvl: int, currentXp: int)

#-------------------------#
func addExp(_xp: float) -> void:
	xp += _xp
	checkLvlUp()

func checkLvlUp() -> void:
	while xp >= xpToNextLevel:
		# Llenar la barra al tope
		add_xp.emit(xp)

		# Llenar la barra visualmente
		add_xp.emit(xpToNextLevel)
		
		xp -= xpToNextLevel
		
		# Subir nivel
		level += 1
		
		# Se redondea para eviar 2.333333333333333333333333
		xpToNextLevel = round(xpToNextLevel * xpMultiplier)
		
		# Resetear barra para el siguiente nivel
		level_up.emit(level, xpToNextLevel, 0) # XP a 0

	# Mostrar la experiencia sobrante
	add_xp.emit(xp)