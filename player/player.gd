extends Node3D

@onready var crosshair: Sprite3D = $PlayerCamera/Crosshair
@onready var ray_cast_3d: RayCast3D = $PlayerCamera/RayCast3D
@onready var skillcheck: Node3D = $PlayerCamera/skillcheck
@onready var progress_bar: ProgressBar = $PlayerCamera/skillcheck/ProgressBar

var skillcheck_status: bool


func _ready() -> void:
	skillcheck.visible = false
	progress_bar.visible = false

func _input(event: InputEvent) -> void:
	if ray_cast_3d.is_colliding() and ray_cast_3d.get_collider().is_in_group("kulki") and skillcheck.visible == false:
		print(ray_cast_3d.get_collider())
		if event.is_action_pressed("interact"):
			skillcheck.visible = true
			progress_bar.visible = true
			crosshair.visible = false
			$PlayerCamera.movement_disabled = true
				
