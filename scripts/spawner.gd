extends Node2D

@export var spawns: Array[Spawn_info] = []
@export var min_spawn_distance : float = 300.0
@export var max_spawn_distance : float = 600.0

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var timer: Timer = $Timer

var time = 0
var game_running : bool = false

func _ready():
	timer.timeout.connect(_on_timer_timeout)

func start_game():
	game_running = true
	timer.start()

func _on_timer_timeout():
	time += 1
	for i in spawns:
		if time >= i.time_start and time <= i.time_end:
			
			#ghost spawner
			i.spawn_delay_counter += 1
			if i.ghost != null and i.spawn_delay_counter >= i.ghost_spawn_delay:
				i.spawn_delay_counter = 0
				for j in range(i.ghost_num):
					var ghost_instance = i.ghost.instantiate()
					ghost_instance.add_to_group("Ghost")
					ghost_instance.global_position = get_random_position()
					add_child(ghost_instance)
					if get_parent().game_running:
						ghost_instance.start_game()
					#print("Ghost spawned at:", ghost_instance.global_position)
			
			#candle spawner
			i.spawn_delay_counter2 += 1
			if i.candle != null and i.spawn_delay_counter2 >= i.candle_spawn_delay:
				i.spawn_delay_counter2 = 0
				for j in range(i.candle_num):
					var candle_instance = i.candle.instantiate()
					candle_instance.add_to_group("Candle")
					candle_instance.global_position = get_random_position()
					add_child(candle_instance)
					#print("Candle spawned at:", candle_instance.global_position)
					
			#obstacle spawner
			i.spawn_delay_counter3 += 1
			if i.stump != null and i.spawn_delay_counter3 >= i.stump_spawn_delay:
				i.spawn_delay_counter3 = 0
				for j in range(i.stump_num):
					var stump_instance = i.stump.instantiate()
					stump_instance.global_position = get_random_position()
					add_child(stump_instance)
					#print("Stump spawned at:", stump_instance.global_position)
						
func get_random_position():
	var angle = randf_range(0, PI*2)
	var distance = randf_range(min_spawn_distance, max_spawn_distance)
	return player.global_position + Vector2(cos(angle), sin(angle)) * distance

func game_ended():
	game_running = false
	timer.stop()
