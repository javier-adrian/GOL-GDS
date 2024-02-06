extends TileMap

var living: Array[Vector2i]
var dead: Array[Vector2i]
var cell: Vector2i
var neighbors: int

var main_layer := 0
var edit_layer := 1


func is_alive(layer: int, cell: Vector2i):
	return get_cell_atlas_coords(layer, cell) == Vector2i(0, 0)


func get_neighbors(layer: int, cell: Vector2i) -> int:
	var neighbors = 0
	for x in range(cell.x - 1, cell.x + 2):
		for y in range(cell.y - 1, cell.y + 2):
			if not (x == cell.x and y == cell.y):
				if is_alive(layer, Vector2i(x, y)):
					neighbors += 1
	return neighbors


func commit():
	for cell in get_used_cells(edit_layer):
		if is_alive(edit_layer, cell):
			set_cell(main_layer, cell, 0, Vector2i(0, 0))


func update():
	living = []

	for x in range(16):
		for y in range(16):
			cell = Vector2i(x, y)
			neighbors = get_neighbors(main_layer, cell)
			if is_alive(main_layer, cell):
				if neighbors == 2 or neighbors == 3:
					living.append(cell)
				else:
					dead.append(cell)
			elif neighbors == 3:
				living.append(cell)
			else:
				dead.append(cell)

	clear()

	for cells in dead:
		set_cell(0, cells, 0, Vector2i(1, 0))
	for cells in living:
		set_cell(0, cells, 0, Vector2i(0, 0))


func _ready():
	for x in range(16):
		for y in range(16):
			cell = Vector2i(x, y)
			if is_alive(main_layer, cell):
				living.append(cell)
			else:
				dead.append(cell)

	for cells in dead:
		set_cell(0, cells, 0, Vector2i(1, 0))
	for cells in living:
		set_cell(0, cells, 0, Vector2i(0, 0))
