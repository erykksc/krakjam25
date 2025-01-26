class_name Game
extends Node3D

@onready var ControlNode:Control = %Control
@onready var TotalPoints:Label = %TotalPoints
@onready var playerCamera: PlayerCamera = %PlayerCamera
@onready var clientSpawn:ClientSpawn  = %ClientSpawn

var pointLabel: PackedScene = preload("res://point-label/point-label.tscn")

var clientIdx:int = 0

var points: int = 0:
	set(value):
		var new_points:int = value - points
		spawn_point_label(new_points)
		points = value
		playerCamera.shake()
		TotalPoints.text = str(points)
	get:
		return points

func _ready() -> void :
	randomize() # randomizes the game seed
	TotalPoints.text = "0"

	# Try to spawn new clients every second
	var timer:Timer = Timer.new()
	add_child(timer)
	timer.wait_time = 1.0
	timer.timeout.connect(func()->void:
		print("Spawning client: ", clientIdx)
		clientIdx += 1
		var success:bool = clientSpawn.spawn(func()-> void:
			print("client ", clientIdx,  " removed")
		)
		if not success:
			push_warning("client ", clientIdx,  " failed to spawn")
	)
	timer.start()

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
