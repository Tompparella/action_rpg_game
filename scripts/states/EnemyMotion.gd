extends "res://scripts/states/State.gd"
var Constants = load("res://scripts/Constants.gd")
var velocity = Vector2()
var last_direction : int
var dir_smooth : float = 1.0
var player_distance : float
var change_direction_ease : float = 2.0
var follow_range : float = 250.0
export var move_speed : float = 200.0
onready var player : KinematicBody2D = Utils.get_main_node().get_node("Player")

# Collection of inputs that handle direction and animarions

func update(_delta):
	if !owner.is_on_floor():
		velocity.y += Constants.GRAVITY * _delta
	owner.move(velocity)
	if owner.position.y >= Constants.DEATH_Y:
		owner.dead()

