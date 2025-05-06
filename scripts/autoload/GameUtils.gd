extends Node

var tree: SceneTree:
	get:
		return get_tree()

#Nodes
func getGlobalNode(_name: String) -> Node2D:
	var node := tree.get_root().get_node(_name)
	return node

func getMain() -> Main:
	var main = getGlobalNode("Main") as Main
	return main

func getPlayer() -> Player:
	return tree.get_first_node_in_group("player") as Player

func getPlayerCollider() -> CollisionShape2D:
	var player = getPlayer()
	return player.get_node("CollisionShape2D") as CollisionShape2D
	
func registerInGroup(node: Node, group: String) -> void:
	node.add_to_group(group)

#Sprites / Tweens
func createTween() -> void:
	return tree.create_tween()

func fadeOutAndDissapear(node: Node2D, time: float = 0.5) -> void:
	var tween = create_tween()
	tween.tween_property(node, "modulate:a", 0.0, time)
	tween.tween_callback(Callable(node, "queue_free"))

func fadeIn(node : Node2D, time: float = 0.5) -> void:
	var tween = create_tween()
	tween.tween_property(node, "modulate:a", 1.0, time)

func flipColliderHorizontal(collider: CollisionShape2D, flip: bool) -> void:
	if flip:
		collider.position.x = -abs(collider.position.x)
	else:
		collider.position.x = abs(collider.position.x)

#TODO: Create a shader for this
func flash(sprite: AnimatedSprite2D) -> void:
	var originalColor = sprite.self_modulate
	sprite.self_modulate = Color(2,2,2)
	await GameUtils.waitFor(0.2)
	sprite.self_modulate = originalColor

# Timers
func destroyAfter(time: float, node: Node) -> void:
	await tree.create_timer(time).timeout

	if is_instance_valid(node):
		node.queue_free()

func waitFor(time: float) -> void:
	await tree.create_timer(time).timeout

func showHide(node: Node, time: float) -> void:
	node.show()
	await GameUtils.waitFor(time)
	node.hide()

#Validation
func validateAttributes(attributes: Attributes, type: Node2D) -> void:
	assert(attributes != null, "[" + type.name +  "]" + " No tiene atributos asigandos en el inspector." )

func validateEnemyAttributes(attributes: EnemyAttributesResource, type: Node2D) -> void:
	validateAttributes(attributes, type)
	assert(attributes.exp_drop_scene != null, validationMessage(type, "No tiene <Exp Drop Scene> asignada"))
	assertWarning(attributes.sfx_hurt != null, validationMessage(type, "No tiene <Sfx Hurt> asignado"))
	
#Formatting
func validationMessage(type: Node2D, message: String) -> String:
	return "[" + type.name +  "] " + message

func assertWarning(isThere : bool, message: String) -> void:
	if isThere: 
		return
	
	push_warning(message)
