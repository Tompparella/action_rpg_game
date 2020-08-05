extends ProgressBar

const FLASH_N : int = 4
const FLASH_RATE : float = 0.05

var flash_color : Color = Color.orangered

onready var update_tween = $UpdateTween
onready var flash_tween = $FlashTween
onready var under_bar = $UnderBar
onready var health_text = $HealthText

func change_health(amount):
	if amount <= 0:
		flash_damage()
	self.set_value(amount)
	update_tween.interpolate_property(under_bar, "value", under_bar.value, amount, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.2)
	update_tween.start()
	health_text.set_current(amount)

func set_max_health(amount):
	under_bar.max_value = amount
	self.max_value = amount
	health_text.set_maximum(amount)
	
func flash_damage():
	var temp = under_bar.get("custom_styles/fg")
	for i in range (FLASH_N * 2):
		var color = temp.bg_color if i % 2 == 1 else flash_color
		var time = FLASH_RATE * i + FLASH_RATE
		flash_tween.interpolate_callback(temp, time, "set", "bg_color", color)
	flash_tween.start()
