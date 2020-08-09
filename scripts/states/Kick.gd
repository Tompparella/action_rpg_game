extends "res://scripts/states/Motion.gd"

export var kick_x_speed = 400
export var kick_y_multiplier = 0.4

var direction = 1

func enter():
	velocity = Vector2()
	var input_direction = get_input_direction()
	if input_direction:
		update_look_direction(input_direction)
		direction = input_direction
	owner.get_node("AnimationPlayer").play("attack_3")

func _on_animation_finished(_anim_name):
	emit_signal("finished", "idle")

func update(_delta):
	velocity.x = kick_x_speed * owner.direction
	velocity.y = Constants.GRAVITY * kick_y_multiplier
	owner.move(velocity)
