extends KinematicBody2D

var Constants = load("res://scripts/Constants.gd")

var velocity : Vector2 = Vector2()
var direction : int = 1
var prev_direction : int = direction
var change_direction_ease : float = 2.0
var dir_smooth : float = 1.0
var is_dead = false
var launch : float
var rec_counter : float
var is_following = false
var has_attacked : bool = false
var player_distance : float
var player_in_attack_range : bool = false
var is_recovering : bool = false
var player_dead : bool = false

export var jumpforce : int = 550
export var speed: int = 200
export var meleedamage = 1
export var launch_power : float = 200
export var stun_time : float = 1.0
export var follow_range : float = 250

onready var current_health = $Health.max_amount
onready var floor_check = $floor_check
onready var detect : RayCast2D = $detect_right
onready var attackBox : CollisionShape2D = $Flipper/AttackArea/attackBox
onready var player : KinematicBody2D = Utils.get_main_node().get_node("Player")
onready var animation_player : AnimationPlayer = $Flipper/sprite/AnimationPlayer
onready var health = $Health
onready var healthText = $HealthBar/HealthText
onready var path = self.get_path()

func _ready():
	health.initialize()
	healthText.initialize(current_health,current_health)
	
	
func _attack():
	if player_in_attack_range:
		player.hit(meleedamage, direction, path)
		is_recovering = true
	
func jump():
	if floor_check.is_colliding():
		velocity.y = -jumpforce
	

func dead():
	is_dead = true
	$CollisionShape2D.disabled = true
	detect.enabled = false
	floor_check.enabled = false
	animation_player.play("dead")
	
func hit(damage, attack_direction):
	player._on_hit_success()
	is_recovering = true
	current_health-=damage
	health.set_current(current_health)
	healthText.set_current(current_health)
	velocity.y = -launch_power
	launch = launch_power * attack_direction
	rec_counter = 0
	if current_health <= 0:
		dead()
		
func recover(delta):
	rec_counter += delta
	velocity.x = launch
	launch += (0-launch) * delta
	if rec_counter >= stun_time:
		launch = 0
		rec_counter = 0
		velocity.x = 0
		is_recovering = false

func _physics_process(delta):
	if !is_recovering:
		if position.y >= Constants.DEATH_Y:
			dead()
		player_distance = player.get_position().x - get_position().x
		dir_smooth += (direction - dir_smooth) * delta * change_direction_ease
		velocity.x = 1 * dir_smooth
		
		# Flip the asset if direction changes
		if velocity.x > 0.01:
			if $Flipper.get_scale().x == -1:
				$Flipper.set_scale(Vector2(1,1))

		elif velocity.x < -0.01:
			if $Flipper.get_scale().x == 1:
				$Flipper.set_scale(Vector2(-1,1))

		if !animation_player.is_playing():
			animation_player.play("walk")
				
		# Check if the player is in range & not dead
		if abs(player_distance) < follow_range && !player_dead:
			is_following = true
		else:
			is_following = false
			
		# Determining player direction
		if is_following:
			if player_distance < -100:
				direction = -1
			elif player_distance > 100:
				direction = 1
			if (player_distance > -200 && player_distance < 200):
				if is_on_floor():
					if player.position.y < position.y || floor_check.get_collider() == player:
						jump()

		# Checking if player is within reach
		if detect.is_colliding():
			var collision_object : Object = detect.get_collider()
			if !collision_object.is_in_group(Constants.PLAYER_GROUP) || player_dead:
				if !is_following:
					direction *= -1
				else:
					if !collision_object.is_in_group(Constants.ENEMY_GROUP) && floor_check.is_colliding():
						jump()
						
		# Making the enemy turn around when near a ledge
		if !is_following:
			if !floor_check.is_colliding():
				direction *= -1
				
		velocity.x *= speed
				
	# If recovering
	else:
		recover(delta)
			
	if prev_direction != direction:
		floor_check.position.x *= -1
		detect.scale *= -1
		prev_direction = direction
	
	# Gravity
	velocity.y += Constants.GRAVITY * delta
	var snap = Vector2.DOWN * Constants.FLOOR_DETECT_DIST if velocity.y == 0.0 else Vector2.ZERO
	velocity = move_and_slide_with_snap(
	velocity, snap, Constants.FLOOR_NORMAL, floor_check.is_colliding(), Constants.MAX_SLIDE, Constants.FLOOR_MAX_ANGLE, false
	)

# Signal functions
func _on_AttackArea_body_entered(body):
	if !is_recovering:
		if body.is_in_group(Constants.PLAYER_GROUP):
			player_in_attack_range = true
			if animation_player.get_current_animation() != "attack":
				animation_player.play("attack")


func _on_AttackArea_body_exited(body):
	if body.is_in_group(Constants.PLAYER_GROUP):
		player_in_attack_range = false
		
func _hide():
	queue_free()
	
