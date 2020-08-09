extends "res://scripts/states/Motion.gd"

export var base_jump_force : int = 525
export var air_steering_low : float = 2.0
export var air_steering_high : float = 3.0

var has_jumped : bool = false
var steer_counter : float
var last_direction : int
var horizontal_speed : float = 0.0

func initialize(speed):
	horizontal_speed = speed
	
func enter():
	if !has_jumped:
		has_jumped = true
		velocity = Vector2()
		var input_direction = get_input_direction()
		update_look_direction(input_direction)
		last_direction = owner.direction
		owner.get_node("AnimationPlayer").play("jump")
		velocity.y -= base_jump_force
		steer_counter = air_steering_high
	else:
		emit_signal("finished", "previous")
	
func update(_delta):
	var input_direction = get_input_direction()
	update_look_direction(input_direction)
	jump_and_move(_delta, input_direction)
	if owner.isgrounded:
		emit_signal("finished", "previous")
		
func jump_and_move(delta, direction):
	if direction:
		if last_direction != owner.direction:
			steer_counter = 0
			last_direction = owner.direction
		if (steer_counter + air_steering_low) <= air_steering_high:
			velocity.x =  horizontal_speed * owner.direction * ((steer_counter + air_steering_low)/air_steering_high)
			steer_counter += delta
		else:
			velocity.x = horizontal_speed * owner.direction
	else:
		velocity.x = 0
		steer_counter = 0
		last_direction = 0
	.update(delta)
	
func _reset_jump():
	has_jumped = false
	
func on_animation_finished(_anim_name):
	print("jaa")
	owner.get_node("AnimationPlayer").play("fall")
