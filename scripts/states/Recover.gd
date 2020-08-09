extends "res://scripts/states/Motion.gd"

export var recovery_time : float = 1.0
export var launch_power : float = 400.0

var rec_counter : float = 0
var temp_velocity

func enter():
	owner.get_node("AnimationPlayer").play("hit")
	
func _on_animation_finished(_anim_name):
	emit_signal("finished", "idle")

func update(_delta):
	rec_counter += _delta
	temp_velocity = launch_power
	launch_power += (0-launch_power) * _delta  # TODO Finish recovery physics
	if rec_counter >= recovery_time:
		rec_counter = 0
		temp_velocity = 0
		#emit_signal("finished", "idle")
		return
	temp_velocity = owner.direction * launch_power
	.update(_delta)
