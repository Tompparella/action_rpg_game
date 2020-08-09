extends "res://scripts/states/EnemyMotion.gd"

export var base_jump_force : int = 525
	
func enter():
	velocity = Vector2()
	velocity.y -= base_jump_force
	
func update(_delta):
	jump_and_move(_delta)
	if owner.is_on_floor():
		emit_signal("finished", "previous")
		
func jump_and_move(delta):
	velocity.x = move_speed * owner.direction
	.update(delta)
