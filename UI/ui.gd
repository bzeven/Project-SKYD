extends Control

@onready var fuel_bar = $VBoxContainer/CenterContainer/FuelBar
@onready var life_bar = $VBoxContainer/CenterContainer/LifeBar

var current_fuel: float 
@onready var max_fuel = owner.max_fuel
@onready var current_health = owner.current_health

@onready var max_health = owner.max_health

@onready var current_frame = life_bar.get_frame()

var bar_frames = [0,1,2,3,4,5,6,7]

func _ready():
	fuel_bar.max_value = max_fuel 
	if current_health == max_health:
		life_bar.set_frame(4)
	
func _process(_delta):
	current_fuel = owner.current_fuel
	fuel_bar.set_value(current_fuel)

func life_changed(direction):
	if direction >= 1 and current_frame != 4:
		life_bar.set_frame(bar_frames[current_frame + direction])
	elif direction <= -1 and current_frame != 2:
		life_bar.set_frame(bar_frames[current_frame + direction])
	else: pass
