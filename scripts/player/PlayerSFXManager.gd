class_name PlayerSFXManager
extends Node

#Nodes
@onready var audioPlayer: AudioStreamPlayer

#Config
var player: Player

#SFX
var sfx_sword_1: AudioStream = load(PATHS.PLAYER_SFX.SWORD_1) as AudioStream
var sfx_sword_2: AudioStream = load(PATHS.PLAYER_SFX.SWORD_2) as AudioStream

#-------------------------#
func _init():
	audioPlayer = AudioStreamPlayer.new()
	audioPlayer.volume_db = -15

func setupPlayer(_player: Player) -> void:
	self.player = _player
	player.add_child(audioPlayer)

#Suscriptions
#Si se empieza a desfazar el audio, que el animation emita el signal justo en el frame adecuado y quitamos el await.
func on_attack_animation_started() -> void:
	if player.attackController.firstAttack:
		await GameUtils.waitFor(0.3)
		playAttackSword1()
	else:
		await GameUtils.waitFor(0.1)
		playAttackSword2()

#-------------------------#
func playAttackSword1() -> void:
	audioPlayer.stream = sfx_sword_1
	audioPlayer.play()

func playAttackSword2() -> void:
	audioPlayer.stream = sfx_sword_2
	audioPlayer.play()

func playAttackSword1Delayed() -> void:
	await GameUtils.waitFor(0.3)
	AudioManager.playSoundEffect(sfx_sword_1)
