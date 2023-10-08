extends CharacterBody2D
@export var speed = 1600
@export var gravity = 160
@export var jump_force = 5000
var is_crouching = false

@onready var ap = $AnimationPlayer
@onready var sprite = $sprite


func _physics_process(delta):
	###Gravity ish
	if ! is_on_floor():
		velocity.y += gravity * delta
		if velocity.y > 6000 * delta:
			velocity.y = 6000 * delta
	###Jumping
	if Input.is_action_just_pressed("jump") && is_on_floor():
			velocity.y = -jump_force * delta
	
	####MOVING
	var horizontal_direction = Input.get_axis("move_left", "move_right")
	velocity.x = speed * horizontal_direction * delta
	
	if horizontal_direction != 0:
		sprite.flip_h = (horizontal_direction == -1)
	
		###CROUCHING
	if Input.is_action_pressed("crouching") && is_on_floor():
		velocity.x = 0
		is_crouching = true
	else:
		is_crouching = false
		
		
	move_and_slide()
	update_animations(horizontal_direction)
	

func update_animations(horizontal_direction):
	if is_on_floor():
		if horizontal_direction == 0:
			ap.play("idle")
		if horizontal_direction != 0:
			ap.play("running")
		if is_crouching == true:
			ap.play("crouching")
