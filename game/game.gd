extends Node3D

@onready var ControlNode:Control = %Control
@onready var TotalPoints:Label = %TotalPoints
var pointLabel: PackedScene = preload("res://point-label/point-label.tscn")


# clients
var instance1: Node3D
var instance2: Node3D
var instance3: Node3D

var spot1_status: bool = false
var spot2_status: bool = false
var spot3_status: bool = false

@onready var spot_1: Marker3D = $ClientSpawn/Spot1
@onready var spot_2: Marker3D = $ClientSpawn/Spot2
@onready var spot_3: Marker3D = $ClientSpawn/Spot3

@onready var wait_time_1: Timer = $ClientSpawn/Spot1/WaitTime1
@onready var wait_time_2: Timer = $ClientSpawn/Spot2/WaitTime2
@onready var wait_time_3: Timer = $ClientSpawn/Spot3/WaitTime3

var client1: PackedScene = preload("res://clients/client_1.tscn")
var client2: PackedScene = preload("res://clients/client_2.tscn")
var client3: PackedScene = preload("res://clients/client_3.tscn")


var points: int = 0:
	set(value):
		var new_points:int = value - points
		spawn_point_label(new_points)
		points = value
		TotalPoints.text = str(points)
	get:
		return points

func _ready() -> void :
	TotalPoints.text = "0"
	# TODO: main game loop
	# spawn clients
	
		
		
		
	# add timers on clients
	# when timers go off -> minus points -> queue free client

func _input(event:InputEvent)->void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		points+=100

func spawn_point_label(new_points: int)->void:
	var text: String = ""
	if new_points < 0:
		text += "-"
	else:
		text += "+"

	text += str(new_points)

	var popup:Label = pointLabel.instantiate()
	popup.text = text

	var min_x:float = get_viewport().size.x * 0.2
	var max_x:float = get_viewport().size.x * 0.8
	var min_y:float = get_viewport().size.y * 0.2
	var max_y:float = get_viewport().size.y * 0.8

	# random position within viewport
	var random_pos:Vector2 = Vector2(
		randf_range(min_x, max_x),
		randf_range(min_y, max_y)
	)

	# Center the label in the viewport
	popup.position = random_pos
	popup.rotation = randf_range(-0.8, 0.8)  # Tilt between -15 and 15 degrees

	ControlNode.add_child(popup)

	var tween: Tween = create_tween()
	
	# Animate the position to move up
	# tween.tween_property(popup, "position:y", popup.position.y - 50, 0.5)
	
	# Animate the scale to make it pop
	popup.scale = Vector2(0, 0)
	tween.tween_property(popup, "scale", Vector2(1, 1), 0.2)
	tween.tween_property(popup, "modulate:a", 0, 2)  # Fade out over 0.25 seconds

	tween.tween_callback(Callable(popup, "queue_free"))
	
func spawning_client() -> void:
	var spot_choose: int
	if spot1_status == false and spot2_status == false and spot3_status == false:
		spot_choose = randi_range(1,3)
	elif spot1_status == true and spot2_status == true and spot3_status == false:
		spot_choose = 3
	elif spot1_status == false and spot2_status == true and spot3_status == true:
		spot_choose = 1
	elif spot1_status == true and spot2_status == false and spot3_status == true:
		spot_choose = 2
	elif spot1_status == true and spot2_status == false and spot3_status == false:
		spot_choose = randi_range(2,3)
	elif spot1_status == false and spot2_status == true and spot3_status == false:
		spot_choose = 1 if randi_range(0, 1) == 0 else 3
	elif spot1_status == false and spot2_status == false and spot3_status == true:
		spot_choose = randi_range(1,2)
		
	if spot_choose == 1 and spot1_status != true:
		spot1_status = true
		instance1 = choose_random_model()
		add_child(instance1)
		instance1.global_position = spot_1.global_position
		wait_time_1.start()
	elif spot_choose == 2 and spot2_status != true:
		spot2_status = true
		instance2 = choose_random_model()
		add_child(instance2)
		instance2.global_position = spot_2.global_position
		wait_time_2.start()
	elif spot_choose == 3 and spot3_status != true:
		instance3 = choose_random_model()
		spot3_status = true
		add_child(instance3)
		instance3.global_position = spot_3.global_position
		wait_time_3.start()

func choose_random_model() -> Node3D:
	var model_choose: int = randi_range(1,3)
	if model_choose == 1:
		return client1.instantiate()
	elif model_choose == 2: 
		return client2.instantiate()
	else:
		return client3.instantiate()

func _on_client_spawn_period_timeout() -> void:
	if spot1_status == true and spot2_status == true and spot3_status == true:
		pass
	else:
		spawning_client()

func _on_wait_time_1_timeout() -> void:
	if instance1: 
		instance1.queue_free()
		instance1 = null
	spot1_status = false

func _on_wait_time_2_timeout() -> void:
	if instance2:
		instance2.queue_free()
		instance2 = null
	spot2_status = false

func _on_wait_time_3_timeout() -> void:
	if instance3:
		instance3.queue_free()
		instance3 = null
	spot3_status = false
