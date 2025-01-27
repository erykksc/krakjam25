extends Node3D

@onready var playerBar: Area3D = $playerbar
@onready var aiBar: Area3D = $aibar
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var skillcheck: Node3D = $"."
@onready var crosshair: Sprite3D = $"../Crosshair"
@onready var animation_player: AnimationPlayer = $"../hand_hamster/AnimationPlayer"
@onready var hand_hamster: Node3D = $"../hand_hamster"
@onready var hand: Node3D = $"../hand"
@onready var sad_hamster: AudioStreamPlayer = $"../../SadHamster"
@onready var cute_recruit_246084: AudioStreamPlayer = $"../../Cute-recruit-246084"
@onready var ray_cast_3d: RayCast3D = $"../RayCast3D"
@onready var bubble_hitsound: AudioStreamPlayer = $"../../BubbleHitsound"


var end: bool
var bar: float 
var is_in_area: bool
var time_passed: float
var current_random_value: float
var aiIncrement: bool 
var playerIncrement: bool


func _physics_process(delta: float)-> void:
	playerBar.position.y = clamp(playerBar.position.y, -3.5, 2.5)
	aiBar.position.y = clamp(aiBar.position.y, -3.5, 2)
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
		
		
func skill_check_end() -> void:
	if skillcheck.visible == true:
		if is_in_area == true:
			bar += 0.5
		
		elif bar >= 0:
			bar -= 0.25
		
	if bar >= 100:
		ray_cast_3d.enabled = true
		skillcheck.visible = false
		progress_bar.visible = false
		crosshair.visible = true
		%PlayerCamera.movement_disabled = false
		bar = 0
		hand_hamster.visible = false
		hand.visible = true
		animation_player.stop()
		bubble_hitsound.play()
		sad_hamster.stop()
		cute_recruit_246084.set_volume_db(0)
		%Player.kubek_in_hand.add_ingredient(Ingredients.TAPIOKA)
		
func _on_playerbar_area_entered(_area: Area3D) -> void:
	is_in_area = true

func _on_playerbar_area_exited(_area: Area3D) -> void:
	is_in_area = false
	
