class_name Client
extends Node3D

@export var order_wait_time: float = 9999.0
@export var points_for_order: int = 100
var disapointed: AudioStreamMP3 = preload("res://music/i-am-very-disappointed-male-spoken-213232.mp3")
var audio_player := AudioStreamPlayer.new()
@onready var game: Game = get_tree().current_scene

var clouds: Node3D
var order: Array[String] = []

const first_cloud_y_offset: float = 1.2
const cloud_margin: float = 0.8

const CLOUD_SCENE := preload("res://cloud/cloud.tscn")
var orderTimer := Timer.new()

func _ready() -> void:
	add_child(audio_player)
	audio_player.stream = disapointed
	
	var animPlayer: AnimationPlayer = find_child("AnimationPlayer", true, true)
	if animPlayer:
		for anim_name: String in ["idle", "ArmatureAction"]:
			if not animPlayer.has_animation(anim_name):
				continue
			animPlayer.get_animation(anim_name).loop_mode = Animation.LOOP_LINEAR
			animPlayer.play(anim_name)

	clouds = Node3D.new()
	add_child(clouds)

	orderTimer.one_shot = true
	orderTimer.timeout.connect(self._on_order_wait_timeout)
	orderTimer.wait_time = order_wait_time
	add_child(orderTimer)
	orderTimer.start()

	# Create the order
	var base := Ingredients.random_tea_base()
	var worm := Ingredients.random_tea_worm()
	order = [Ingredients.TAPIOKA, base, worm]

	if randf() > 0.5:
		order.append(Ingredients.ICE)

	order.append(Ingredients.LID)

	print("client: ", self, " order: ", order)

	# Add clouds to represent the order
	for ingredient in order:
		if ingredient == Ingredients.LID:
			continue
		if ingredient == Ingredients.TAPIOKA:
			continue
		addCloud(ingredient)

func addCloud(ingredient: String) -> void:
	var cloudInstance: Cloud = CLOUD_SCENE.instantiate()
	clouds.add_child(cloudInstance)
	cloudInstance.set_ingredient(ingredient)

	var cloudOff: float = first_cloud_y_offset + cloud_margin * (clouds.get_children().size() - 1)
	cloudInstance.position += Vector3(0, cloudOff, 0)

## WARNING: side effects, prepared_order is sorted
func submit_order(kubek: Kubek) -> void:
	order.sort()
	kubek.contents.sort()

	if not kubek.contents.has(Ingredients.LID):
		push_warning("Submitted order doesn't have a lid.")
		for cloud: Cloud in clouds.get_children():
			cloud.flash_color(Color.RED)
		return

	if order.size() != kubek.contents.size():
		_on_wrong_order_submitted(kubek.contents)
		kubek.queue_free()
		return

	for i in order.size():
		if order[i] != kubek.contents[i]:
			_on_correct_order_submitted()
			kubek.queue_free()
			return 
	_on_correct_order_submitted()
	kubek.queue_free()

func _on_wrong_order_submitted(prepared_order: Array[String]) -> void:
	print("Wrong order submitted, wanted: ", order, " received: ", prepared_order)
	for cloud: Cloud in clouds.get_children():
		cloud.flash_color(Color.RED)
	game.points -= points_for_order
	await get_tree().create_timer(Cloud.COLOR_FLASH_DURATION).timeout
	queue_free()

func _on_correct_order_submitted() -> void:
	print("Good order submitted")
	for cloud: Cloud in clouds.get_children():
		cloud.flash_color(Color.GREEN)
	game.points += points_for_order
	await get_tree().create_timer(Cloud.COLOR_FLASH_DURATION).timeout
	queue_free()

func _on_order_wait_timeout() -> void:
	print("Order wait timeout")
	
	# Flash all clouds to red
	for cloud: Cloud in clouds.get_children():
		cloud.flash_color(Color.RED)
	
	# Deduct points from the game
	game.points -= points_for_order

	# Set up the timer
	var audio_length: float = audio_player.stream.get_length()  # Get length of the audio
	var wait_timer: Timer = Timer.new()
	wait_timer.wait_time = audio_length
	wait_timer.one_shot = true
	wait_timer.timeout.connect(self._on_music_finished)  # Connect to function that handles after music finishes
	add_child(wait_timer)
	wait_timer.start()  # Start the timer

	# Play the audio
	audio_player.play()

func _on_music_finished() -> void:
	# Clean up the client node
	queue_free()
