extends "res://scripts/states/Motion.gd"

var input_direction
var last_direction
export var air_steering_low : float = 2.0
export var air_steering_high : float = 3.0
var steer_counter : float
var move_speed : float = 400.0

func enter():
	steer_counter = air_steering_high
	input_direction = get_input_direction()
	if input_direction:
		update_look_direction(input_direction)
	owner.get_node("AnimationPlayer").play("fall")
	
func update(_delta):
	input_direction = get_input_direction()
	update_look_direction(input_direction)
	fall_and_move(_delta)
	if owner.isgrounded:
		velocity = Vector2()
		emit_signal("finished", "idle")
		
func fall_and_move(_delta):
	if input_direction:
		if last_direction != owner.direction:
			steer_counter = 0
			last_direction = owner.direction
		if (steer_counter + air_steering_low) <= air_steering_high:
			velocity.x = move_speed * owner.direction * ((steer_counter + air_steering_low)/air_steering_high)
			steer_counter += _delta
		else:
			velocity.x = move_speed * owner.direction
	else:
		velocity.x = 0
		steer_counter = 0
		last_direction = 0
	.update(_delta)
