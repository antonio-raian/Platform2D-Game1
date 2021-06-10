extends HBoxContainer

func _on_change_life(health):
	$score.set_text(str(health))
