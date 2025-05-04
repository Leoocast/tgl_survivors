class_name ExpDrop
extends Area2D
#Config
const FLYING_SPEED = 1200
var expValue := 1
var malboroRatio := 10

#Internal
var isMalboro := false
var isFlying := false
var player : Player

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
	if isFlying and player:
		var direction = (player.global_position - global_position).normalized()
		global_position += direction * FLYING_SPEED * delta # velocidad hacia el jugador

		# Cuando está suficientemente cerca, absorbe
		if global_position.distance_to(player.global_position) < 100:
			addExperiencieToTarget()
			GameUtils.fadeOutAndDissapear(self, 0.1)
			isFlying = false
			
func showMalboro() -> void:
	$Malboro.show()
	$Coca.hide()

func showCoca() -> void:
	$Coca.show()
	$Malboro.hide()

func flyToTarget(_target : Player) -> void: 
	player = _target
	isFlying = true

func addExperiencieToTarget() -> void:
	var newExp = expValue * 2 if isMalboro else expValue
	player.xpSystem.addExp(newExp)
