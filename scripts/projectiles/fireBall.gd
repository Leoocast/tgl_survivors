extends Area2D

#Config
var speed := 0.0
var attackRange := 0.0
var damage : float
var direction: Vector2

#Internal
var travelledDistance := 0.0

#-------------------------#
func setup(_speed: float, _attackRange: float, _damage: float, _direction: Vector2) -> void:
	speed = _speed
	attackRange = _attackRange
	direction = _direction
	damage = _damage

func _ready() -> void:
	$AnimatedSprite2D.play("attack")

func _physics_process(delta: float) -> void:
	self.position += direction * speed * delta 
	travelledDistance += speed * delta 
	
	if travelledDistance >= attackRange:
		queue_free()

func _on_body_entered(enemy: Enemy) -> void:
	queue_free()
	enemy.takeDamage(damage)
