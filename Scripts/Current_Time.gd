extends Node

var clock : int 



func _ready():
	pass

func _process(delta):
	clock = 1 * delta
	if clock == 60:
		print("time")
