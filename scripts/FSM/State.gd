class_name State
extends Node

#TODO Al parecer esto lo tiene el state machine, revisar si se puede quitar
@onready var node: Node = self.owner

#Config
var stateMachine: StateMachine

#-------------------------#
func enter() -> void:
	pass

func exit() -> void:
	pass