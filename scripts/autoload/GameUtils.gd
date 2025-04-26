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

func flipColliderHorizontal(collider: CollisionShape2D, flip: bool) -> void:
    if flip:
        collider.position.x = -abs(collider.position.x)
    else:
        collider.position.x = abs(collider.position.x)
    