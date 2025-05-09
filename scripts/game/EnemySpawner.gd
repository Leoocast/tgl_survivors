extends Node2D

#Assets
const SLIME_ASSET = preload(PATHS.SCENES.ENEMIES.SLIME)
const BAT_ASSET = preload(PATHS.SCENES.ENEMIES.BAT)

#Nodes
@onready var player: Player = GameUtils.getPlayer()
@onready var main: Node2D = GameUtils.getMain()
@onready var spawner: PathFollow2D = $Path2D/PathFollow2D

#Config
const BOSS_PROB: float = .03
const BAT_PROB: float = .08

var counter = 0

#-------------------------#
func _process(_delta):

	if GameState.isNotRunning():
		return

	if player:
		global_position = player.global_position

func spawnEnemy() -> void:

	var enemy: Enemy

	if getIsBat():
		enemy = BAT_ASSET.instantiate() as Bat
	else:
		enemy = SLIME_ASSET.instantiate() as Slime
	
	var zIndex = [0, 2].pick_random()

	if getIsBoss():
		enemy.convertIntoMiniBoss()

	if enemy is not Bat:
		enemy.setupZIndex(zIndex)

	enemy.died.connect(on_enemy_died)

	spawner.progress_ratio = randf()
	enemy.global_position = spawner.global_position
	main.registerEnemy(enemy)
	get_parent().add_child(enemy)

func getIsBoss() -> bool:
	return randf() <= BOSS_PROB

	
func getIsBat() -> bool:
	return randf() <= BAT_PROB

func _on_timer_timeout() -> void:
	if GameState.isNotRunning():
		return
		
	if counter >= 300:
		return

	spawnEnemy()
	print("Enemies: ", counter)
	counter += 1

func on_enemy_died() -> void:
	counter -= 1
