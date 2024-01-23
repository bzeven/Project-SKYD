extends Camera2D

var current_value : float = 0.0
var camera_pan = self.position
var follow_speed : float = 1.0
var reset_speed : float = 2.3
var offsets = 100


func _process(_delta):
	camera_ease()

	
func camera_ease():
	if owner.facing_right == true and owner.velocity.x > 300:
		self.offset.x = move_toward(self.offset.x, offsets, follow_speed)
	elif owner.facing_right == false and owner.velocity.x < -300:
		self.offset.x = move_toward(self.offset.x, -offsets, follow_speed)
	else:
		self.offset.x = move_toward(self.offset.x, 0 , reset_speed)
