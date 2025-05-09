class_name StateMachine
extends Node

#Nodes
@onready var ownerNode: Node = self.owner

#Export
@export var defaultState: State

#Internal
var currentState: State = null

#-------------------------#

func _ready():
	call_deferred("deferredReady")

#TODO Crear un match functions o algo para no repetir el codigo qlero
func _process(delta: float) -> void:
	if not currentState: 
		return
	if not currentState.has_method("on_process"):
		return

	currentState.on_process(delta)

func _physics_process(delta: float) -> void:

	if not currentState: 
		return
	if not currentState.has_method("on_physics_process"):
		return

	currentState.on_physics_process(delta)

func _input(event: InputEvent):
	if not currentState: 
		return
	if not currentState.has_method("on_input"):
		return
	currentState.on_input(event)

func _unhandled_input(event: InputEvent) -> void:
	if not currentState: 
		return
	if not currentState.has_method("on_unhandled_input"):
		return
	currentState.on_unhandled_input(event)

func _unhandled_key_input(event: InputEvent) -> void:
	if not currentState: 
		return
	if not currentState.has_method("on_unhandled_key_input"):
		return
	currentState.on_unhandled_key_input(event)

#-------------------------#

func deferredReady() -> void:
	currentState = defaultState
	initializeState()

func initializeState() -> void:
	currentState.node = ownerNode
	currentState.stateMachine = self
	currentState.enter()

	print("State Machine initialized with owner: ", ownerNode.name)
	print("Start state: ", currentState.name)

func enterState(state: Enums.PlayerStates) -> void:
	triggerExitState()
	
	#TODO Revisar si hay algo mejor para esto
	var key = Enums.PlayerStates.find_key(state)
	currentState = get_node(key)
	initializeState()

func triggerExitState() -> void:
	if not currentState:
		return

	if not currentState.has_method("exit"):
		return

	currentState.exit()
