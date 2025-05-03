extends Node

var tree: SceneTree:
	get:
		return get_tree()

func destroyAfter(time: float, node: Node) -> void:
	await tree.create_timer(time).timeout

	if is_instance_valid(node):
		node.queue_free()

func waitFor(time: float) -> void:
	await tree.create_timer(time).timeout

func createTween() -> void:
	return tree.create_tween()

func showHide(node: Node, time: float) -> void:
	node.show()
	await GameUtils.waitFor(time)
	node.hide()

func flash(sprite: AnimatedSprite2D) -> void:
	var originalColor = sprite.self_modulate
	sprite.self_modulate = Color(2,2,2)
	await GameUtils.waitFor(0.2)
	sprite.self_modulate = originalColor

func fadeOutAndDissapear(node : Node2D, time : float = 0.5) -> void:
	var tween = create_tween()
	tween.tween_property(node, "modulate:a", 0.0, time)
	tween.tween_callback(Callable(node, "queue_free"))

func fadeIn(node : Node2D, time: float = 0.5) -> void:
	var tween = create_tween()
	tween.tween_property(node, "modulate:a", 1.0, time)
	
func flipColliderHorizontal(collider: CollisionShape2D, flip: bool) -> void:
	if flip:
		collider.position.x = -abs(collider.position.x)

		print("Absoluto: ", abs(collider.position.x))
		print("Normal: ", collider.position.x)
		print("-30: ", collider.position.x - 30)

	else:
		collider.position.x = abs(collider.position.x)
	
func getGlobalNode(_name: String) -> Node2D:
	var node := tree.get_root().get_node(_name)
	return node

func getGame() -> GameState:
	var game = getGlobalNode("Game") as GameState
	return game