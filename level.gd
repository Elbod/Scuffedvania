extends Node2D
@onready var player = $player
@onready var camera = $Camera2D
var camerascrolltype = "x"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	### CAMERA CONTROLS ###
	if camerascrolltype == "x":
		camerascroll_x()
	else:
		camerascroll_y()

	#decoration_paralax_notmove()
	#####TESTING
	if Input.is_action_just_pressed("testing button"):
		#testing()
		pass
	############

func camerascroll_x():
	camera.position.x = player.position.x
func camerascroll_y():
	camera.position.y = player.position.y
#func decoration_paralax_notmove():
	#$decorations/moon.position.x = player.position.x
	
