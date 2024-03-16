extends TileMap

var living: Array[Vector2i]
var dead: Array[Vector2i]
var alive_neighbors: int
var past_generation: Array[Vector2i]
var neighbors: Array[Vector2i]
var neighbors_past_generation: Array[Vector2i]

var main_layer := 0
var edit_layer := 1

var cell_ages: Dictionary
var cell_age: float


func uncommitted():
	return not get_used_cells(edit_layer).is_empty()


func is_alive(layer: int, cell: Vector2i):
	return get_cell_atlas_coords(layer, cell) == Vector2i(0, 0)


func get_alive_neighbors(layer: int, cell: Vector2i) -> int:
	var neighbors := 0
	for x in range(cell.x - 1, cell.x + 2):
		for y in range(cell.y - 1, cell.y + 2):
			if not (x == cell.x and y == cell.y):
				if is_alive(layer, Vector2i(x, y)):
					neighbors += 1
	return neighbors


func get_neighbors(layer: int, cell: Vector2i) -> Array[Vector2i]:
	var neighbors: Array[Vector2i]= []
	for x in range(cell.x - 1, cell.x + 2):
		for y in range(cell.y - 1, cell.y + 2):
			if not (x == cell.x and y == cell.y):
				neighbors.append(Vector2i(x,y))

	return neighbors


func commit() -> int:
	for cell in get_used_cells(edit_layer):
		if is_alive(edit_layer, cell):
			set_cell(main_layer, cell, 0, Vector2i(0, 0))

	var changes := len(get_used_cells(edit_layer))

	clear_layer(edit_layer)

	return changes
	

func simulate(past: Array[Vector2i], return_neighbors: bool):
	var neighbors_past: Array[Vector2i] = []

	for cell in past:
		alive_neighbors = get_alive_neighbors(main_layer, cell)
		neighbors = get_neighbors(main_layer, cell)

		if return_neighbors:
			for neighbor_cell in neighbors:
				if neighbor_cell not in past_generation:
					neighbors_past.append(neighbor_cell)

		if is_alive(main_layer, cell):
			if alive_neighbors == 2 or alive_neighbors == 3:
				living.append(cell)
				if return_neighbors:
					if cell_ages.has(cell):
						cell_ages[cell] += 1
					else:
						cell_ages[cell] = 0
		elif alive_neighbors == 3:
			living.append(cell)
		else:
			cell_ages.erase(cell)
		
	if return_neighbors:
		return neighbors_past


func update():
	living = []
	neighbors_past_generation = simulate(get_used_cells(main_layer), true)
	simulate(neighbors_past_generation, false)

	clear()

	for cells in living:
		set_cell(0, cells, 0, Vector2i(0, 0))


func _use_tile_data_runtime_update(layer, coords):
	return cell_ages.has(coords)

func _tile_data_runtime_update(layer, coords, tile_data):
	cell_age = 1.0 - (cell_ages[coords] / 10.0)
	tile_data.modulate = Color(cell_age, 1, cell_age, 1)
	print(tile_data.modulate, coords)
