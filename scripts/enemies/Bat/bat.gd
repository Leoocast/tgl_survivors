class_name Bat
extends Enemy

#Nodes
@onready var separationArea : Area2D = $SeparationArea

#Config
const SEPARATION_STRENGTH: float = 14000

#-------------------------#
func _ready():
	self.setup()
	# collision.rotation = 45

func _physics_process(_delta):
	defaultProcess(calculateSeparation())

func calculateSeparation() -> Vector2:
	var result = Vector2.ZERO

	var overlappingBoddies = separationArea.get_overlapping_bodies()

	for body in overlappingBoddies:
		if body is not Enemy: continue

		var offset = (global_position - body.global_position) as Vector2
		var distance = offset.length()

		if distance > 0:
			result += offset.normalized() / distance
	
	return result * SEPARATION_STRENGTH


# Signals
# El frame en el que puede atacar
func _on_animated_sprite_2d_frame_changed() -> void:
	if $AnimatedSprite2D.animation == "attack":
		var current_frame = $AnimatedSprite2D.frame
		if current_frame == 3:
			self.enableAttackHitbox()
		else:
			self.disableAttackHitbox()

# Cuando entra al rango empieza atacar
func _on_area_2d_body_entered(body: Node2D) -> void:
	self.on_area_2d_body_entered_default(body)

#Si esta a rango del collider de ataque, recibe da;o
func _on_attack_area_body_entered(body: Node2D) -> void:
	self.on_attack_area_body_entered_default(body)

#El player no esta a rango
func _on_area_2d_body_exited(body: Node2D) -> void:
	self.on_area_2d_body_exited_default(body)
