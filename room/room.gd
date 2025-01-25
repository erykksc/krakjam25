extends Node3D

@onready var room: Node3D = $"."

func _ready() -> void:
	for body in room.find_children("", "MeshInstance3D", true):
		var inner: StaticBody3D = body.get_node("StaticBody3D")
		
		body.material_overlay = preload("res://shaders/outline_black.tres")
		
		inner.add_to_group("interactable")
		inner.set_collision_layer_value(2, true)
	
