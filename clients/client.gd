class_name Client
extends Node3D

@export var order_wait_time: float = 3.0
@export var points_for_order: int = 100

@onready var game:Game = get_tree().current_scene

# added on _ready a node under which all clouds are spawned
var clouds: Node3D

var order: Array[String] = []

const first_cloud_y_offset:float = 1.2
const cloud_margin:float = 0.8

const CLOUD_SCENE := preload("res://cloud/cloud.tscn")

var orderTimer:= Timer.new()

func _ready()->void:
	clouds = Node3D.new()
	add_child(clouds)

	# start order timer
	orderTimer.one_shot= true
	orderTimer.timeout.connect(func()-> void:
		_on_order_wait_timeout()
	)
	orderTimer.wait_time = order_wait_time
	add_child(orderTimer)
	orderTimer.start()


	# Create the order
	var base := Ingredients.random_tea_base()
	var worm := Ingredients.random_tea_worm()
	order = [base, worm]

	if randf() > 0.5:
		order.append(Ingredients.ICE)

	if randf() > 0.5:
		order.append(Ingredients.LID)

	print("client: ", self, " order: ", order)

	# Add clouds to represent the order
	for i in order.size():
		var ingredient := order[i]
		addCloud(ingredient)

func addCloud(ingredient: String)->void:
	var cloudInstance := CLOUD_SCENE.instantiate()
	clouds.add_child(cloudInstance)
	var cloudOff:float = first_cloud_y_offset+ cloud_margin*(clouds.get_children().size()-1)
	cloudInstance.position += Vector3(0,cloudOff,0)

## WARNING: side effects, prepared_order is sorted
func submit_order(prepared_order:Array[String]) -> void:
	order.sort()
	prepared_order.sort()

	if order.size() != prepared_order.size():
		_on_wrong_order_submitted()
		return
	for i in order.size():
		if order[i] != prepared_order[i]:
			_on_correct_order_submitted()
			return 
	_on_correct_order_submitted()
	
func _on_wrong_order_submitted() -> void:
	print("wrong order submitted")
	queue_free()
	game.points -= points_for_order

func _on_correct_order_submitted() -> void:
	print("good order submitted")
	queue_free()
	game.points += points_for_order

func _on_order_wait_timeout() -> void:
	print("order wait timeout")
	queue_free()
	game.points -= points_for_order
