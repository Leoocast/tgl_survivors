extends Node

@onready var musicPlayer := AudioStreamPlayer.new()
@onready var voicePlayer := AudioStreamPlayer.new()
@onready var announcerPlayer := AudioStreamPlayer.new()

func _ready() -> void:
	add_child(musicPlayer)
	add_child(voicePlayer)
	add_child(announcerPlayer)

func playMusic(stream: AudioStream) -> void:
	musicPlayer.stream = stream
	musicPlayer.play()

func playAndAwaitMusic(stream: AudioStream) -> void:
	musicPlayer.stream = stream
	musicPlayer.play()
	await musicPlayer.finished

func playVoice(stream: AudioStream) -> void:
	voicePlayer.stream = stream
	voicePlayer.play()

func playAndAwaitVoice(stream: AudioStream) -> void:
	voicePlayer.stream = stream
	voicePlayer.play()
	await voicePlayer.finished

func playAnnouncer(stream: AudioStream) -> void:
	announcerPlayer.stream = stream
	announcerPlayer.play()

func stopMusic() -> void:
	musicPlayer.stop()

func setVolume(db: float) -> void:
	musicPlayer.volume_db = db
