extends Node

var final_score: int = 0

const SAVE_FILE := "res://highscores.txt"

func save_score(new_score: int)->void:
	var file := FileAccess.open(SAVE_FILE, FileAccess.READ_WRITE)
	file.seek_end()
	file.store_line(str(new_score))
	file.flush()


func load_scores() -> Array[int]:
	if not FileAccess.file_exists(SAVE_FILE):
		return []

	var file := FileAccess.open(SAVE_FILE, FileAccess.READ)
	# parse each line as an int
	var scores:Array[int] =[]
	for line in file.get_as_text().split("\n"):
		if line == "":
			continue
		scores.append(int(line))
	return scores

