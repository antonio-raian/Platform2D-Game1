extends Area2D

func _on_item_body_entered(body):
	$animation.play("collected")

func _on_animation_animation_finished(anim_name):
	if(anim_name=="collected"):
		queue_free();
