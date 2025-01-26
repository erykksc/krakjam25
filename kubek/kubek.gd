class_name Kubek
extends Node3D

var contents: Array[String] = []

func add_ingredient(ingredient: String) -> void:
	if contents.has(ingredient):
		return
	contents.append(ingredient)
