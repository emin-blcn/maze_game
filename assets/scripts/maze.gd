class_name Maze extends RefCounted

var maze_floors: Dictionary[Vector2i, bool] = {}
var maze_visited: Dictionary[Vector2i, bool] = {}



func generate_maze(width: int, height: int) -> Array[Vector2i]:
	maze_floors.clear()
	maze_visited.clear()
	
	var mid_x: int = width / 2
	
	maze_floors[Vector2i(mid_x, 0)] = true
	maze_floors[Vector2i(mid_x, 1)] = true
	maze_floors[Vector2i(mid_x, height - 1)] = true
	maze_floors[Vector2i(mid_x, height - 2)] = true
	
	var start_x: int = mid_x
	if start_x % 2 == 0:
		start_x -= 1
	
	var start: Vector2i = Vector2i(start_x, 1)
	maze_floors[start] = true
	maze_floors[Vector2i(mid_x, 1)] = true
	
	_generate_dfs(start, width, height)
	_open_extra_connections(width, height)
	
	var end: Vector2i = Vector2i(start_x, height - 2)
	maze_floors[end] = true
	maze_floors[Vector2i(mid_x, height - 2)] = true
	
	var walls: Array[Vector2i] = []
	
	for y in range(height):
		for x in range(width):
			var pos: Vector2i = Vector2i(x, y)
			if not maze_floors.has(pos):
				walls.append(pos)
	
	return walls



func _generate_dfs(start: Vector2i, width: int, height: int) -> void:
	var stack: Array[Vector2i] = []
	stack.append(start)
	maze_visited[start] = true
	
	while stack.size() > 0:
		var current: Vector2i = stack[-1]
		var neighbors: Array[Vector2i] = _get_unvisited_neighbors(current, width, height)
	
		if neighbors.is_empty():
			stack.pop_back()
			continue
	
		neighbors.shuffle()
		var next: Vector2i = neighbors[0]
		var between: Vector2i = Vector2i(
			current.x + (next.x - current.x) / 2,
			current.y + (next.y - current.y) / 2
		)
	
		maze_floors[between] = true
		maze_floors[next] = true
		maze_visited[next] = true
		stack.append(next)



func _get_unvisited_neighbors(cell: Vector2i, width: int, height: int) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	var directions: Array[Vector2i] = [
		Vector2i(0, -2),
		Vector2i(2, 0),
		Vector2i(0, 2),
		Vector2i(-2, 0)
	]
	
	for dir in directions:
		var next: Vector2i = cell + dir
	
		if _is_valid_maze_cell(next, width, height) and not maze_visited.has(next):
			result.append(next)
	
	return result



func _is_valid_maze_cell(pos: Vector2i, width: int, height: int) -> bool:
	if pos.x <= 0 or pos.y <= 0 or pos.x >= width - 1 or pos.y >= height - 1:
		return false
	
	return pos.x % 2 == 1 and pos.y % 2 == 1



func _get_open_rate() -> float:
	var t := float(Global.data["difficulty"] - 1) / 9.0
	return lerp(0.25, 0.0, t)



func _open_extra_connections(width: int, height: int) -> void:
	var open_rate: float = _get_open_rate()
	
	for y in range(1, height - 1):
		for x in range(1, width - 1):
			var pos := Vector2i(x, y)
	
			if maze_floors.has(pos):
				continue
	
			var is_vertical_wall := pos.x % 2 == 1 and pos.y % 2 == 0
			var is_horizontal_wall := pos.x % 2 == 0 and pos.y % 2 == 1
	
			if not is_vertical_wall and not is_horizontal_wall:
				continue
	
			if randf() > open_rate:
				continue
	
			if is_vertical_wall:
				var up := Vector2i(x, y - 1)
				var down := Vector2i(x, y + 1)
	
				if maze_floors.has(up) and maze_floors.has(down):
					if _would_create_2x2_floor(pos):
						continue
					if _would_create_wide_vertical(pos):
						continue
					maze_floors[pos] = true
	
			elif is_horizontal_wall:
				var left := Vector2i(x - 1, y)
				var right := Vector2i(x + 1, y)
	
				if maze_floors.has(left) and maze_floors.has(right):
					if _would_create_2x2_floor(pos):
						continue
					if _would_create_wide_horizontal(pos):
						continue
					maze_floors[pos] = true



func _would_create_2x2_floor(pos: Vector2i) -> bool:
	var checks: Array[Array] = [
		[pos, pos + Vector2i(-1, 0), pos + Vector2i(0, -1), pos + Vector2i(-1, -1)],
		[pos, pos + Vector2i(1, 0), pos + Vector2i(0, -1), pos + Vector2i(1, -1)],
		[pos, pos + Vector2i(-1, 0), pos + Vector2i(0, 1), pos + Vector2i(-1, 1)],
		[pos, pos + Vector2i(1, 0), pos + Vector2i(0, 1), pos + Vector2i(1, 1)]
	]
	
	for group in checks:
		var all_floor := true
		for p in group:
			if p == pos:
				continue
			if not maze_floors.has(p):
				all_floor = false
				break
		if all_floor:
			return true
	
	return false



func _would_create_wide_horizontal(pos: Vector2i) -> bool:
	if maze_floors.has(Vector2i(pos.x - 1, pos.y)) and maze_floors.has(Vector2i(pos.x + 1, pos.y)):
		if maze_floors.has(Vector2i(pos.x - 1, pos.y - 1)) and maze_floors.has(Vector2i(pos.x + 1, pos.y - 1)):
			return true
		if maze_floors.has(Vector2i(pos.x - 1, pos.y + 1)) and maze_floors.has(Vector2i(pos.x + 1, pos.y + 1)):
			return true
	return false



func _would_create_wide_vertical(pos: Vector2i) -> bool:
	if maze_floors.has(Vector2i(pos.x, pos.y - 1)) and maze_floors.has(Vector2i(pos.x, pos.y + 1)):
		if maze_floors.has(Vector2i(pos.x - 1, pos.y - 1)) and maze_floors.has(Vector2i(pos.x - 1, pos.y + 1)):
			return true
		if maze_floors.has(Vector2i(pos.x + 1, pos.y - 1)) and maze_floors.has(Vector2i(pos.x + 1, pos.y + 1)):
			return true
	return false
