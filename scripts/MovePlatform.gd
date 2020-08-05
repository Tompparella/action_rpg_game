extends Node2D

const IDLE_DUR = 0.5

export var move_to = Vector2.RIGHT * 192
export var speed = 100

var follow = Vector2.ZERO

onready var platform = $platform
onready var tween = $MoveTween

func _ready():
	_init_tween()
	
func _init_tween():
	var duration = move_to.length() / float(speed * 10)
	tween.interpolate_property(self, "follow", Vector2.ZERO, move_to, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, IDLE_DUR)
	tween.interpolate_property(self, "follow", move_to, Vector2.ZERO, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, duration + IDLE_DUR)
	tween.start()

func _physics_process(_delta):
	platform.position = platform.position.linear_interpolate(follow, 0.075)
