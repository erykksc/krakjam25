class_name PlayerCamera
extends Camera3D

@onready var player: Node3D = get_parent()
@onready var ray_cast_3d: RayCast3D = $RayCast3D

## Increase this value to give a slower turn speed
@export var CAMERA_TURN_SPEED:float = 200

@export var shake_period:float = 0.3
@export var shake_magnitude:float = 0.05

var last_highlighted_mesh: MeshInstance3D = null
var original_material_overlay: Material = null

func _ready()->void:
	set_process_input(true)

func _process(_delta: float) -> void:
	highlight()

func look_updown_rotation(new_rotation:float = 0)->Vector3:
	"""
	Returns a new Vector3 which contains only the x direction
	We'll use this vector to compute the final 3D rotation later
	"""
	var toReturn:Vector3 = self.get_rotation() + Vector3(new_rotation, 0, 0)

	##
	## We don't want the player to be able to bend over backwards
	## neither to be able to look under their arse.
	## Here we'll clamp the vertical look to 90° up and down
	toReturn.x = clamp(toReturn.x, PI / -2, PI / 2)

	return toReturn

func look_leftright_rotation(new_rotation:float = 0)->Vector3:
	"""
	Returns a new Vector3 which contains only the y direction
	We'll use this vector to compute the final 3D rotation later
	"""
	return player.get_rotation() + Vector3(0, new_rotation, 0)

func _input(event:InputEvent)->void:
	"""
	First person camera controls
	"""
	##
	## We'll only process mouse motion events
	if not event is InputEventMouseMotion:
		return

	##
	## We'll use the parent node "player" to set our left-right rotation
	## This prevents us from adding the x-rotation to the y-rotation
	## which would result in a kind of flight-simulator camera
	player.set_rotation(look_leftright_rotation(event.relative.x / -CAMERA_TURN_SPEED))

	##
	## Now we can simply set our y-rotation for the camera, and let godot
	## handle the transformation of both together
	self.set_rotation(look_updown_rotation(event.relative.y / -CAMERA_TURN_SPEED))

func _enter_tree()->void:
	"""
	Hide the mouse when we start
	"""
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _leave_tree()->void:
	"""
	Show the mouse when we leave
	"""
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func shake() -> void:
	var initial_transform:Transform3D = self.transform 
	var elapsed_time:float = 0.0

	while elapsed_time < shake_period:
		var offset:Vector3 = Vector3(
			randf_range(-shake_magnitude, shake_magnitude),
			randf_range(-shake_magnitude, shake_magnitude),
			0.0
		)

		self.transform.origin = initial_transform.origin + offset
		elapsed_time += get_process_delta_time()
		await get_tree().process_frame

	self.transform = initial_transform

func highlight() -> void:
	if ray_cast_3d.is_colliding() and ray_cast_3d.get_collider().is_in_group("interactable"):
		var colidingObject: Object = ray_cast_3d.get_collider()
		var mesh: MeshInstance3D = colidingObject.get_parent()
		
		if mesh != last_highlighted_mesh:
			if last_highlighted_mesh and original_material_overlay:
				last_highlighted_mesh.material_overlay = original_material_overlay
			
			original_material_overlay = mesh.material_overlay
			last_highlighted_mesh = mesh
				
			mesh.material_overlay = preload("res://shaders/outline_white.tres")
	else:
		if last_highlighted_mesh and original_material_overlay:
			last_highlighted_mesh.material_overlay = original_material_overlay
			last_highlighted_mesh = null
			original_material_overlay = null
