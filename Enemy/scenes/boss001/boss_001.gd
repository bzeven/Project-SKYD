extends CharacterBody2D

var idle_motion = PI
var move_speed = 300.0
var pursuit_speed = 400.0

var charged = false 



var rdm = randi_range(0,1) 
@onready var direction = rdm

@onready var animations = $AnimationPlayer
@onready var state_machine = $state_machine

func _ready():
	# Initialize the state machine, passing a reference of the player to the states,
	# that way they can move and react accordingly
#	state_machine.init(self)
	pass

func _physics_process(delta):
#	state_machine.process_physics(delta)
	pass
func _process(delta):
#	state_machine.process_frame(delta)
	pass

func idle(delta):
	velocity.x += idle_motion * move_speed * delta


func move(delta):
	$MoveTimer.start(2.5)
	if direction == 0:
		velocity.x = move_toward(velocity.x,move_speed, 100)
	else: velocity.x = move_toward(velocity.x,-move_speed, 100) 






func _on_move_timer_timeout():
	rdm.randomize()
	
	
	
	
	
	
func _on_detection_body_entered(body):
	pass
	
#	if !current_state == str(states.Pursue):
#		next_state = str(states.Pursue)
#	if current_state == str(states.Pursue) and !charged:
#		next_state = str(states.Charge)
		
	
