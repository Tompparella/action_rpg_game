extends Node
# Base for all state machine states.

signal finished(next_state_name)

# Initialize state
func enter():
	pass
	
# Exit and clean the state when finished.
func exit():
	pass
	
func handle_input(_event):
	pass
	
func update(_delta):
	pass

func _on_animation_finished(_anim_name):
	pass
