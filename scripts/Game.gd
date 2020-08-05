extends Node2D

func _ready():
	var player_health = $Player/Health
	var health_view = $UILayer/Interface/HealthView
	
	player_health.connect("changed", health_view, "change_health")
	player_health.connect("max_changed", health_view, "set_max_health")
	player_health.initialize()
