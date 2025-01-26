class_name Cloud
extends Node3D

@onready var Model:Node3D = $Model
@onready var MESH_INSTANCE_3D:MeshInstance3D = $Model/chmurka
@onready var original_material:Material = MESH_INSTANCE_3D.mesh.surface_get_material(0)
@onready var label:MeshInstance3D = $Label

const MODEL_SPIN_SPEED = 0.1

const COLOR_FLASH_DURATION := 0.6

var spin_speed: float = 1 if randf() >0.5 else -1

func _ready()->void:
	# add random rotation around x axis at the beginning
	Model.rotate_x(randf() * 2.0 * PI)

func _process(delta:float)->void:
	Model.rotate_x(spin_speed * delta * MODEL_SPIN_SPEED)

func set_ingredient(ingredient: String) -> void:
	var labelImg:CompressedTexture2D = Ingredients.Labels[ingredient]

	# TODO: create this material inside Ingredients.gd
	# in order not to create new material for every new cloud
	var material := StandardMaterial3D.new()
	material.albedo_texture = labelImg
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.flags_transparent = true

	label.material_override = material
	print("new label Img: ", labelImg)
	
func flash_color(color : Color) -> void:
	var new_mesh := MESH_INSTANCE_3D.mesh.duplicate()
	var new_material := original_material.duplicate()

	new_material.albedo_color = color
	
	new_mesh.surface_set_material(0, new_material)

	MESH_INSTANCE_3D.mesh = new_mesh

	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT_IN)
	tween.tween_property(new_material, "albedo_color", original_material.albedo_color, COLOR_FLASH_DURATION)
