extends Control

@onready var scoreLabel:Label = $Score
@onready var highscoresLabel:Label = $Highscores

func _ready() -> void:
	scoreLabel.text = str(Globals.final_score)
