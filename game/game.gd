extends Node3D

@onready var ControlNode:Control = %Control
@onready var TotalPoints:Label = %TotalPoints
@onready var playerCamera: PlayerCamera = %PlayerCamera

var pointLabel: PackedScene = preload("res://point-label/point-label.tscn")

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
