extends Node2D

@onready var timer := $Timer
@onready var world := $World
@onready var viewer := $Viewer
var started := false
var playing := false

var tile_size = 32


func _ready():
	viewer.change_speed(timer.wait_time / 0.5)


func _input(event):
	if Input.is_action_just_released("faster"):
		timer.wait_time /= 2
		viewer.change_speed(timer.wait_time / 0.5)
	if Input.is_action_just_released("slower"):
		timer.wait_time *= 2
		viewer.change_speed(timer.wait_time / 0.5)

	if Input.is_action_just_released("play"):
		playing = !playing
		timer.start()
	if Input.is_action_just_released("next"):
		world.update()

	if Input.is_action_just_released("add"):
		var cell_coords = floor(get_global_mouse_position() / Vector2(tile_size, tile_size))
		print(cell_coords)
		world.set_cell(1, cell_coords, 0, Vector2i(0, 0))
	if Input.is_action_just_released("remove"):
		var cell_coords = floor(get_global_mouse_position() / Vector2(tile_size, tile_size))
		print(cell_coords)
		world.set_cell(1, cell_coords, 0, Vector2i(1, 0))
	if Input.is_action_just_released("commit"):
		world.commit()


func _on_timer_timeout():
	if playing:
		world.update()
