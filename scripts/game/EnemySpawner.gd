extends Node2D

#Assets
const SLIME_ASSET = preload(Constants.ASSETS.ENEMIES.SLIME)
const BAT_ASSET = preload("res://scenes/enemies/bat.tscn")

#Nodes
@onready var player = GameUtils.getPlayer()
@onready var spawner = $Path2D/PathFollow2D
@onready var game = self.get_parent() as GameState

#Config
const BOSS_PROB := .03
const BAT_PROB := .1

#-------------------------#
func _process(_delta):

	if game.isPaused:
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

	enemy.setupPlayer(player, game, zIndex)
	spawner.progress_ratio = randf()
	enemy.global_position = spawner.global_position
	game.registerEnemy(enemy)
	get_parent().add_child(enemy)

func getIsBoss() -> bool:
	return randf() <= BOSS_PROB

	
func getIsBat() -> bool:
	return randf() <= BAT_PROB

func _on_timer_timeout() -> void:
	if game.isPaused:
		return
		
	#FIXME:
	spawnEnemy()
