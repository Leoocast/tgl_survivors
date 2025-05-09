class_name HUDComboController
extends Control

#Nodes
@onready var label: Label = $Label as Label
@onready var timeBar: ProgressBar = $ProgressBar as ProgressBar
@onready var comboTimer: Timer = $ComboTimer as Timer

#Systems
var comboSystem: PlayerComboSystem = PlayerComboSystem.new()

#-------------------------#
func _ready():
	comboSystem.setupTimer(comboTimer)
	comboSystem.got_threshold.connect(on_got_threshold)
	comboSystem.timer.timeout.connect(on_combo_timer_timeout)
	hideComboStuff()

func _process(_delta):
	updateComboBar()

func hideComboStuff() -> void:
	label.hide()
	timeBar.hide()

func showComboStuff() -> void:
	label.show()
	timeBar.show()

func updateComboBar() -> void:
	if comboSystem.timer.is_stopped():
		return

	var remaining = comboSystem.timer.time_left
	var total = comboSystem.timer.wait_time
	timeBar.value = remaining / total * timeBar.max_value

#Signals
func on_got_threshold(message: String)-> void:
	label.text = message
	showComboStuff()

func on_combo_timer_timeout() -> void:
	hideComboStuff()
