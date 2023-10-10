extends CharacterBody2D
@onready var hurtbox = $hurtbox
@onready var enemy = $"."
var hp = 1
var direction = -1
@export var speed = 1600
@export var gravity = 200
@export var jump_force = 5000
@export var agro = false

func _physics_process(delta):
	### HP DISPLAY
	$Label.text = str(hp)
	### FLIP DIRECTION
	if direction < 0:
		$sprite.flip_h = true
	else:
		$sprite.flip_h = false
	### ENEMY ACTIVE? > MOVE
	if agro == true:
		velocity.x = speed * direction * delta
		### GRAVITY
		if ! is_on_floor():
			velocity.y += gravity * delta
			if velocity.y > 8000 * delta:
				velocity.y = 8000 * delta
	### ANIMATION
	$AnimationPlayer.play("running")
	move_and_slide()

func take_damage():
	hp -= global.damage
	$Label.text = str(hp)
	if hp <= 0:
		hurtbox.disabled = true
		self.visible = false

func _on_spawnarea_body_entered(body):
	if body.is_in_group("playergroup"):
		if $"../../player".position.x < self.position.x:
			direction = -1
		else:
			direction = 1
		agro = true
		
