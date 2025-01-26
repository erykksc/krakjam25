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
var kubek_in_hand: Kubek = null


func _ready() -> void:
	skillcheck.visible = false
	progress_bar.visible = false

func _input(event: InputEvent) -> void:
	if not event.is_action_pressed("interact"):
		return
	if not ray_cast_3d.is_colliding():
		return
	if not ray_cast_3d.get_collider().is_in_group("interactable"):
		return

	var interactable: Node3D = ray_cast_3d.get_collider().owner

	# Check if trying to reach for kubek
	if interactable==%kubki and kubek_in_hand == null:
		var kubek := kubek_scene.instantiate()
		hand_middle.add_child(kubek)
		kubek_in_hand = kubek
		kubek.scale = Vector3(0.5,0.5,0.5)
		hand_middle.global_position = kubek.global_position
		
	# Other ingredients require having a cup/kubek
	if not kubek_in_hand:
		return

	# Check if interacting with hamster/kulki
	if interactable == %kolo:
		skillcheck.visible = true
		progress_bar.visible = true
		crosshair.visible = false
		$PlayerCamera.movement_disabled = true
		start_squeezing_hamster()

	if interactable == %m_baza:
		kubek_in_hand.add_ingredient(Ingredients.TeaBase.WHITE)

	if interactable == %z_baza:
		kubek_in_hand.add_ingredient(Ingredients.TeaBase.GREEN)

	if interactable == %c_baza:
		kubek_in_hand.add_ingredient(Ingredients.TeaBase.ORANGE)
	
	if interactable == %z_smak:
		kubek_in_hand.add_ingredient(Ingredients.TeaWorm.YELLOW)

	if interactable == %cz_smak:
		kubek_in_hand.add_ingredient(Ingredients.TeaWorm.RED)

	if interactable == %n_smak:
		kubek_in_hand.add_ingredient(Ingredients.TeaWorm.BLUE)

	if interactable == %lod:
		kubek_in_hand.add_ingredient(Ingredients.ICE)

	if interactable == %zgrzewarka:
		kubek_in_hand.add_ingredient(Ingredients.LID)
	
	if interactable == %smietnik:
		kubek_in_hand.queue_free()

	if interactable == %podkladka1:
		var client:Client = %Spot1.get_child(0)
		if  client:
			client.submit_order(kubek_in_hand.contents)
			kubek_in_hand.queue_free()

	if interactable == %podkladka2:
		var client:Client = %Spot2.get_child(0)
		if  client:
			client.submit_order(kubek_in_hand.contents)
			kubek_in_hand.queue_free()

	if interactable == %podkladka3:
		var client:Client = %Spot3.get_child(0)
		if  client:
			client.submit_order(kubek_in_hand.contents)
			kubek_in_hand.queue_free()

	print("now in kubek:", kubek_in_hand.contents)
	
func start_squeezing_hamster() -> void:
	var animPlayer:AnimationPlayer = hand_hamster.get_node("AnimationPlayer")
	animPlayer.current_animation = "squeeze"
	hand.visible = false
	hand_hamster.visible = true
	animPlayer.play()


	
