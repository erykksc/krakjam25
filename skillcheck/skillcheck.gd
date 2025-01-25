extends Node3D
@onready var playerBar: Area3D = $playerbar
@onready var aiBar: Area3D = $aibar


var is_in_area: bool
var bar: int 
var time_passed: float
var current_random_value: float

func _physics_process(delta: float)-> void:
	if playerBar.position.y >= -3.5:
		playerBar.position.y -= 2.5 * delta
	skill_check_end()
	print(bar)
	
	time_passed += delta
	if time_passed >= 2.0:
		time_passed = 0.0
		current_random_value = randf_range(-3.5, 3.5)
		
	aiBar.position.y = current_random_value * delta
	aiBar.position.y = clamp(aiBar.position.y, -3.5, 3.5)
	
func _input(event: InputEvent) -> void:
	if event.is_action("ui_accept") and playerBar.position.y <= 3:
		playerBar.position += Vector3(0, 0.5, 0)
		
func skill_check_end():
	if is_in_area == true:
		bar += 0.5
	else:
		bar -= 1
		
	
	if bar == 100:
		print("dupa dupa dupa")

func _on_playerbar_area_entered(area: Area3D) -> void:
	is_in_area = true

func _on_playerbar_area_exited(area: Area3D) -> void:
	is_in_area = false
	
