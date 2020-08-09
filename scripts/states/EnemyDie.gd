extends "res://scripts/states/Motion.gd"
signal disable_state_machine

func enter():
	emit_signal("disable_state_machine", false)
	owner.get_node("AnimationPlayer").play("die")
