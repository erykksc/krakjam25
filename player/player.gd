extends Node3D

@onready var crosshair: Sprite3D = $PlayerCamera/Crosshair
@onready var ray_cast_3d: RayCast3D = $PlayerCamera/RayCast3D

var SKILLCHECK: PackedScene = preload("res://skillcheck/skillcheck.tscn")
var skillcheck_state: bool
var skillcheck_instance: Node3D




func _input(event: InputEvent) -> void:
	if ray_cast_3d.is_colliding() and ray_cast_3d.get_collider().is_in_group("kulki"):
		if event.is_action_pressed("interact"):
			skillcheck_state = true
			skillcheck_instance = SKILLCHECK.instantiate()
			$PlayerCamera.add_child(skillcheck_instance)
			skillcheck_instance.scale = Vector3(0.1, 0.1, 0.1)
			skillcheck_instance.position = Vector3(0, 0.16, -0.975)
			crosshair.visible = false
