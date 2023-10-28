extends Node
func _ready():
	$spawntimer.start()

@export var mob_scene: PackedScene
var random_chance_spawn = 50



func _on_spawntimer_timeout():
	var random = randi_range(1,100)
	if global.creatures < global.creaturelimit && random < random_chance_spawn:
		print(global.creatures)
		var mob = mob_scene.instantiate()
		var player_position = $"../player".position.x
		mob.position.x = $"../Camera2D".position.x + 140
		mob.position.y = $"../Camera2D".position.y + -40
		mob.initialize()
		global.creatures += 1
		add_child(mob)
	$spawntimer.start()
