extends Node

const TAPIOKA = "tapioka"

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

const Labels = {
	TeaBase.WHITE : preload("res://cloud/labels/m_baza.png"),
	TeaBase.GREEN : preload("res://cloud/labels/z_baza.png"),
	TeaBase.ORANGE : preload("res://cloud/labels/c_baza.png"),
	# Tastes/smaki
	TeaWorm.YELLOW : preload("res://cloud/labels/z_smak.png"),
	TeaWorm.RED : preload("res://cloud/labels/cz_smak.png"),
	TeaWorm.BLUE : preload("res://cloud/labels/n_smak.png"),
	# Others/misc
	ICE : preload("res://cloud/labels/lod.png"),
}
