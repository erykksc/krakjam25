class_name Game
extends Node3D

@onready var ControlNode:Control = %Control
@onready var TotalPoints: Label = %TotalPoints
@onready var playerCamera: PlayerCamera = %PlayerCamera
@onready var clientSpawn:ClientSpawn  = %ClientSpawn
@onready var cute_recruit_246084: AudioStreamPlayer = $"Player/Cute-recruit-246084"
@onready var TimeLeft:Label = %TimeLeft
@onready var gameTimer:Timer  = Timer.new()

const SECONDS_PER_SUCCESSFUL_ORDER := 20.0

var pointLabel: PackedScene = preload("res://point-label/point-label.tscn")

var clientIdx:int = 0

var points: int = 0:
	set(value):
		var new_points:int = value - points
		spawn_point_label(new_points)
		points = value
		playerCamera.shake()
		TotalPoints.text = str(points)
		if new_points>0:
			gameTimer.wait_time = gameTimer.time_left + SECONDS_PER_SUCCESSFUL_ORDER
	get:
		return points

func _ready() -> void :
	cute_recruit_246084.play()
	randomize() # randomizes the game seed
	%TotalPoints.text = "0"

	# Try to spawn new clients every 4 second
	var timer:Timer = Timer.new()
	add_child(timer)
	timer.wait_time = 4.0
	timer.timeout.connect(func()->void:
		print("Spawning client: ", clientIdx)
		clientIdx += 1
		var success:bool = clientSpawn.spawn()
		if not success:
			push_warning("client ", clientIdx,  " failed to spawn")
	)
	timer.start()
	clientSpawn.spawn()

	gameTimer.wait_time = 5.0
	gameTimer.one_shot = true
	add_child(gameTimer)
	# on game finish/ended
	gameTimer.timeout.connect(func()->void:
		Globals.final_score = points
		Globals.save_score(points)
		get_tree().change_scene_to_file("res://highscore/highscore_view.tscn")
	)
	gameTimer.start()

func _process(_delta:float) -> void:
	TimeLeft.text = "%.1f" % gameTimer.time_left

func spawn_point_label(new_points: int)->void:
	var popup:Label = pointLabel.instantiate()

	if new_points < 0:
		popup.text = "-" 
		popup.label_settings.font_color = Color.RED

	else:
		popup.text = "+" 
		popup.label_settings.font_color = Color.GREEN

	popup.text += str(abs(new_points))


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
