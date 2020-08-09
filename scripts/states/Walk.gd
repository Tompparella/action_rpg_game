extends "res://scripts/states/OnGround.gd"

var move_speed : float = 400.0

func enter():
	var input_direction = get_input_direction()
	update_look_direction(input_direction)
	owner.get_node("AnimationPlayer").play("walk")
	
func handle_input(event):
	return .handle_input(event)
	
func update(_delta):
	var input_direction = get_input_direction()
	if !input_direction:
		emit_signal("finished", "idle")
	update_look_direction(input_direction)
	speed = move_speed
	var _collision_info = move(_delta)
	
func move(delta):
	velocity.x = owner.direction * move_speed
	.update(delta)
