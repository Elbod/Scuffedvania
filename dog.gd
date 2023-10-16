extends CharacterBody2D
@onready var hurtbox = $hurtbox
@onready var enemy = $"."
@onready var hitbox = $hitbox
var hp = 10
var direction = -1
var jumpedonce = false
var delta_global = 0
@export var speed = 3000
@export var gravity = 150
@export var jump_force = 3000
@export var agro = false

func _ready():
	$AnimationPlayer.play("idle")

func _physics_process(delta):
	delta_global = delta
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
		if is_on_floor() && jumpedonce != true:
			velocity.y = -jump_force * delta
		if is_on_floor():
			jumpedonce = true
			
	### HITTING WALL
	if self.is_on_wall() && $Timer.is_stopped():
		$Timer.start()
		direction *= -1
	
	### ANIMATION
	move_and_slide()

func take_damage():
	hp -= global.damage
	$Label.text = str(hp)
	if hp <= 0:
		hitbox.collision_layer = 0
		hitbox.collision_mask = 0
		hurtbox.disabled = true
		hurtbox.set_deferred("disabled",true)
		self.visible = false

func _on_spawnarea_body_entered(body):
	if body.is_in_group("playergroup"):
		if $"../../player".position.x < self.position.x:
			direction = -1
		else:
			direction = 1
		$AnimationPlayer.play("running")
		agro = true
		

func _on_hitbox_body_entered(body):
	if body.is_in_group("playergroup"):
		body.take_damage(delta_global)
