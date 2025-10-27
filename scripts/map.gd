extends Node2D

@onready var tilemap: TileMap = $TileMap
@onready var visibility_notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

const terrain_layer_id = 0
const chunk_size = 32

func get


func generate_terrain(pos: Vector2i, tile: Vector2i) -> void:
	var player_position = _get_player_position()
	for i in range(-chunk_size * 2, chunk_size * 2):
		for j in range(-chunk_size * 2, chunk_size * 2):
			var position = player_position + Vector2i(i, j)
			if _is_empty(pos):
				populate_chunk(pos, _pick_random_tile())

func generate_chunk(pos: Vector2i, tile: Vector2i) -> void:
	tilemap.set_cell.call_deferred(
		terrain_layer_id, pos, terrain_source_id, tile, alternative_tile_id
	)

func exit_chunk():
	visibility_notifier.global_position = (
		get_tree().get_first_node_in_group(Player.group).global_position
	)

func delete_chunk(player_position: Vector2i) -> void:
	var used_cells = tilemap.get_used_cells_by_id(terrain_layer_id)
	for cell in used_cells:
		if not _is_near_player(cell, player_position):
			tilemap.set_cell.call_deferred(terrain_layer_id, cell)
