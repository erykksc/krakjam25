class_name Client
extends Node3D

@export var order_wait_time: float = 3.0
@export var points_for_order: int = 100

# added on _ready a node under which all clouds are spawned
var clouds: Node3D

const first_cloud_y_offset:float = 1.2
const cloud_margin:float = 0.8

const CLOUD_SCENE := preload("res://cloud/cloud.tscn")

# This variable should be set by the script spawning the client
var on_order_timeout : Callable = func()->void: pass

func _ready()->void:
	clouds = Node3D.new()
	add_child(clouds)

	# start order timer
	var orderTimer:= Timer.new()
	orderTimer.one_shot= true
	orderTimer.timeout.connect(func()-> void:
		queue_free()
		on_order_timeout.call()
	)
	orderTimer.wait_time = order_wait_time
	add_child(orderTimer)
	orderTimer.start()

	var new_clouds_count := randi_range(1, 4)
	for _i in new_clouds_count:
		addCloud()

func addCloud()->void:
	var cloudInstance := CLOUD_SCENE.instantiate()
	clouds.add_child(cloudInstance)
	var cloudOff:float = first_cloud_y_offset+ cloud_margin*(clouds.get_children().size()-1)
	cloudInstance.position += Vector3(0,cloudOff,0)
