extends Node3D

@onready var crosshair: Sprite3D = $PlayerCamera/Crosshair
@onready var ray_cast_3d: RayCast3D = $PlayerCamera/RayCast3D
@onready var skillcheck: Node3D = $PlayerCamera/skillcheck
@onready var progress_bar: ProgressBar = $PlayerCamera/skillcheck/ProgressBar

var SKILLCHECK: PackedScene = preload("res://skillcheck/skillcheck.tscn")
var skillcheck_state: bool
var skillcheck_instance: Node3D

# Hand skeleton
@onready var skeleton: Skeleton3D = $PlayerCamera/hand/Armature/Skeleton3D
@onready var wrist_bone_idx := skeleton.find_bone("przedramie")  # or your root bone name

var wobble_strength := 1
var smooth_speed := 5.0
@onready var last_rotation := rotation

# hands
@onready var hand: Node3D = $PlayerCamera/hand
@onready var hand_hamster: Node3D = $PlayerCamera/hand_hamster

func _ready() -> void:
	skillcheck.visible = false
	progress_bar.visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		# skill check on hamster
		if ray_cast_3d.is_colliding() and ray_cast_3d.get_collider().is_in_group("kulki"):
			skillcheck.visible = true
			progress_bar.visible = true
			crosshair.visible = false
			$PlayerCamera.movement_disabled = true
		# TODO: add other interactions and remove this one
		else:
			start_squeezing_hamster()
	if event.is_action_released("interact"):
		stop_squeezing_hamster()

func start_squeezing_hamster() -> void:
	var animPlayer:AnimationPlayer = hand_hamster.get_node("AnimationPlayer")
	animPlayer.current_animation = "squeeze"
	hand.visible = false
	hand_hamster.visible = true
	animPlayer.play()

func stop_squeezing_hamster() -> void:
	# No action is needed
	if not hand_hamster.visible:
		return
	var animPlayer:AnimationPlayer = hand_hamster.get_node("AnimationPlayer")
	hand_hamster.visible = false
	hand.visible = true
	animPlayer.stop()

# TODO: fix the wobble on y coordinates
# currently it doesn't work because player is rotated on the x axis and camera3d on the y axis
# so the rotation_diff is not accurate
func _process(delta:float)-> void:
	var initial_rotation := skeleton.get_bone_pose_rotation(wrist_bone_idx).get_euler()

	var rotation_diff := rotation - last_rotation

	# Convert to rotation (-wobble to +wobble)
	var target_rotation := initial_rotation + Vector3(
		(rotation_diff.x) * wobble_strength,
		0,
		(-rotation_diff.y) * wobble_strength,
	)

	# Smooth interpolation
	var wrist_rotation := initial_rotation.lerp(target_rotation, smooth_speed * delta)
	skeleton.set_bone_pose_rotation(wrist_bone_idx, Quaternion.from_euler(wrist_rotation))
	last_rotation = rotation
