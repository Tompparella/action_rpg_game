extends "res://scripts/states/Motion.gd"

var attack_counter : int
var combo : bool = false
var combo_counter : float
var has_air_attacked : bool = false
export var combo_time : float = 0.2
export var attack_momentum : float = 100

func enter():
	if !has_air_attacked:
		if Input.is_action_pressed("down"):
			emit_signal("finished", "kick")
			return
		combo = false
		owner.get_node("AnimationPlayer").play("attack_1")
		attack_counter = 0
		combo_counter = 0
		velocity.x = attack_momentum * owner.direction
		if !owner.isgrounded:
			has_air_attacked = true
	else:
		emit_signal("finished", "fall")

func handle_input(_event):
	if _event.is_action_pressed("attack") && combo:
		match attack_counter:
			0:
				velocity.y -= 250
				velocity.x = attack_momentum * 0.5
				owner.get_node("AnimationPlayer").play("attack_2")
				combo = false
				attack_counter += 1
			1:
				emit_signal("finished", "kick")
				return
			_:
				_on_animation_finished(null)

func update(_delta):
	combo_counter += _delta
	if combo_counter >= combo_time:
		combo = true
		combo_counter = 0
	velocity.x -= attack_momentum * _delta
	velocity.y += Constants.GRAVITY * _delta * 0.2
	owner.move_and_slide(velocity)
	#.update(_delta)

func _on_animation_finished(_anim_name):
	emit_signal("finished", "previous")

func exit():
	velocity.y = 0
	attack_counter = 0
	combo_counter = 0
	combo = false
	
func _reset_attack():
	has_air_attacked = false

#func _on_succesful_hit():
#	combo = true

