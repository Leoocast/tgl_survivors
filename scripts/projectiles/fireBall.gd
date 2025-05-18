extends Area2D

#Config
var speed: float = 0.0
var attackRange: float = 0.0
var direction: Vector2

var source : Node2D

#Internal
var travelledDistance: float = 0.0

#Todo Borrar:
var weapon : Weapon

#-------------------------#
func setup(_source: Node2D, _speed: float, _attackRange: float, _direction: Vector2, _weapon: Weapon) -> void:
	self.source = _source
	self.speed = _speed
	self.attackRange = _attackRange
	self.direction = _direction

	self.weapon = _weapon

func _ready() -> void:
	$AnimatedSprite2D.play("attack")

func _physics_process(delta: float) -> void:
	self.position += direction * speed * delta 
	travelledDistance += speed * delta 
	
	if travelledDistance >= attackRange:
		queue_free()

func _on_body_entered(body: Player) -> void:

	body.healthController.takeDamageWithSource(self)
	queue_free()
	# enemy.takeDamage(source.damage)

# Todo Esto no sirve, es para que no truene el test:
func disableAttackHitbox() -> void:
	pass

func takeDamage(_damage: float, _damageByLevelUp: bool = false, _isCritic: bool = false, _isParry: bool = false, _perfectParry: bool = false) -> void:
	pass

func applyKnockback(_from_position: Vector2, _strength: float) -> void:
	pass
