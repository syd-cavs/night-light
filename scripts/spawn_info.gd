extends Resource

class_name Spawn_info

@export var time_start : int
@export var time_end : int
@export var ghost : PackedScene
@export var ghost_num : int
@export var ghost_spawn_delay : int
@export var candle : PackedScene
@export var candle_spawn_delay : int
@export var candle_num  : int
@export var stump : PackedScene
@export var stump_spawn_delay : int
@export var stump_num  : int

var spawn_delay_counter : int = 0
var spawn_delay_counter2 : int = 0
var spawn_delay_counter3 : int = 0
