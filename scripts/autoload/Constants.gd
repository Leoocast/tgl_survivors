# Constants
extends Node

#TODO: Separar en 2 archivos, Paths y Globals.
const SCENES = {
	"MENU": "res://scenes/menu.tscn",
	"MENU_OPTIONS": "res://scenes/optionsMenu.tscn",
	"GAME": "res://scenes/game.tscn"
}

const CONTROLLERS = {
	"DashController": "res://scripts/player/DashController.gd"
}

const ASSETS = {
	"PROJECTILES": {
		"FIRE_BAll": "res://scenes/projectiles/fireBall.tscn",
	},
	"ENEMIES":{
		"SLIME": "res://scenes/enemies/slime.tscn"
	},
	"DROP": {
		"XP": "res://scenes/game/exp_drop.tscn"
	}
}

const PLAYER_SFX = {
	"SWORD_1": "res://assets/audio/sound_effects/sword_effect_1.wav",
	"SWORD_2": "res://assets/audio/sound_effects/sword_effect_2.wav"
}

const ANIMATIONS = {
    "IDLE" : "idle",
    "RUN" : "run",
    "ATTACK" : "attack",
	"TAKE_DAMAGE": "take_damage",
	"DEATH": "death"
}

const GROUPS = {
	"EXP_DROP": "expDrop",
	"PLAYER": "player"
}

const EL_TATA_SLAYER_ANIMATIONS = {
	"ATTACK_UP": "attack_up",
	"ATTACK_DOWN": "attack_down",
	"ATTACK_LEFT": "attack_left",
	"ATTACK_RIGHT": "attack_right",
	"ATTACK_2_UP": "attack_2_up",
	"ATTACK_2_DOWN": "attack_2_down",
	"ATTACK_2_LEFT": "attack_2_left",
	"ATTACK_2_RIGHT": "attack_2_right",

	"IDLE_UP": "idle_up",
	"IDLE_DOWN": "idle_down",
	"IDLE_LEFT": "idle_left",
	"IDLE_RIGHT": "idle_right",

	"RUN_UP": "run_up",
	"RUN_DOWN": "run_down",
	"RUN_LEFT": "run_left",
	"RUN_RIGHT": "run_right",
}