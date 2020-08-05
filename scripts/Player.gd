extends KinematicBody2D

var Constants = load("res://scripts/Constants.gd")
signal grounded_updated(isgrounded)
signal playerDied

export var damage : int = 1
export var jumpforce : int = 525
export var speed: int = 350
export var launch_power : float = 600
export var recovery_time : float = 1.0
export var meleedamage = 1
export var stun_time = 1.0
export var lunge_time : float = 0.3
export var lunge_timer : float = 1.5
export var combo_timer : float = 0.7

var combo_counter : float = 0
var is_recovering : bool = false
var velocity : Vector2 = Vector2()
var sprite : Sprite
var direction = 1
var launch : float = 1.0
var enemies_in_range = {}
var rec_counter : float = 0
var horizontal_movement : float
var is_lunging : bool = false
var is_dead : bool = false
var combo_on : bool = false
var combo_state : int = 0
var is_kicking : bool = false
var is_attack_1 : bool = false
var is_attack_2 : bool = false

onready var health = $Health.max_amount
onready var current_health = health
onready var flipper : Node2D = $Flipper
onready var attack = $Flipper/Hit/damageBox
onready var animation = $Flipper/AnimationPlayer

# Camera controls
var isgrounded
var isjumping = false

# Lunge
func lunge(delta):
	is_lunging = true
	rec_counter += delta
	if rec_counter <= lunge_time:
		velocity.y = 0
		velocity.x = (horizontal_movement * speed * 3)
	elif (rec_counter < lunge_timer):
		velocity.x *= 0.5
	else:
		rec_counter = 0
		velocity.x = 0
		is_lunging = false
		
func jump():
	animation.stop()
	animation.play("jump")
	velocity.y -= jumpforce
	

func hit(hit_damage, hit_direction, enemy_path):
	if is_kicking:
		attack.rotate(-35)
	change_health(current_health - hit_damage)
	velocity.y = -launch_power
	launch = launch_power * hit_direction
	rec_counter = 0
	is_recovering = true
	animation.stop()
	animation.play("hit")
	attack.set_scale(Vector2(1,5))
	if current_health <= 0:
		dead(enemy_path)
		
func recover(delta):
	rec_counter += delta
	velocity.x = launch
	launch += (0-launch) * delta
	if rec_counter >= stun_time:
		rec_counter = 0
		velocity.x = 0
		is_recovering = false
		
# Enables combos when player hits an enemy and enlarges hitbox accordingly
func combo(delta):
	combo_on = true
	combo_counter += delta
	if combo_counter >= combo_timer:
		attack.set_scale(Vector2(1,5))
		combo_on = false
		combo_state = 0
		combo_counter = 0
		
func choose_animation():
	var anim = animation.get_current_animation()
	if !is_dead && (!animation.is_playing() || ["fall", "walk", "idle"].has(anim)):
		if velocity.y > 0 && !isgrounded:
			animation.play("fall")
		elif velocity.x != 0 && anim != "walk":
			animation.stop()
			animation.play("walk")
		elif velocity.length() == 0:
			animation.play("idle")
			
func change_health(amount):
	current_health = amount
	$Health.set_current(amount)
		
func dead(enemy_path):
	if !is_dead:
		emit_signal("playerDied", enemy_path)
		for enemy in get_tree().get_nodes_in_group("Enemy"):
			enemy.player_dead = true
	change_health(0)
	is_dead = true
	animation.stop()
	animation.play("die")

func _physics_process(delta):
	
	if !is_recovering && !is_dead:
	
		if position.y >= Constants.DEATH_Y:
			dead(null)
		# Player movement
		horizontal_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
			
		velocity.x = horizontal_movement * speed
		# Adding physics if player is attacking
		if is_kicking:
			velocity.x += speed * direction * 2
		elif is_attack_1:
			velocity.x += speed * direction
			
		# Player direction
		if horizontal_movement < -0.5:
			direction = -1
		elif horizontal_movement > 0.5:
			direction = 1
			
		flipper.set_scale(Vector2(direction,1))
	
		if combo_on:
			combo(delta)
	
		# Attack & Combo
		if Input.is_action_just_pressed("attack"):
			var anim = animation.get_current_animation()
			if combo_on:
				if anim == "attack_1":
					combo_state = 1
					animation.stop()
					animation.play("attack_2")
				elif anim == "attack_2":
					combo_state = 2
					animation.stop()
					animation.play("attack_3")
			elif !is_on_floor():
				animation.play("attack_3")
			elif !["attack_1", "attack_2", "attack_3"].has(anim):
				animation.stop()
				animation.play("attack_1")
				
		# Lunge
		if Input.is_action_just_pressed("special") && (velocity.x != 0) && !is_lunging:
			animation.stop()
			animation.play("lunge")
			lunge(delta)
			
		if is_lunging:
			lunge(delta)
		
		# Checking whether if player is jumping
		if isjumping && velocity.y >= 0:
			isjumping = false
		
		# Checking camera position
		var wasgrounded = isgrounded
		isgrounded = is_on_floor()
			
		if wasgrounded == null || isgrounded != wasgrounded:
			emit_signal("grounded_updated", isgrounded)
			
		# Jump
		if Input.is_action_just_pressed("jump") && isgrounded:
			jump()
	else:
		recover(delta)
	
	# Gravity
	velocity.y += Constants.GRAVITY * delta
	if is_attack_2:
		velocity.y -= 100
	
	# Applying velocity
	var snap = Vector2.DOWN * Constants.FLOOR_DETECT_DIST if !isjumping else Vector2.ZERO
	velocity = move_and_slide_with_snap(
	velocity, snap, Constants.FLOOR_NORMAL, !isgrounded, Constants.MAX_SLIDE, Constants.FLOOR_MAX_ANGLE, false
	)
	
	#Continuous animations
	choose_animation()

# Signal functions
func _on_hit_success():
	attack.set_scale(Vector2(1,15))
	combo_on = true

func _enter_attack_1():
	is_attack_1 = true
	
func _exit_attack_1():
	is_attack_1 = false
	
func _enter_attack_2():
	is_attack_2 = true
	
func _exit_attack_2():
	_attack()
	is_attack_2 = false

func _enter_jump_kick():
	velocity.y += speed * 1.2
	is_kicking = true
	attack.set_scale(Vector2(1.5,5))
	attack.rotate(35)
	_attack()
	
func _exit_jump_kick():
	is_kicking = false
	attack.set_scale(Vector2(1,5))
	attack.rotate(-35)
	

func _attack():
	for key in enemies_in_range:
		enemies_in_range[key].hit(damage, direction)
		
func _on_Hit_body_entered(body):
	if body.is_in_group("Enemy"):
		enemies_in_range[body.name] = body
		
func _on_Hit_body_exited(body):
	if body.is_in_group("Enemy"):
		enemies_in_range.erase(body.name)

func _on_AnimationPlayer_animation_started(_anim_name):
	is_kicking = false
	attack.set_scale(Vector2(1,5))
	combo_on = false
	combo_state = 0
	is_attack_1 = false
	is_attack_2 = false
