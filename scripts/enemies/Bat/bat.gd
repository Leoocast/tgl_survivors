class_name Bat
extends Enemy

#-------------------------#
func _ready():
	self.setup()
	# collision.rotation = 45

func _physics_process(delta):
	defaultProcess(delta, calculateSeparation())

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
