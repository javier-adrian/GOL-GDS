extends TileMap

var living: Array[Vector2i]
var dead: Array[Vector2i]
var cell: Vector2i
var neighbors: int
var playing := false
var speed: float

@export var timer: Timer


func is_alive(cell: Vector2i):
	return get_cell_atlas_coords(0, cell) == Vector2i(0, 0)


func get_neighbors(cell: Vector2i) -> int:
	var neighbors = 0
	for x in range(cell.x - 1, cell.x + 2):
		for y in range(cell.y - 1, cell.y + 2):
			if not (x == cell.x and y == cell.y):
				if is_alive(Vector2i(x, y)):
					neighbors += 1
	return neighbors


func update():
	living = []

	for x in range(16):
		for y in range(16):
			cell = Vector2i(x, y)
			neighbors = get_neighbors(cell)
			if is_alive(cell):
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


func _on_timer_timeout():
	if playing:
		update()


func _ready():
	speed = timer.wait_time

	for x in range(16):
		for y in range(16):
			cell = Vector2i(x, y)
			if is_alive(cell):
				living.append(cell)
			else:
				dead.append(cell)

	for cells in dead:
		set_cell(0, cells, 0, Vector2i(1, 0))
	for cells in living:
		set_cell(0, cells, 0, Vector2i(0, 0))

	timer.start()


func _input(event):
	if Input.is_action_just_released("play"):
		playing = false if playing else true
	if Input.is_action_just_released("next"):
		update()
