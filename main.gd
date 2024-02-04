extends Node2D

@onready var timer := $Timer
@onready var ui := $UserInterface
@onready var world := $World
@onready var camera := $Camera2D
var started := false
var playing := false
var pan_mode := false

var tile_size = 32

var offset = Vector2.ZERO


func _ready():
	ui.change_speed(timer.wait_time / 0.5)


func _input(event):
	if Input.is_action_just_released("faster"):
		timer.wait_time /= 2
		ui.change_speed(timer.wait_time / 0.5)
	if Input.is_action_just_released("slower"):
		timer.wait_time *= 2
		ui.change_speed(timer.wait_time / 0.5)

	if Input.is_action_just_released("play"):
		playing = !playing
		timer.start()
	if Input.is_action_just_released("next"):
		world.update()

	if Input.is_action_just_released("add"):
		var cell_coords = floor(get_viewport().get_mouse_position() / Vector2(tile_size, tile_size))
		world.set_cell(1, cell_coords, 0, Vector2i(0, 0))
	if Input.is_action_just_released("remove"):
		var cell_coords = floor(get_viewport().get_mouse_position() / Vector2(tile_size, tile_size))
		world.set_cell(1, cell_coords, 0, Vector2i(1, 0))
	if Input.is_action_just_released("commit"):
		world.commit()

	if Input.is_action_just_released("zoom in") and not pan_mode:
		camera.zoom *= 2
	if Input.is_action_just_released("zoom out") and not pan_mode:
		camera.zoom /= 2
	
	if Input.is_action_just_pressed("pan"):
		pan_mode = true
		offset = get_global_mouse_position()
	if Input.is_action_just_released("pan"):
		pan_mode = false
	
	if pan_mode:
		camera.position -= get_global_mouse_position() - offset

func _on_timer_timeout():
	if playing:
		world.update()
