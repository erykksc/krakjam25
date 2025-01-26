extends Control

@onready var cute_recruit_246084: AudioStreamPlayer = $"Cute-recruit-246084"

func  _ready() -> void:
	cute_recruit_246084.play()

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://game/game.tscn")
	
func _process(delta: float) -> void:
	pass
