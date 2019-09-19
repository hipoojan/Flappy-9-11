extends CanvasLayer

signal restart

enum State {SETUP, PLAYING, MENU}

func _ready():
	show_mode(State.SETUP)

func _process(delta):
	if Input.is_action_just_released("fly") and $Menu.visible and not $Menu/CenterContainer/MenuBackground/CenterContainer/VBoxContainer/CenterContainer/TextureButton.disabled:
		_on_TextureButton_pressed()

func set_score_label(score):
	$ScoreLabel.text = str(score)
	$Menu/CenterContainer/MenuBackground/CenterContainer/VBoxContainer/CurrentScore/ScoreLabel.text = str(score)

func show_mode(mode):
	match mode:
		State.SETUP:
			$ScoreLabel.hide()
			$Menu.hide()
		State.PLAYING:
			$ScoreLabel.show()
			$Menu.hide()
		State.MENU:
			$ScoreLabel.hide()
			$Menu.modulate.a = 0
			$Menu.show()
			$AnimationPlayer.play("fade_in_menu")

func _on_TextureButton_pressed():
	emit_signal("restart")
