extends CharacterBody2D
@onready var hurtbox = $hurtbox
@onready var enemy = $"."
@onready var hitbox = $hitbox
var hp = 10
var direction = -1
@export var speed = 40
@export var gravity = 0
@export var jump_force = 5000
@export var agro = false
var delta_global = 0

func _physics_process(delta):
	delta_global = delta
	### HP DISPLAY
	$Label.text = str(hp)

	### ENEMY ACTIVE? > MOVE
	if agro == true:
		velocity.x = (($"../../player".position.x - self.position.x) * speed) * delta
		velocity.y = (($"../../player".position.y - self.position.y) * speed) * delta


	### ANIMATION
	$AnimationPlayer.play("idle")
	move_and_slide()

func take_damage():
	hp -= global.damage
	$Label.text = str(hp)
	if hp <= 0:
		hitbox.collision_layer = 0
		hitbox.collision_mask = 0
		hurtbox.set_deferred("disabled",true)
		$hitbox/CollisionShape2D.disabled = true
		self.visible = false
		self.hide()

func _on_spawnarea_body_entered(body):
	if body.is_in_group("playergroup"):
		agro = true


func _on_hitbox_body_entered(body):
	if body.is_in_group("playergroup"):
		body.take_damage(delta_global)
		### BAT SUICIDES
		hp = 0
		take_damage()

