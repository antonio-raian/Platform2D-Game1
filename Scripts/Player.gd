extends KinematicBody2D

var up = Vector2.UP
var vel = Vector2.ZERO
var move_speed = 520
var gravity = 1000
var jump_force = -520
var is_grounded
var health = 5
var max_health = 5
var hurted = false
var knock_dir = 1
var knock_force = 1000

onready var raycasts = $raycasts

signal change_life(health);

func _ready():
	connect("change_life", get_parent().get_node("HUD/HBoxContainer/life"), "_on_change_life")
	emit_signal("change_life", max_health)

func _physics_process(delta):
	vel.y += gravity * delta
	vel.x = 0
	
	if !hurted:
		_get_input()
		
	vel = move_and_slide(vel, up)
	is_grounded = _check_is_grounded()
	
	_set_animation()
	
#	Methods
func _get_input():
	vel.x = 0
	var move_dir = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	vel.x = lerp(vel.x, move_speed * move_dir, 0.2)
	
	if(move_dir !=0):
		$sprite.scale.x = move_dir
		knock_dir = move_dir
		
func _input(e: InputEvent):
	if e.is_action_pressed("jump") and is_grounded:
		vel.y = jump_force/2
		
func _check_is_grounded():
	for raycast in raycasts.get_children():
		if raycast.is_colliding():
			return true
	return false

func _set_animation():
	var anim = "idle"
	
	if !is_grounded:
		anim = "jump"
	elif vel.x !=0:
		anim = "run"
		
	if vel.y > 0 and !is_grounded:
		anim = "fall"
	
	if hurted:
		anim = "hit"
	
	if $animation.assigned_animation!=anim:
		$animation.play(anim)

func _knocback():
	vel.x = - knock_dir * knock_force
	vel = move_and_slide(vel)

func _on_hurtbox_body_entered(body):
	hurted = true;
	health -= 1
	
	emit_signal("change_life", health)
	
	_knocback()
	get_node("hurtbox/collision").set_deferred("disabled", true)
	yield(get_tree().create_timer(0.5), "timeout")
	get_node("hurtbox/collision").set_deferred("disabled", false)	
	hurted = false
	
	if health < 1:
		get_tree().reload_current_scene()
