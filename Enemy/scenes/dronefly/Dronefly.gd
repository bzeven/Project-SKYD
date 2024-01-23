extends CharacterBody2D

var current_state : String
var resting : bool = false
var zipping : bool = true
var hovering : bool = false
var returning : bool = false
var chasing : bool = false
var awake : bool = false
var reset : bool = false
var value = RandomNumberGenerator.new()
var state : int

var feelers = 4

@export var xmax_speed : float = 200.0
@export var ymax_speed : float = 50.0
@export var move_rate : float = 40.0
@export var rise_rate : float = 10

@onready var chase_timer = $ChaseTimer
@onready var state_timer = $StateTimer
@onready var ground_check = $GroundCheck
@onready var f1 = $Feeler1
@onready var f2 = $Feeler2
@onready var f3 = $Feeler3
@onready var f4 = $Feeler4
@onready var move_order = [f1, f2, f3, f4]
var moves := []
 
@onready var player_check = $Sprite2D/Marker2D/PlayerCheck


@onready var starting_position = self.global_position

var direction : int = 1

func choose_direction():
		
	for i in feelers:
		moves.append(move_order.pick_random())
		print(moves)
		



#if len(move_order) == 4:
#		move_order.clear()
#


func _ready():
	choose_direction()
	
func _process(_delta):
	$Status/Label.text = current_state
	
	
func _physics_process(_delta):
	if zipping:
		zip()
#		rest()
#		hover()
#		chase()
#		back_to_start()
		
		
#func clear_state():
#	resting = false
#	zipping = false
#	hovering = false
#	returning = false
#	player_check.monitoring = true
#
#func change_state():
#	if not chasing:
#		choose_state()
#	else:
#		state_timer.start(2)
#
#func choose_state():
#	clear_state()
#	state = int(value.randi_range(1,3))
#	print(state)
#	if state == 1:
#		current_state = "rest"
#		resting = true
#	elif state == 2:
#		current_state = "zip"
#		zipping = true
#	elif state == 3:
#		current_state = "hover"
#		hovering = true

func acceleration(vel,speed,rate):
	vel = move_toward(vel, speed, rate)
	
	move_and_slide()


func zip():
	while len(moves) != 0:
		if moves[0]:
			moves.pop_front()
		else:
			pass
		#play zip animation
		
	
		
func rest():
	if resting:
		if ground_check:
	#		play rest animation
			state_timer.start(3.0)
			player_check.monitoring = false
		else: 
			acceleration(velocity.y,ymax_speed,rise_rate)
	

func hover():
	if hovering:
		state_timer.start(5.0)
	#	play hover animation
		if ground_check:
			acceleration(velocity.y,-ymax_speed,rise_rate)
			if self.position.y >= starting_position.y:
				acceleration(velocity.y,0,0)


func chase():
	if chasing:
	#	play chase animation
		current_state = "chase"
		chase_timer.start(1)
	

func back_to_start():
	if returning:
		pass
	

#func move_to():
#	for i in feelers
#		if str_to_var(move_order[0]):
#			pop
#			pass
	
#	elif str_to_var(move_order[1]):
		
	
#
#func _on_state_timer_timeout():
#	change_state()
#
#
#func _on_player_check_area_entered(area):
#	if area is Player:
#		chase()
#	else:
#		pass
#
#
#func _on_chase_timer_timeout():
#	if chasing:
#		chase_timer.start(1)
#	else:
#		change_state()
#


#func _on_active_detection_area_entered(area):
#	if area is Player:
#		awake = true
#
#func _on_active_detection_area_exited(area):
#	if area is Player:
#		awake = false
#		set_position(starting_position)

