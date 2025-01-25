extends Node3D

@onready var room: Node3D = $"."

func _ready() -> void:
	for child: Node3D in room.get_children():
		var body: MeshInstance3D = child.get_child(0)
		var inner: StaticBody3D = body.get_child(0)
		
		body.material_overlay = preload("res://shaders/outline_black.tres")
		
		inner.add_to_group("interactable")
		inner.set_collision_layer_value(2, true)
	
