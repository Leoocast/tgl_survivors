extends Area2D

const speed := 1150
const range := 1000

var travelledDistance := 0

var direction: Vector2 = Vector2.ZERO 

func _ready() -> void:
	$AnimatedSprite2D.play("attack")

func _physics_process(delta: float) -> void:
	direction = Vector2.RIGHT.rotated(rotation)
	self.position += direction * speed * delta 
	travelledDistance += speed * delta 
	
	if travelledDistance >= range:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	queue_free()
	body.queue_free()
	print("Toco a un peton!", body.name)
