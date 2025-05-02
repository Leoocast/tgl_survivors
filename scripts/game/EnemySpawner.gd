extends Node2D

#Assets
const SLIME_ASSET = preload(Constants.ASSETS.ENEMIES.SLIME)

#Nodes
@onready var player = %Player
@onready var spawner = $Path2D/PathFollow2D
@onready var game = self.get_parent() as GameState

#Config
const BOSS_PROB := .03

#-------------------------#
func _process(_delta):

	if game.isPaused:
		return

	if player:
		global_position = player.global_position

func spawnEnemy() -> void:
	var slimeInstance = SLIME_ASSET.instantiate() as Slime

	var zIndex = [0, 2].pick_random()

	if getIsBoss():
		slimeInstance.convertIntoMiniBoss()

	slimeInstance.setupPlayer(player, game, zIndex)
	spawner.progress_ratio = randf()
	slimeInstance.global_position = spawner.global_position
	game.registerEnemy(slimeInstance)
	get_parent().add_child(slimeInstance)

func getIsBoss() -> bool:
	return randf() < BOSS_PROB

func _on_timer_timeout() -> void:
	if game.isPaused:
		return
		
	spawnEnemy()
