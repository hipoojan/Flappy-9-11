extends Node

var MAX_SCORE = 99999999
var SAVE_GAME_PATH = "user://game_save.save"

var score = 0

func _ready():
	randomize()
	$BackgroundMusic.play()

func _on_Bird_start_flight():
	$StartObstacleSpawningTimeout.start()
	$HUD.show_mode($HUD.State.PLAYING)

func _on_StartObstacleSpawningTimeout_timeout():
	$ObstacleSpawner.start_generation()

func _on_ObstacleSpawner_score_point():
	score += 1
	score = clamp(score, 0, MAX_SCORE)
	$HUD.set_score_label(score)

func _on_Bird_death():
	$ObstacleSpawner.stop_generation()
	for obstacle in $ObstacleSpawner/GeneratedObstacles.get_children():
		obstacle.set_active(false)
	$Ground.set_active(false)
	$Background.set_active(false)
	var previous_best = load_save()
	previous_best = clamp(previous_best, 0, MAX_SCORE)
	if previous_best <= score:
		write_save(score)
	$HUD.show_mode($HUD.State.MENU)

func _on_HUD_restart():
	$ObstacleSpawner.wipe_obstacles()
	$Ground.set_active(true)
	$Background.set_active(true)
	score = 0
	$HUD.set_score_label(score)
	$Bird.set_player_state($Bird.State.AUTO_PILOT)
	$HUD.show_mode($HUD.State.SETUP)

func load_save():
	var saved_game = File.new()
	if not saved_game.file_exists(SAVE_GAME_PATH):
		return 0
	saved_game.open(SAVE_GAME_PATH, File.READ)
	var save = parse_json(saved_game.get_line())
	saved_game.close()
	return save["best"]

func write_save(new_best):
	var saved_game = File.new()
	saved_game.open(SAVE_GAME_PATH, File.WRITE)
	var save = to_json({"best": new_best})
	saved_game.store_line(save)
	saved_game.close()
