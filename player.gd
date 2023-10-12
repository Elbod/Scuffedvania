extends CharacterBody2D
@export var speed = 1600
@export var gravity = 300
@export var jump_force = 6000
var is_crouching = false
var is_climbing = false
var jumpcommit = false
var whipcommit = false

@onready var ap = $AnimationPlayer
@onready var sprite = $sprite
@onready var whiptimerin = $whiptimerin
@onready var whiptimerout = $whiptimerout
@onready var whipcooldown = $whipcooldown
@onready var whip = $whip
@onready var whiphitbox = $sprite/whiphitbox
@onready var stairscheck = $staircheck
@onready var stairs = $"../stairs"

func _on_whiptimerin_timeout():
	whip.visible = true
	whiptimerout.start()

func _on_whiptimerout_timeout():
	whip.visible = false

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "attack_standing":
		whip.visible = false
		whipcommit = false

func update_animations(horizontal_direction):
	if is_on_floor() && whipcommit == false:
		if horizontal_direction == 0:
			ap.play("idle")
		if horizontal_direction != 0:
			ap.play("running")
		if is_crouching == true:
			ap.play("crouching")
	if ! is_on_floor() && whipcommit == false:
		ap.play("jumping")
	if whipcommit == true:
		ap.play("attack_standing")


func _physics_process(delta):
	###Gravity ish
	if ! is_on_floor():
		velocity.y += gravity * delta
		jumpcommit = true
		is_climbing = false
		
		if velocity.y > 8000 * delta:
			velocity.y = 8000 * delta
	else:
		jumpcommit = false
	###WHIP ORIENTATION
	if sprite.flip_h == true:
		if global.area == 1:
			whip.scale.x = 1
			whip.position.x = -11
			whiphitbox.scale.x = 1
			whiphitbox.position.x = -7
			whip.flip_h = true
		if global.area == 2:
			whip.scale.x = 2
			whip.position.x = -20
			whiphitbox.scale.x = 2
			whiphitbox.position.x = -12
			whip.flip_h = true
	else:
		if global.area == 1:
			whip.scale.x = 1
			whip.position.x = 4
			whiphitbox.scale.x = 1
			whiphitbox.position.x = 8
			whip.flip_h = false
		if global.area == 2:
			whip.scale.x = 2
			whip.position.x = 4
			whiphitbox.scale.x = 2
			whiphitbox.position.x = 12
			whip.flip_h = false
	
	###Jumping
	if Input.is_action_just_pressed("jump") && is_on_floor() && whipcommit == false:
		velocity.y = -jump_force * delta
		is_climbing = false
	
	
	###WHIPFLOOR
	if Input.is_action_just_pressed("attack") && whipcommit == false:
		whipcommit = true
		whiptimerin.start()
	
	####MOVING
	var horizontal_direction = Input.get_axis("move_left", "move_right")
	if whipcommit == true && is_on_floor():
		velocity.x = 0
	if whipcommit == false:
		velocity.x = speed * horizontal_direction * delta
	
	if horizontal_direction != 0 && whipcommit == false:
		sprite.flip_h = (horizontal_direction == -1)
	
	#### STAIRS
	stairs_action()
	
	###CROUCHING
	if Input.is_action_pressed("crouching") && is_on_floor():
		velocity.x = 0
		is_crouching = true
	else:
		is_crouching = false
		
		
	move_and_slide()
	update_animations(horizontal_direction)

func _on_whiphitbox_body_entered(body):
	if body.is_in_group("hurtbox"):
		body.take_damage()

func upgrade_player():
	pass

func stairs_action():
	if self.is_on_floor_only() && stairscheck.is_colliding() == false:
		stairs.collision_layer = 0
	if is_climbing == false:
		stairs.collision_layer = 0
	if Input.is_action_pressed("stairs") && stairscheck.is_colliding():
		is_climbing = true
		stairs.collision_layer = 2
	if Input.is_action_pressed("stairs"):
		stairs.collision_layer = 2
