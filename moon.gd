extends Sprite2D
var raisespeed = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	if self.position.y > 5:
		self.position.y = self.position.y - raisespeed * delta
	
