extends Area2D

func _ready():
	set_active(true)

func set_active(is_active):
	if is_active:
		$AnimationPlayer.play("scrolling")
	else:
		$AnimationPlayer.stop()
