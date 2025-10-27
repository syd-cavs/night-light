extends Node

@onready var player = $Player
@onready var ghost = $Ghost
@onready var spawner = $Spawner

var score : int
var speed : float
var game_running : bool

func _ready():
	$GameOver.get_node("Button").pressed.connect(new_game)
	player.player_collided.connect(hit_obstacle)
	new_game()
	
func new_game():
	score = 0
	show_score()
	game_running = false
	get_tree().paused = false
	$HUD.get_node("Start").show()
	$GameOver.hide()
	spawner.game_ended()
	player.reset()
	for ghost in get_tree().get_nodes_in_group("Ghost"):
		ghost.queue_free()
	for candle in get_tree().get_nodes_in_group("Candle"):
		candle.queue_free()
	for stump in get_tree().get_nodes_in_group("Stump"):
		stump.queue_free()

func _process(delta):
	if !game_running and Input.is_action_just_pressed("ui_accept"):
		game_running = true
		$HUD.get_node("Start").hide()
		spawner.start_game()
		for ghost in get_tree().get_nodes_in_group("Ghost"):
			ghost.start_game()

func hit_obstacle(body):
	if body.is_in_group("Candle"):
		score += 10
		show_score()
		body.queue_free()
	elif body.is_in_group("Ghost"):
		game_over()

func show_score():
	$HUD.get_node("Score").text = "Score: " + str(score)

func game_over():
	get_tree().paused = true
	spawner.game_ended()
	game_running = false
	$GameOver.show()
