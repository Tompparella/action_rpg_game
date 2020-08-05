extends Control

const FLASH_RATE = 0.05
const FLASH_N = 4

onready var update_tween = $UpdateTween
onready var pulse_tween = $PulseTween
onready var flash_tween = $FlashTween
onready var health_bar = $HealthBar
onready var under_bar = $UnderBar
onready var health_text = $HealthBar/HealthText
onready var bar_color = health_bar.get("custom_styles/fg")

export var color_1 : Color = "4cd32e"
export var color_2 : Color = "e6cd00"
export var color_3 : Color = "9d6a2c"
export var flash_color : Color =  Color.orangered
export var pulse_color : Color = Color.darkred
export var caution_zone : float = 0.5
export var danger_zone : float = 0.2

func change_health(amount):
	if amount <= 0:
		flash_damage()
	health_bar.set_value(amount)
	update_tween.interpolate_property(under_bar, "value", under_bar.value, amount, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.2)
	update_tween.start()
	health_text.set_current(amount)
	assign_color(amount)
	
func assign_color(health):
	if health <= health_bar.max_value * danger_zone:
		if !pulse_tween.is_active():
			pulse_tween.interpolate_property(bar_color, "bg_color", pulse_color, color_3, 1, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
			pulse_tween.start()
			# TODO Add sound for pulse
		bar_color.set_bg_color(color_3)
	else:
		pulse_tween.set_active(false)
		if health <= health_bar.max_value * caution_zone:
			bar_color.set_bg_color(color_2)
		else:
			bar_color.set_bg_color(color_1)
			
func flash_damage():
	var temp = under_bar.get("custom_styles/fg")
	for i in range (FLASH_N * 2):
		var color = temp.bg_color if i % 2 == 1 else flash_color
		var time = FLASH_RATE * i + FLASH_RATE
		flash_tween.interpolate_callback(temp, time, "set", "bg_color", color)
	flash_tween.start()
	
func set_max_health(amount):
	under_bar.max_value = amount
	health_bar.max_value = amount
	health_text.set_maximum(amount)
