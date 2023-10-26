extends CharacterBody2D
@export var speed = 1600
@export var gravity = 300
@export var jump_force = 6000
var delta_global = 0
var is_crouching = false
var is_climbing = false
var is_damaged = false
var is_damaged_ended = true
var jumpcommit = false
var whipcommit = false
var inmortal= false

@onready var ap = $AnimationPlayer
@onready var sprite = $sprite
@onready var whiptimerin = $whiptimerin
@onready var whiptimerout = $whiptimerout
@onready var whipcooldown = $whipcooldown
@onready var whip = $whip
@onready var whiphitbox = $sprite/whiphitbox
@onready var stairscheck = $staircheck
@onready var stairs = $"../stairs"
@onready var timerdamaged = $timerdamaged
@onready var timerimmortal = $timerimmortal
@onready var hpdisplay = $hp

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
		if $AnimationPlayer/jumpingbounce.is_stopped():
			ap.play("jumping")
		else:
			ap.play("jumping_bounce")
	if whipcommit == true:
		ap.play("attack_standing")
	if is_damaged_ended == false:
		ap.play("damaged")


func _physics_process(delta):
	delta_global = delta
	###Gravity ish
	if ! is_on_floor():
		velocity.y += gravity * delta
		jumpcommit = true
		is_climbing = false
		
		if velocity.y > 8000 * delta:
			velocity.y = 8000 * delta
	else:
		jumpcommit = false
	### FALLING IN A PIT
	if $deathcheck.is_colliding():
		global.playerhp = 0
	
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
			
	if Input.is_action_just_pressed("testing button"):
		take_damage(delta_global)
		pass

	
	###Jumping
	if Input.is_action_just_pressed("jump") && is_on_floor() && whipcommit == false && is_damaged_ended == true:
		velocity.y = -jump_force * delta
		$AnimationPlayer/jumpingbounce.start()
		is_climbing = false
	
	
	###WHIPFLOOR
	if Input.is_action_just_pressed("attack") && whipcommit == false && is_damaged_ended == true:
		whipcommit = true
		whiptimerin.start()
	
	####MOVING
	var horizontal_direction = Input.get_axis("move_left", "move_right")
	if whipcommit == true && is_on_floor():
		velocity.x = 0
	if whipcommit == false && is_damaged_ended == true:
		velocity.x = speed * horizontal_direction * delta
	
	if horizontal_direction != 0 && whipcommit == false && is_damaged_ended == true:
		sprite.flip_h = (horizontal_direction == -1)
	
	#### STAIRS
	stairs_action()
	
	###CROUCHING
	if Input.is_action_pressed("crouching") && is_on_floor() && is_damaged_ended == true:
		velocity.x = 0
		is_crouching = true
	else:
		is_crouching = false
	
	### TAKING DAMAGE MOTION
	if is_damaged == true:
		if sprite.flip_h == true:
			var damageright = 1
			velocity.x = speed * 1 * delta
		else:
			velocity.x = speed * -1 * delta
	if is_damaged == false && is_on_floor():
		is_damaged_ended = true 

	move_and_slide()
	update_animations(horizontal_direction)

func _on_whiphitbox_body_entered(body):
	if body.is_in_group("hurtbox"):
		body.take_damage()

func upgrade_player():
	pass

func stairs_action():
	if is_damaged_ended == true:
		if self.is_on_floor_only() && stairscheck.is_colliding() == false:
			stairs.collision_layer = 0
		if is_climbing == false:
			stairs.collision_layer = 0
		if Input.is_action_pressed("stairs") && stairscheck.is_colliding():
			is_climbing = true
			stairs.collision_layer = 2
		if Input.is_action_pressed("stairs"):
			stairs.collision_layer = 2

func take_damage(delta_global):
	if inmortal == false:
		global.playerhp -= global.enemydamage
		print("aouch!")
		is_damaged = true
		is_damaged_ended = false
		inmortal = true
		hpdisplay.text = str(global.playerhp)
		hpdisplay.visible = true
		knockback(delta_global)
		timerdamaged.start()
		timerimmortal.start()

func knockback(delta_global):
	velocity.y = (-jump_force / 1.5) * delta_global

func _on_timerdamaged_timeout():
	is_damaged = false

func _on_timerimmortal_timeout():
	inmortal = false
	hpdisplay.visible = false
