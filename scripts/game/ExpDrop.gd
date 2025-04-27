class_name ExpDrop
extends Area2D

#Nodes
@onready var playerDetector := $CollisionShape2D

#Config
const FLYING_SPEED = 1200
var expValue := 1
var malboroRatio := 10

#Internal
var isMalboro := false
var isFlying := false
var target : Node2D

#-------------------------#
func _ready():
	add_to_group(Constants.GROUPS.EXP_DROP)
	self.modulate.a = 0.0
	var percentage = randi_range(0, 100)

	if percentage <= malboroRatio:
		showMalboro()
		isMalboro = true
	else:
		showCoca()

func _physics_process(delta):
	if isFlying and target:
		var direction = (target.global_position - global_position).normalized()
		global_position += direction * FLYING_SPEED * delta # velocidad hacia el jugador

		# Cuando está suficientemente cerca, absorbe
		if global_position.distance_to(target.global_position) < 100:
			addExperiencieToTarget()
			GameUtils.fadeOutAndDissapear(self, 0.1)
			isFlying = false
			
func showMalboro() -> void:
	$Malboro.show()
	$Coca.hide()

func showCoca() -> void:
	$Coca.show()
	$Malboro.hide()

func flyToTarget(_target : Node2D) -> void: 
	target = _target
	isFlying = true

func addExperiencieToTarget() -> void:
	var newExp = expValue * 2 if isMalboro else expValue
	target.addExp(newExp)
	print("Experiencia total: ", target.xp)
#Signals



# func _on_body_entered(body: Node2D) -> void:
# 	if body is not ElTataSlayer:
# 		return

# 	var newExp = expValue * 2 if isMalboro else expValue
# 	var player = body as ElTataSlayer
	
# 	player.addExp(newExp)
# 	GameUtils.fadeOutAndDissapear(self, 0.2)
# 	
	
