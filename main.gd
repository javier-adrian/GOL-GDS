extends Node2D

@onready var timer := $Timer
@onready var world := $World
@onready var viewer := $Viewer
var started := false
var playing := false

var tile_size := 32

var target := Vector2.ZERO
var changes: int

var glider := false


func _ready():
	viewer.change_speed(timer.wait_time / 0.5)
	viewer.update_zoom()
	target = floor(get_global_mouse_position() / Vector2(tile_size, tile_size))
	viewer.update_target(target)
	viewer.update_playing(playing)
	viewer.update_changes(world.uncommitted())


func _input(event):
	target = floor(get_global_mouse_position() / Vector2(tile_size, tile_size))
	viewer.update_target(target)

	if Input.is_action_just_released("glider"):
		glider = !glider

	if Input.is_action_just_released("faster"):
		timer.wait_time /= 2
		viewer.change_speed(1 / (timer.wait_time / 0.5))
	if Input.is_action_just_released("slower"):
		timer.wait_time *= 2
		viewer.change_speed(1 / (timer.wait_time / 0.5))

	if Input.is_action_just_released("play"):
		playing = !playing
		timer.start()
		viewer.update_playing(playing)
		viewer.update_commits(len(world.get_used_cells(1)), true)
		world.clear_layer(1)
	if Input.is_action_just_released("next"):
		world.update()
	
	if not playing:
		if Input.is_action_just_released("add"):
			if glider:
				world.set_pattern(1, target, world.tile_set.get_pattern(1))
			else:
				world.set_cell(1, target, 0, Vector2i(0, 0))
		if Input.is_action_just_released("remove"):
			world.set_cell(1, target)
		if Input.is_action_just_released("commit"):
			viewer.update_commits(world.commit(), false)
	viewer.update_changes(world.uncommitted())


func _on_timer_timeout():
	if playing:
		world.update()
