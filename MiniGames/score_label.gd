extends Label

var score := 0

func _ready():
	text = "Treffer: 0/3"

func add_point():
	score += 1

	if score >= 3:
		text = "Gewonnen!"
	else:
		text = "Treffer: %d/3" % score
