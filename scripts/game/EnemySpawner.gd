extends Node2D

#Assets
const SLIME_ASSET = preload(Constants.ASSETS.ENEMIES.SLIME)
const BAT_ASSET = preload("res://scenes/enemies/bat.tscn")

#Nodes
@onready var player = GameUtils.getPlayer()
@onready var main = GameUtils.getMain()
@onready var spawner = $Path2D/PathFollow2D

#Config
const BOSS_PROB := .03
const BAT_PROB := .1

#-------------------------#
func _process(_delta):

	if GameState.isNotRunning():
		return

	if player:
		global_position = player.global_position

func spawnEnemy() -> void:

	var enemy : Enemy

	if getIsBat():
		enemy = BAT_ASSET.instantiate() as Bat
	else:
		enemy = SLIME_ASSET.instantiate() as Slime
	
	var zIndex = [0, 2].pick_random()

	if getIsBoss():
		enemy.convertIntoMiniBoss()

	enemy.setupZIndex(zIndex)
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
		
	#FIXME:
	spawnEnemy()
