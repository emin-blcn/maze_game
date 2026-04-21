extends Node2D

@onready var ground_tilemap_node: TileMapLayer = $ground
@onready var wall_tilemap_node: TileMapLayer = $wall



func _ready() -> void:
	draw_grass()
	wall_tilemap_node.set_cells_terrain_connect(Global.maze.generate_maze(41, 41), 0, 0)



func draw_grass() -> void:
	for x in range(0, 41):
		for y in range(0, 8):
			if x == 19 or x == 20 or x == 21 or y == 7:
				continue
			ground_tilemap_node.set_cell(Vector2i(x, y), 0, Vector2i(randi_range(0, 1), randi_range(0, 5)))
	
	for x in range(0, 41):
		for y in range(49, 56):
			if x == 19 or x == 20 or x == 21 or y == 49:
				continue
			ground_tilemap_node.set_cell(Vector2i(x, y), 0, Vector2i(randi_range(0, 1), randi_range(0, 5)))
