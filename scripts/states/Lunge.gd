extends "res://scripts/states/Motion.gd"

export var lunge_time : float = 0.3
export var lunge_cooldown : float =  2.0
export var lunge_speed : float = 800

var direction
var rec_counter : float = 0

func enter():
	rec_counter = 0
	owner.get_node("AnimationPlayer").play("lunge")
	direction = get_input_direction()
	if direction:
		update_look_direction(direction)
	
func _on_animation_finished(_anim_name):
	emit_signal("finished", "previous")
	
func update(_delta):
	rec_counter += _delta
	if rec_counter <= lunge_time:
		velocity.y = 0
		velocity.x = (owner.direction * lunge_speed)

	elif (rec_counter < lunge_cooldown):
		velocity.x = 0.3 * lunge_speed * owner.direction
		velocity.y += Constants.GRAVITY * _delta
	else:
		rec_counter = 0
		velocity = 0
		emit_signal("finished", "idle")
	owner.move(velocity)
