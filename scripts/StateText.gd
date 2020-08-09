extends Label

var start_position = Vector2()

#func _ready():
#	start_position = rect_position
#
#func _physics_process(delta):
#	rect_position = get_parent().position + start_position
	


func _on_StateMachine_state_change(current_state):
	text = current_state.get_name()
