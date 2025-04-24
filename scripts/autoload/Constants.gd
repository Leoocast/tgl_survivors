# Constants
extends Node

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
		"FIRE_BAll": "res://scenes/projectiles/fireBall.tscn"
	}
}

const ANIMATIONS = {
    "IDLE" : "idle",
    "RUN" : "run",
    "ATTACK" : "attack",
	"TAKE_DAMAGE": "take_damage",
	"DEATH": "death"
}