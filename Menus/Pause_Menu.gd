extends CanvasLayer

@onready var main = $Control/MainMenu
@onready var options = $Control/OptionsMenu


func _ready():
	hide()

func _on_resume_pressed():
	Pause.unpause()


func _on_options_button_pressed():
	main.set_visible(false)
	options.set_visible(true)

func _on_quit_pressed():
	get_tree().quit()


func _on_back_pressed():
	options.set_visible(false)
	main.set_visible(true)


func _on_debug_mode_toggled(_button_pressed):
	GameSettings.debug_enabled = !GameSettings.debug_enabled
	if GameSettings.debug_enabled:
		print("Debug mode toggled on")
		var DEBUG = load("res://Debug/Debug_scene.tscn").instantiate()
#		get_tree().get_node(Sky).add_child(DEBUG)
		
	else: 
		print("Debug mode toggled off")
		
func _on_volume_slider_value_changed(_value):
	pass # Replace with function body.



