extends Node

var tree: SceneTree:
    get:
        return get_tree()

func destroyAfter(time: float, node: Node) -> void:
    await tree.create_timer(time).timeout

    if is_instance_valid(node):
        node.queue_free()

func isDamageable(node: Node, debug: bool = false) -> bool:
    var hasTakeDamage =  node.has_method("takeDamage")

    if debug:
        if not hasTakeDamage:
             push_error(node.name, " no implementa el método -> takeDamage()")

    return "damageable" in node and node.damageable is Damageable and hasTakeDamage

func waitFor(time: float) -> void:
    await tree.create_timer(time).timeout

func createTween() -> void:
    return tree.create_tween()

func showHide(node: Node, time: float) -> void:
    node.show()
    await GameHelper.waitFor(time)
    node.hide()