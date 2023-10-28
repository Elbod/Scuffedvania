extends Node

var damage = 10
var playermaxhp = 5
var playerhp = 5
var experience = 0
var level = 1

var enemydamage = 1
var area = 1
var playerpos_x = 0
var playerpos_y = 0
var creatures = 0
var creaturelimit = 5

func _process(delta):
	if creatures < 0:
		creatures = 1
	if experience > level * 2 * 1.6:
		levelup()

func levelup():
	level += 1
	experience = 0
	print("level up!")
	
