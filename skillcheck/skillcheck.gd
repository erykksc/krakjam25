extends Node3D

@onready var playerBar: Area3D = $playerbar
@onready var aiBar: Area3D = $aibar


var is_in_area: bool
var bar: float 
var time_passed: float
var current_random_value: float
var aiIncrement: bool 
var playerIncrement: bool

func _physics_process(delta: float)-> void:
	if playerBar.position.y >= -3.5 and playerIncrement == false:
		playerBar.position.y -= 10 * delta
	skill_check_end()
	print(bar)
	
	time_passed += delta
	if time_passed >= 0.5:
		time_passed = 0.0
		current_random_value = randf_range(-10, 10)
		aiIncrement = true

	aiBar.position.y = clamp(aiBar.position.y, -3.5, 3.5)
	if aiIncrement == true:
		aiBar.position.y += current_random_value * delta
	
	if playerIncrement == true:
		if playerBar.position.y <= 3:
			playerBar.position.y += 10 * delta
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		playerIncrement = true
	else:
		playerIncrement = false
		
		
func skill_check_end():
	if is_in_area == true:
		bar += 0.5
	elif bar >= 0:
		bar -= 0.8
		
	if bar == 100:
		print("skill check done")

func _on_playerbar_area_entered(area: Area3D) -> void:
	is_in_area = true

func _on_playerbar_area_exited(area: Area3D) -> void:
	is_in_area = false
	
