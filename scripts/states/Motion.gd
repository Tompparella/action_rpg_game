extends "res://scripts/states/State.gd"
var Constants = load("res://scripts/Constants.gd")
var velocity = Vector2()
# Collection of inputs that handle direction and animarions

func update(_delta):
	if !owner.isgrounded:
		velocity.y += Constants.GRAVITY * _delta
	owner.move(velocity)
	if owner.position.y >= Constants.DEATH_Y:
		owner.dead(null)

func get_input_direction():
	var input_direction = Vector2()
	input_direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	return input_direction
	
func update_look_direction(vector_direction):
	if vector_direction:
		var dir : int
		if vector_direction.x < 0:
			dir = -1
		else:
			dir = 1
		if owner.direction != dir:
			owner.set_look_direction(dir)
