extends Node

@onready var musicPlayer := AudioStreamPlayer.new()
@onready var selectionUpdateMusicPlayer := AudioStreamPlayer.new()
@onready var voicePlayer := AudioStreamPlayer.new()
@onready var announcerPlayer := AudioStreamPlayer.new()
@onready var soundEffectPlayer := AudioStreamPlayer.new()

#Internal
var musicActualPosition := 0.0

func _ready() -> void:
	add_child(musicPlayer)
	add_child(voicePlayer)
	add_child(announcerPlayer)
	add_child(soundEffectPlayer)
	add_child(selectionUpdateMusicPlayer)

func playMusic(stream: AudioStreamOggVorbis) -> void:
	musicPlayer.stream = stream
	musicPlayer.play()

func fadeOutMusicAndPause():
	var tween := create_tween()
	tween.tween_property(musicPlayer, "volume_db", -80, 1.5)
	tween.tween_callback(Callable(self, "_on_fade_out_complete"))

func _pause_music():
	musicPlayer.stream_paused = true

func fadeInMusicAndPlay():
	musicPlayer.stream_paused = false  # Reactiva la música
	musicPlayer.volume_db = -80        # Asegúrate de que empieza en silencio

	var tween := create_tween()
	tween.tween_property(musicPlayer, "volume_db", 0, 0.4)  # Subida suave

func playSelectionUpdateMusic(stream: AudioStreamOggVorbis) -> void:
	selectionUpdateMusicPlayer.stream = stream
	selectionUpdateMusicPlayer.volume_db = -10
	selectionUpdateMusicPlayer.play()

func stopSelectionUpdateMusic() -> void:
	selectionUpdateMusicPlayer.stop()

func playAndAwaitMusic(stream: AudioStream) -> void:
	musicPlayer.stream = stream
	musicPlayer.play()
	await musicPlayer.finished

func playSoundEffect(stream: AudioStream) -> void:
	soundEffectPlayer.stream = stream
	soundEffectPlayer.play()

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
