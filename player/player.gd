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
@onready var hand_middle: Marker3D = $PlayerCamera/hand/HandMiddle

# kubek 
var kubek_scene: PackedScene = preload("res://kubek/kubek.tscn")
var kubek_in_hand: bool = false


func _ready() -> void:
	skillcheck.visible = false
	progress_bar.visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if ray_cast_3d.is_colliding() and ray_cast_3d.get_collider().is_in_group("interactable"):
			if ray_cast_3d.get_collider().is_in_group("kubek") and kubek_in_hand == false:
				var kubek = kubek_scene.instantiate()
				kubek_in_hand = true
				hand_middle.add_child(kubek)
				kubek.scale = Vector3(0.5,0.5,0.5)
				hand_middle.global_position = kubek.global_position
				
				
			if ray_cast_3d.get_collider().is_in_group("kulki"):
				skillcheck.visible = true
				progress_bar.visible = true
				crosshair.visible = false
				$PlayerCamera.movement_disabled = true
				start_squeezing_hamster()
			
		
	
func start_squeezing_hamster() -> void:
	var animPlayer:AnimationPlayer = hand_hamster.get_node("AnimationPlayer")
	animPlayer.current_animation = "squeeze"
	hand.visible = false
	hand_hamster.visible = true
	animPlayer.play()


	
