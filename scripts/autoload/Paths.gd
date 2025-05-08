extends Node

const SCENES = {
	"MENU": "res://scenes/menu.tscn",
	"MENU_OPTIONS": "res://scenes/optionsMenu.tscn",
	"GAME": "res://scenes/game.tscn",
	
	"ENEMIES":{
		"SLIME": "res://scenes/enemies/slime.tscn",
		"BAT": "res://scenes/enemies/bat.tscn"
	},
	
	"DAMAGE_LABEL": "res://scenes/game/damage_label.tscn",

	"PROJECTILES": {
		"FIRE_BAll": "res://scenes/projectiles/fireBall.tscn",
	},
	
	"PLAYER_UPGRADE_OPTION": "res://scenes/UI/upgrade_option.tscn", 

}

const SHADERS = {
	"FLASH" : "res://shaders/flash.gdshader",
	"ENEMY_ATTAK" : "res://shaders/enemy_attack.gdshader"
}

const PLAYER_SFX = {
	"SWORD_1": "res://assets/audio/sound_effects/sword_effect_1.wav",
	"SWORD_2": "res://assets/audio/sound_effects/sword_effect_2.wav"
}

const ANNOUNCER = {
	"DIRTY": "res://assets/audio/announcer/Dirty.mp3",
	"CRAZY": "res://assets/audio/announcer/Crazy.mp3",
	"BRUTAL": "res://assets/audio/announcer/Brutal.mp3",
	"ANARCHY": "res://assets/audio/announcer/Anarchy.mp3",
	"SAVAGE": "res://assets/audio/announcer/Savage.mp3",
	"SSADISTIC": "res://assets/audio/announcer/SSadistic.mp3",
	"SSSENSATIONAL": "res://assets/audio/announcer/SSSensational.mp3",
}

const PLAYER_UPGRADES = {
	"MOVEMENT_SPEED": "res://scripts/player/upgrades/MovementSpeedUpgrade.gd",
	"ATTACK_DAMAGE": "res://scripts/player/upgrades/AttackDamageUpgrade.gd",
	"ATTACK_SPEED": "res://scripts/player/upgrades/AttackSpeedUpgrade.gd",

}