extends Control

@onready var scoreLabel:Label = $Score
@onready var highscoresLabel:Label = $Highscores

func _ready() -> void:
	scoreLabel.text = str(Globals.final_score)
	var scores := Globals.load_scores()
	scores.sort()
	scores.reverse()

	# remove all duplicates from the array
	var unique_scores: Array = []
	for score in scores:
		if not score in unique_scores:
			unique_scores.append(score)

	highscoresLabel.text = "\n".join(unique_scores)

func _on_continue_button_press() -> void:
	print("continue button press")
	get_tree().change_scene_to_file("res://menu/menu.tscn")
