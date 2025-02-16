class_name ClientSpawn
extends Node3D

@onready var spot_1: Marker3D = $Spot1
@onready var spot_2: Marker3D = $Spot2
@onready var spot_3: Marker3D = $Spot3

var client1: PackedScene = preload("res://clients/puszek/puszek.tscn")
var client2: PackedScene = preload("res://clients/galek/galek.tscn")
var client3: PackedScene = preload("res://clients/glutek/glutek.tscn")

@onready var spots: Array[Marker3D] = [spot_1, spot_2, spot_3]
@onready var clientModels: Array[PackedScene] = [client1, client2, client3]

func spawn() -> bool:
	var model: PackedScene = clientModels.pick_random()
	
	# find first free spot in the list
	var spotIdx: int = -1
	for i:int in spots.size():
		if spots[i].get_child_count() == 0:
			spotIdx = i
			break
	
	# There is no free spot to spawn a client
	if spotIdx ==-1:
		return false

	var spot: Marker3D = spots[spotIdx]

	var client:Client = model.instantiate()
	spot.add_child(client)
	client.global_position = spot.global_position

	return true
