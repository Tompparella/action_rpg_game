extends "res://scripts/StateMachine.gd"

func _ready():
	states_map = {
		"walk": $Walk,
		"jump": $Jump,
		"attack": $Attack,
		"recover": $Recover,
		"dead": $Die,
		"follow": $Follow
	}
	
#func _on_player_death():
#	_change_state("dead")
	
func _change_state(state_name):
	if !_active:
		return
	if state_name in ["jump" , "attack", "recover", "die"]:
		states_stack.push_front(states_map[state_name])
	._change_state(state_name)
		
## Check input that can interrupt states
#func _unhandled_input(event):
#	if event.is_action_pressed("attack") && (current_state != $Attack):
#		if current_state in [$Recover, $Kick, $Lunge]:
#			return
#		_change_state("attack")
#	elif event.is_action_pressed("special") && (current_state != $Lunge):
#		if current_state in [$Recover, $Kick, $Attack]:
#			return
#		_change_state("lunge")
#	current_state.handle_input(event)


func _on_Enemy_attack():
	_change_state("attack")
