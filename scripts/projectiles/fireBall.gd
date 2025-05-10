extends Area2D

#Config
var speed: float = 0.0
var attackRange: float = 0.0
var direction: Vector2

var source : PlayerWeapon

#Internal
var travelledDistance: float = 0.0

#-------------------------#
func setup(_source: PlayerWeapon, _speed: float, _attackRange: float, _direction: Vector2) -> void:
	self.source = _source
	self.speed = _speed
	self.attackRange = _attackRange
	self.direction = _direction

func _ready() -> void:
	$AnimatedSprite2D.play("attack")

func _physics_process(delta: float) -> void:
	self.position += direction * speed * delta 
	travelledDistance += speed * delta 
	
	if travelledDistance >= attackRange:
		queue_free()

func _on_body_entered(enemy: Enemy) -> void:
	queue_free()
	enemy.takeDamage(source.damage)
