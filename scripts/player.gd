extends CharacterBody2D

signal player_collided(body)

var speed : int
var screen_size : Vector2
var can_move : bool
var start_position : Vector2

func _ready():
	screen_size = get_viewport_rect().size
	start_position = screen_size / 2
	position = start_position
	speed = 100
	$DetectionArea.body_entered.connect(_on_body_entered)

func get_input():
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed

func _physics_process(delta):
	get_input()
	move_and_slide()
	if Input.is_action_pressed("up"):
		$AnimatedSprite2D.play("move_up")
	elif Input.is_action_pressed("down"):
		$AnimatedSprite2D.play("move_down")
	elif Input.is_action_pressed("left"):
		$AnimatedSprite2D.play("move_left")
	elif Input.is_action_pressed("right"):
		$AnimatedSprite2D.play("move_right")
	else:
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.frame = 1
		
func _on_body_entered(body):
	emit_signal("player_collided", body)

func reset():
	position = start_position
	velocity = Vector2.ZERO
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.frame = 1
