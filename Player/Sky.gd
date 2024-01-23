extends CharacterBody2D
class_name Player


func notes():
	pass
	# I am an absolute waste of space and don't know what the fuck I am doing
	# If there is a higher power it really wasted its time creating me
	# I will never amount to anything. I will die unrenowned unfullfilled and unwanted
	# STOP RATE!!!!!!!!!!!!!!!!!!!!!
	# ADD ON LANDING BOOL
	
	
	
# passive bools
var is_falling : bool = false
var facing_right : bool
var has_fuel : bool = true
var attacking : bool = false
# active bools
var moving = false
var sprinting = false
var slid = false
var is_gliding : bool
var dash_cd := false
var adash_cd := false
var slide_cd := false
var jump_buffer = false

# unlock bools
var djump_unlocked: bool = true
var glide_unlocked: bool = true
var dash_unlocked: bool = true
var adash_unlocked: bool = true
var fuel_gain = true
var overcharged_unlocked = false

# movement values
var jump_count : int = 0
var glide_counter: int = 0
var fast_falling := 25.5


var stop_multi = [1.25, 1.0, 0.75, 0.50, 0.25]
var dash_cost := [0, 5, 10, 25, 50, 70]
var d_upgrade : int = 3
var ad_upgrade : int = 5

# const move values
const glide_speed : int = 100
const default_move_speed : float = 5.5
const default_stop_rate : float = 100.0
const default_max_speed : float = 500.0
const max_jump_force : int = -425
const double_jump_force : int = -305
const dash_cooldown := 1.8
const slide_cooldown:= 0.8
const adash_cooldown:= 0.6
const coyotebuffer:= 0.2

const FPS : float = 2.0
#particles
const poof = preload("res://Player/particles/poof.tscn")
const dust = preload("res://Player/particles/dust.tscn")
#


var default_fall_speed : float = 20.0
var current_land_speed = velocity.x
var last_direction

#technical stat
@export var sprint_multiplier : float = 1.31
@export var move_speed : float = 5.5
@export var max_speed : float  = 500.0
@export var stop_rate : float = 100.0
@export var fall_limiter: float = 500.0
@export var fall_speed : float = 20.0
@export var jumps_available : int = 2
@export var dash_distance : float = 850.00
@export var adash_distance : float = 700.00
@export var teleoprt_distance : int = 150

#resource
@export var max_health : int = 5
@export var current_health : int = 5
@export var max_fuel : float = 100.0
@export var current_fuel : float = 100.0

#UI
@onready var ui = $CanvasLayer/UI
#@onready var debug_scene = $CanvasLayer/Debug

#character controllers
@onready var animation_tree = $AnimationTree
@onready var animation_player = $AnimationPlayer
@onready var m_center = $center
@onready var m_side = $side
@onready var ground = $GroundCheck
@onready var sprite = $Sprite2D



func _ready():
	max_speed = default_max_speed

func _process(_delta):
	health_check()
	fuel_check()

func _physics_process(delta):
	current_gravity()
	player_input_event(delta)
	update_animations()
	Kinetic_fuel(delta)
	coyotetime()
#########################################################################
func player_input_event(delta):
	move(delta)
	dash()
	slide()
	teleport()
	jump()
	double_jump()
	glide()
	fast_fall()
	
#########################################################################
func update_animations():
	var grounded : bool = is_on_floor()
	var falling : bool = !grounded
	var idle : bool = velocity == Vector2.ZERO
	var walking : bool = velocity < Vector2(200,0) or velocity > Vector2(-200,0)
	var running : bool = velocity > Vector2(200,0) or velocity < Vector2(-200,0)
	var sliding : bool = Input.is_action_just_released("Action")
	animation_tree["parameters/conditions/idle"] =  idle
	animation_tree["parameters/conditions/walking"] = !idle and walking
	animation_tree["parameters/conditions/running"] = !idle and running
	animation_tree["parameters/conditions/dashing"] = Input.is_action_just_pressed("Sprint")
	animation_tree["parameters/conditions/jumping"] = !falling and Input.is_action_just_pressed("Jump")
	animation_tree["parameters/conditions/slide"] = Input.is_action_just_pressed("Action")
	animation_tree["parameters/conditions/sliding"] = sliding; if Input.is_action_just_released("Action"): !sliding
	
	animation_tree["parameters/conditions/falling"] =  !idle or !walking or !running and falling
	animation_tree["parameters/conditions/dbljumping"] = falling and jump_count !=0 and Input.is_action_just_pressed("Jump")
	animation_tree["parameters/conditions/airdashing"] = falling and current_fuel >= dash_cost[ad_upgrade] and Input.is_action_just_pressed("Sprint")

func current_gravity():
	velocity.y = move_toward(velocity.y, fall_limiter, fall_speed)
func current_acceleration(direction,boost):
	velocity.x = move_toward(velocity.x, max_speed * direction, move_speed * boost)

#########################################################################
func move(_delta):
	if is_on_floor():
		is_falling = false
	else:
		is_falling = true
	if is_on_floor() and moving:
		particles()


	var input_direction = Vector2.ZERO
	var previous_direction = input_direction.x*-1
	input_direction.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	input_direction = input_direction.normalized()
	if slid:
		input_direction = 0
	
	
	
	if input_direction.x != 0:
		moving = true
		current_acceleration(input_direction.x,1)
		if input_direction.x <= -0.01:
			if velocity.x > -300:
				current_acceleration(-1,10)
		elif input_direction.x >= 0.01:
			if velocity.x < 300:
				current_acceleration(1,10)
	
		if velocity.x > 0:
			facing_right = true
		else:
			facing_right = false
	
	else:
		moving = false
		velocity.x = move_toward(velocity.x,0.0,stop_rate / 2)

#	if input_direction.x !=0:
#		moving = true
#		current_acceleration(input_direction.x,1)
		
	
			
	move_and_slide()
	facing()
	

func dash():
	if Input.is_action_just_pressed("Sprint")  and !dash_cd and current_fuel >= dash_cost[d_upgrade]:
		dash_cd = true
		$DashTimer.start(dash_cooldown)
		fuel_gain = false
		if facing_right:
			velocity.x = move_toward(velocity.x, dash_distance, dash_distance)
			current_fuel -= dash_cost[d_upgrade]
		if !facing_right:
			velocity.x = move_toward(velocity.x, -dash_distance, dash_distance)
			current_fuel -= dash_cost[d_upgrade]
func airdash():
	if Input.is_action_just_pressed("Sprint")  and !adash_cd and current_fuel >= dash_cost[ad_upgrade]:
		dash_cd = true
		$DashTimer.start(dash_cooldown)
		fuel_gain = false
		if facing_right:
			velocity.x = move_toward(velocity.x, adash_distance, adash_distance)
			current_fuel -= dash_cost[d_upgrade]
		if !facing_right:
			velocity.x = move_toward(velocity.x, -adash_distance, adash_distance)
			current_fuel -= dash_cost[d_upgrade]

func slide():
	if Input.is_action_just_pressed("Action") and is_on_floor() and !slide_cd:
		slide_cd = true
		$SlideTimer.start(slide_cooldown)
		var starting_pos = self.global_position
		if facing_right and velocity.x >= 300:
			velocity.x = move_toward(velocity.x, dash_distance * 0.8, dash_distance)
			if position.x >= starting_pos.x + dash_distance:
				velocity.x = 0
		elif !facing_right and velocity.x <= -300:
			velocity.x = move_toward(velocity.x, -dash_distance * 0.8, dash_distance)
			if position.x <= starting_pos.x - dash_distance:
				velocity.x = 0
	else: pass
#		velocity.x = move_toward(velocity.x, 0, stop_rate)
		
func teleport():
	if Input.is_action_just_pressed("Action") and !is_on_floor():
		if current_fuel > dash_cost[ad_upgrade]:
			if facing_right:
				velocity.y = 0
				self.position.x = self.position.x + teleoprt_distance
				current_fuel -= dash_cost[ad_upgrade]
			else:
				velocity.y = 0
				self.position.x = self.position.x - teleoprt_distance
				current_fuel -= dash_cost[ad_upgrade]
		else:
			print("Not enough fuel!")
#########################################################################

func coyotetime():
	if !is_on_floor() and !jump_buffer:
		$CoyoteTimer.start(coyotebuffer)
		jump_buffer = true
func jump():
	if Input.is_action_just_pressed("Jump") and !attacking:
		if is_on_floor() or !is_on_floor() and !jump_buffer:
			jump_count = jumps_available
			glide_counter = 1
			velocity.y = max_jump_force
			jump_count -= 1
			
	elif Input.is_action_just_released("Jump"):
		is_falling = true
		jump_stop()
		
func jump_stop():
	velocity.y = max(-20, velocity.y)
	
func double_jump():
	if jump_count > 0 and Input.is_action_just_pressed("Jump") and !is_on_floor():
		velocity.y = double_jump_force
		jump_count -= 1
		is_falling = true
		
func glide():
	if glide_unlocked == true and !is_on_floor():
		if jump_count == 0 and glide_counter > 0  and Input.is_action_pressed("Jump") and velocity.y >= 0:
			is_gliding = true
#			is_falling = false
			fall_limiter = glide_speed
			glide_counter -= 1

		elif is_gliding and not Input.is_action_pressed("Jump"):
			fall_limiter = 500
			is_falling = true
func fast_fall():
	if Input.is_action_pressed("Down") and !is_on_floor(): #and velocity.y >= -100:
		fall_speed = fast_falling
	else:
		fall_speed = default_fall_speed
#########################################################################
func facing():
	if facing_right:
		$Sprite2D.flip_h = false
	elif !facing_right:
		$Sprite2D.flip_h = true

#########################################################################
func health_change(health):
	current_health += health
	$CanvasLayer/UI.life_changed(health)

func die():
	get_tree().reload_current_scene()
func health_check():
	if current_health > max_health:
		current_health = max_health
	if current_health <= 1:
		pass
	if current_health <= 0:
		die()
########################################################################
func fuel_check():
	if current_fuel < 0:
		current_fuel = 0
		if current_fuel == 0:
			has_fuel = false
	if current_fuel > max_fuel and !overcharged_unlocked:
		current_fuel = max_fuel
	if current_fuel > 0 and overcharged_unlocked:
		current_fuel +=1000
########################################################################

func fuel_gained():
	pass
func Kinetic_fuel(delta):
	if moving and !dash_cd and is_on_floor():
		current_fuel+= FPS * delta


func particles():
	var ground_particle = dust.instantiate()
	get_parent().add_child(ground_particle)
	ground_particle.position = m_side.global_position

func l_particles():
#	if is_on_floor() and ground.is_colliding() == true:#
	var landing_particle = poof.instantiate()
	get_parent().add_child(landing_particle)
	landing_particle.position = m_center.global_position
	ground.enabled = false


func _on_dash_timer_timeout():
	dash_cd = false
	


func _on_coyote_timer_timeout():
	jump_buffer = false


func _on_slide_timer_timeout():
	slide_cd = false
