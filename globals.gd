class_name Globals

const TeaBase = {
    WHITE = "base_white",
    GREEN = "base_green",
    ORANGE = "base_orange"
}

func random_tea_base()->String:
	var keys := TeaBase.keys()
	var random_key:String = keys[randi() % keys.size()]
	return TeaBase[random_key]

const TeaWorm = {
    YELLOW ="worm_yellow",
    RED = "worm_red",
    BLUE = "worm_blue",
}

func random_tea_worm()->String:
	var keys := TeaWorm.keys()
	var random_key:String = keys[randi() % keys.size()]
	return TeaWorm[random_key]

const ICE = "ice"
const LID = "lid"
