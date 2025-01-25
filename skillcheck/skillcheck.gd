extends Node3D

@onready var playerBar: Area3D = $playerbar
@onready var aiBar: Area3D = $aibar
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var skillcheck: Node3D = $"."
@onready var crosshair: Sprite3D = $"../Crosshair"

var end: bool
var bar: float 
var is_in_area: bool
var time_passed: float
var current_random_value: float
var aiIncrement: bool 
var playerIncrement: bool

func _physics_process(delta: float)-> void:
	playerBar.position.y = clamp(playerBar.position.y, -3.5, 3)
	aiBar.position.y = clamp(aiBar.position.y, -3.5, 3)
	skill_check_end()
	time_passed += delta
	
	if playerIncrement == false:
		playerBar.position.y -= 10 * delta
		
	if playerIncrement == true:
		playerBar.position.y += 10 * delta
		
	if time_passed >= 0.5:
		time_passed = 0.0
		current_random_value = randf_range(-10, 10)
		aiIncrement = true

	if aiIncrement == true:
		aiBar.position.y += current_random_value * delta
		progress_bar.value = bar
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("space"):
		playerIncrement = true
	else:
		playerIncrement = false
		
		
func skill_check_end():
	if is_in_area == true:
		bar += 0.5
		
	elif bar >= 0:
		bar -= 0.25

	if bar >= 100:
		skillcheck.visible = false
		progress_bar.visible = false
		crosshair.visible = true
		%PlayerCamera.movement_disabled = false
		bar = 0
		
func _on_playerbar_area_entered(area: Area3D) -> void:
	is_in_area = true

func _on_playerbar_area_exited(area: Area3D) -> void:
	is_in_area = false
	
