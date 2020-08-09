extends "res://scripts/states/EnemyMotion.gd"

func enter():
	velocity = Vector2()
	owner.get_node("AnimationPlayer").play("walk")
	
func update(_delta):
	player_distance = player.get_position().x - owner.get_position().x
	if (abs(player_distance) < follow_range) && !owner.player_dead:
		emit_signal("finished", "follow")
		return
	if owner.detect.is_colliding():
			var collision_object : Object = owner.detect.get_collider()
			if !collision_object.is_in_group(Constants.PLAYER_GROUP) || owner.player_dead:
				owner.direction *= -1
	if !owner.floor_check.is_colliding():
		owner.direction *= -1
	dir_smooth += (owner.direction - dir_smooth) * _delta * change_direction_ease
	velocity.x = dir_smooth * move_speed
	.update(_delta)

