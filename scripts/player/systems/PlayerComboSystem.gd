class_name PlayerComboSystem
extends RefCounted

#Config
const KILL_THRESHOLD: Array[int] = [15, 30, 50, 75, 100, 150, 250]
const KILL_MESSAGES: Array[String] = ["DIRTY", "CRAZY","BRUTAL", "ANARCHY", "SAVAGE", "SSADISTIC", "SSSENSATIONAL"]
const MESSAGE_DURATION: float = 2.0
const COMBO_DURATION: float = 7
var announcerAudios: Array[AudioStream] = PlayerComboSystemAudioList.new().announcerAudios

#Internal
var timer: Timer
var killCount: int = 0
var killTimer: float = 0.0
var comboKillCount: float = 0
var currentThreshold: float = 0

#Signals
signal got_threshold(message: String)

#-------------------------#
func setupTimer(_timer: Timer) -> void:
	self.timer = _timer
	timer.wait_time = COMBO_DURATION
	timer.timeout.connect(_on_timer_timeout)

func pauseTimer() -> void:
	timer.paused = true

func resumeTimer() -> void:
	timer.paused = false

func on_enemy_died() -> void:
	killCount += 1
	comboKillCount += 1
	if comboKillCount == KILL_THRESHOLD[currentThreshold]:
		
		got_threshold.emit(KILL_MESSAGES[currentThreshold])
		
		timer.start()
		
		AudioManager.playAnnouncer(announcerAudios[currentThreshold])

		if currentThreshold < KILL_THRESHOLD.size() - 1:
			currentThreshold += 1 

func _on_timer_timeout() -> void:
	comboKillCount = 0
	currentThreshold = 0

