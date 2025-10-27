extends CharacterBody2D

@export var max_chase_speed : float = 100.0
@export var min_chase_speed : float = 20.0
@export var speed_decay : float = 10.0
@export var wander_speed : float = 20.0
@export var detection_range : float = 200.0
@export var wander_interval : float = 2.0
@export var acceleration : float = 5.0

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var detection_area : Area2D = $DetectionZone

var wander_direction : Vector2 = Vector2.ZERO
var wander_timer : float = 0.0
var current_speed : float = 0.0
var chase_status : bool = false
var game_running : bool = false

func _ready() -> void:
	detection_area.connect("player_detected", Callable(self, "_on_player_detected"))
	detection_area.connect("player_lost", Callable(self, "_on_player_lost"))

func _physics_process(delta):
	if not game_running:
		return
		
	if player and chase_status:
		chase(delta)
	else: 
		wander(delta)

func chase(delta: float):
	if not player:
		return
	var direction : Vector2 = (player.global_position - global_position).normalized()
	current_speed = lerp(current_speed, max_chase_speed, acceleration * delta)
	velocity = direction * current_speed
	move_and_slide()
	current_speed = max(current_speed - speed_decay * delta, min_chase_speed)
		
	if player.global_position.x > global_position.x:
		$AnimatedSprite2D.play("move_right")
	else:
		$AnimatedSprite2D.play("move_left")

func wander(delta):
	wander_timer -= delta
	if wander_timer <= 0.0:
		wander_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
		wander_timer = wander_interval
	velocity = wander_direction * wander_speed
	move_and_slide()
	
	if velocity.x > 0:
		$AnimatedSprite2D.play("move_right")
	elif velocity.x < 0:
		$AnimatedSprite2D.play("move_left")

func _on_player_detected(body: Node) -> void:
	player = body
	chase_status = true
	$boo.play()
	

func _on_player_lost(body: Node) -> void:
	if body == player:
		player = null
		chase_status = false
		current_speed = 0.0

func start_game():
	game_running = true 
