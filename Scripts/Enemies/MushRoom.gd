extends KinematicBody2D

export var speed = 32
export var health = 1

var vel = Vector2.ZERO
var move_dir = -1
var gravity = 1000

var hitted = false

func _physics_process(delta):
	vel.y += gravity * delta
	vel.x = speed * move_dir
	
	if move_dir == 1:
		$sprite.flip_h = true
	else:
		$sprite.flip_h = false
	
	if $ray_wall.is_colliding():
		$animation.play("idle");
		
	_set_animation()
	vel = move_and_slide(vel)

func _on_animation_animation_finished(anim_name):
	if anim_name == "idle":
		$ray_wall.scale.x *= -1
		move_dir *= -1
		$animation.play("run")

func _on_HitBox_body_entered(body):
	hitted = true
	body.vel.y = -300
	health -= 1
	yield(get_tree().create_timer(0.2), "timeout")
	hitted = false
	
	if health < 1:
		queue_free()
		get_node("HitBox/collision").set_deferred("disabled", true)

func _set_animation():
	var anim = "run"
	
	if $ray_wall.is_colliding():
		anim = "idle"
	elif vel.x !=0:
		anim = "run"
		
	if hitted:
		anim = "hit"
	
	if $animation.assigned_animation!=anim:
		$animation.play(anim)
