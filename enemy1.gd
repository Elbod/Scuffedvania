extends CharacterBody2D
@onready var hurtbox = $hurtbox
@onready var enemy = $"."
@onready var hitbox = $hitbox
var hp = 10
var direction = -1
@export var speed = 1600
@export var gravity = 200
@export var jump_force = 5000
@export var agro = false
var delta_global = 0

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
	### HITTING WALL
	if self.is_on_wall() && $Timer.is_stopped():
		$Timer.start()
		direction *= -1
	
	### ANIMATION
	$AnimationPlayer.play("running")
	move_and_slide()

#ENEMY DIES BY YOUR HAND
func take_damage():
	hp -= global.damage
	$Label.text = str(hp)
	if hp <= 0:
		global.experience += 1
		despawn()

func _on_spawnarea_body_entered(body):
	if body.is_in_group("playergroup"):
		if $"../../player".position.x < self.position.x:
			direction = -1
		else:
			direction = 1
		agro = true

#ENEMY GETS HIT BY ACTION playergroup
func _on_hitbox_body_entered(body):
	if body.is_in_group("playergroup"):
		body.take_damage(delta_global)
	if body.is_in_group("pit"):
		despawn()

func initialize():
	pass

#ENEMY TOO FAR FROM PLAYER
func _on_leavearea_body_exited(body):
	if body.is_in_group("playergroup"):
		despawn()

#DESPAWN FUNCTION
func despawn():
	hitbox.collision_layer = 0
	hitbox.collision_mask = 0
	hurtbox.disabled = true
	hurtbox.set_deferred("disabled",true)
	self.visible = false
	$leavearea/CollisionShape2D.disabled = true
	$leavearea/CollisionShape2D.set_deferred("disabled",true)
	global.creatures -= 1
	pass
