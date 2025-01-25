class_name Client
extends Node3D

@export var order_wait_time: float = 3.0
@export var points_for_order: int = 100

# This variable should be set by the script spawning the client
var on_order_timeout : Callable = func()->void: pass

func _ready()->void:
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
	
	
