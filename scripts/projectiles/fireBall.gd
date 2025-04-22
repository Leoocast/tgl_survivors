extends Area2D

const speed := 1150
const attackRange := 1000

var travelledDistance := 0.0

var direction: Vector2 = Vector2.ZERO 

func _ready() -> void:
	$AnimatedSprite2D.play("attack")

func _physics_process(delta: float) -> void:
	direction = Vector2.RIGHT.rotated(rotation)
	self.position += direction * speed * delta 
	travelledDistance += speed * delta 
	
	if travelledDistance >= attackRange:
		queue_free()

func _on_body_entered(enemy: Enemy) -> void:

	if not GameHelper.isDamageable(enemy):
		return

	if not enemy.damageable.canTakeDamage:
		return
	
	queue_free()
	enemy.takeDamage()
