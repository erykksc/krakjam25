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


func _ready() -> void:
	progress_bar.value = 0

var is_in_area: bool = false
var time_passed: float = 0

const PLAYER_BAR_SPEED:float = 6
const PROGESS_BAR_SPEED:float = 20

func _process(delta: float)-> void:
	if not skillcheck.visible:
		return

	time_passed += delta
	playerBar.position.y = clamp(playerBar.position.y, -3.5, 2.5)
	aiBar.position.y = clamp(aiBar.position.y, -3.5, 2)

	if is_in_area == true:
		progress_bar.value += PROGESS_BAR_SPEED * delta
	elif progress_bar.value >= 0:
		progress_bar.value -= PROGESS_BAR_SPEED/2 * delta
		
	if progress_bar.value >= 100:
		skill_check_end()

	if Input.is_action_pressed("space"):
		playerBar.position.y += PLAYER_BAR_SPEED * delta
	else:
		playerBar.position.y -= PLAYER_BAR_SPEED * delta
		
	# Move target position every half second
	if time_passed >= 0.5:
		time_passed = 0.0
		aiBar.position.y = randf_range(-3.5, 2)
		
func skill_check_end() -> void:
	ray_cast_3d.enabled = true
	skillcheck.visible = false
	progress_bar.visible = false
	crosshair.visible = true
	%PlayerCamera.movement_disabled = false
	progress_bar.value = 0
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
