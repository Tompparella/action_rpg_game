extends "res://scripts/states/EnemyMotion.gd"

func enter():
	owner.get_node("AnimationPlayer").play("attack")

func _on_animation_finished(_anim_name):
	emit_signal("finished", "previous")
