class_name Kubek
extends Node3D

var contents: Array[String] = []

@onready var baseRed: Node3D = $baseRed
@onready var baseGreen: Node3D = $baseMilk
@onready var baseMilk: Node3D = $baseMilk

@onready var wormYellow: Node3D = $wormYellow
@onready var wormRed: Node3D = $wormRed
@onready var wormBlue: Node3D = $wormBlue

@onready var ice: Node3D = $ice
@onready var lid: Node3D = $lid
@onready var bubbles: Node3D = $bubbles

func add_ingredient(ingredient: String) -> void:
	# Can't add something that is already inside
	if contents.has(ingredient):
		return

	# Can't add anything if lid is closed
	if contents.has(Ingredients.LID):
		return
	contents.append(ingredient)

	match ingredient:
		# Bubble tea base
		Ingredients.TeaBase.WHITE:
			baseMilk.visible = true
		Ingredients.TeaBase.GREEN:
			baseGreen.visible = true
		Ingredients.TeaBase.ORANGE:
			baseRed.visible = true

		# Bubble tea taste/worm
		Ingredients.TeaWorm.YELLOW:
			wormYellow.visible = true
		Ingredients.TeaWorm.RED:
			wormRed.visible = true
		Ingredients.TeaWorm.BLUE:
			wormBlue.visible = true

		Ingredients.ICE:
			ice.visible = true

		Ingredients.LID:
			lid.visible = true

		Ingredients.TAPIOKA:
			bubbles.visible = true
