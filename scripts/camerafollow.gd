extends Camera2D

const LOOK_AHEAD = 0.2

var facing = 0
var playerTarget : Node2D
var playerDied : bool = false
var temp : Vector2
var interface : Control
var last_position

onready var prev_camera_pos = get_camera_position()

func player_died(enemy):
	playerDied = true
	var t = Timer.new()
	t.set_wait_time(3)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	if enemy != null:
		var new_parent = get_node(enemy)
		playerTarget.remove_child(self)
		new_parent.add_child(self)
	else: 
		playerTarget.remove_child(self)
	t.queue_free()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	playerTarget = get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if !playerDied:
		temp = playerTarget.get_position()
		_check_facing()
		prev_camera_pos = get_camera_position()
	
func _check_facing():
	var new_facing = sign(get_camera_position().x - prev_camera_pos.x)
	if new_facing != 0 && facing != new_facing:
		facing = new_facing
		var target_offset = get_viewport_rect().size.x * LOOK_AHEAD * facing
	
func _on_Player_grounded_updated(isgrounded):
	drag_margin_v_enabled = !isgrounded
