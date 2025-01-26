class_name Cloud
extends Node3D

@onready var Model:Node3D = $Model
@onready var label:MeshInstance3D = $Label

const MODEL_SPIN_SPEED = 0.1

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
	
