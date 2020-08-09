extends "res://scripts/states/EnemyMotion.gd"

func enter():
	player_distance = player.get_position().x - owner.get_position().x
	if player_distance < 0:
		owner.direction = -1
	elif player_distance > 0:
		owner.direction = 1
	owner.get_node("AnimationPlayer").play("walk")
	
func update(_delta):
	player_distance = player.get_position().x - owner.get_position().x
	if abs(player_distance) >= follow_range:
		emit_signal("finished", "walk")
		return
	if owner.detect.is_colliding():
		var collision_object : Object = owner.detect.get_collider()
		if !collision_object.is_in_group(Constants.PLAYER_GROUP) || owner.player_dead:
			emit_signal("finished", "jump")
			return
	if player_distance < -100:
		owner.direction = -1
	elif player_distance > 100:
		owner.direction = 1
	if (player_distance > -200 && player_distance < 200):
		if owner.is_on_floor():
			if player.position.y < owner.position.y || owner.floor_check.get_collider() == player:
				emit_signal("finished", "jump")
				return
	dir_smooth += (owner.direction - dir_smooth) * _delta * change_direction_ease
	velocity.x = dir_smooth * move_speed
	.update(_delta)
	
