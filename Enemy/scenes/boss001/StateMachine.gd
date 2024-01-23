extends Node

@export var starting_state: State
@export var current_state : State
@export var previous_state : State
@export var next_state : State

func _init():
	pass


func _process(delta):
	pass

func change_state(state):
	if state == current_state and previous_state:
		shuffle_state(state)
	else: 
		state = current_state

func enter_state(state):
	pass


func exit_state(current_state):
	current_state = previous_state
	enter_state(next_state)
	
func shuffle_state(state):
	
	current_state = next_state
	change_state(state)
