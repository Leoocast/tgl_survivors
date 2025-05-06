class_name PlayerTrail
extends Node

#Nodes
@onready var trail = $Trail

#Config
var trailQueue : Array
var trailMaxLenth = 20
var player : Player

#-------------------------#
func setupPlayer(_player: Player) -> void:
	self.player = _player

func drawTrail() -> void:
	var tween := create_tween()

	if player.dashController.isDashing:
		tween.tween_property(trail, "modulate:a", 1.0, 0.1)
	else:
		tween.tween_property(trail, "modulate:a", 0.0, 0.3)

	var localPos = trail.to_local(player.global_position) + Vector2(40, 40)
	trailQueue.push_front(localPos)

	if trailQueue.size() > trailMaxLenth:
		trailQueue.pop_back()

	trail.clear_points()
	for point in trailQueue:
		trail.add_point(point)
