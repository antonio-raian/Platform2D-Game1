extends Area2D

export var fruits = 1

func _on_item_body_entered(body):
	$animation.play("collected")
	Global.fruits += fruits

func _on_animation_animation_finished(anim_name):
	if(anim_name=="collected"):
		queue_free();
