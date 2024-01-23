extends Node

var pause_menu = preload("res://Menus/Pause_Menu.tscn").instantiate()
var paused = false
func _ready():
	add_child(pause_menu)
	


func _input(event : InputEvent):	
		if event.is_action_pressed("Pause") and !paused:
			pause()
		elif event.is_action_pressed("Pause") and paused:
			unpause()
		else: pass


func pause():
	paused = true
	get_tree().set_pause(true)
	
	pause_menu.show()


func unpause():
	pause_menu.hide()
	get_tree().set_pause(false)
	paused = false
