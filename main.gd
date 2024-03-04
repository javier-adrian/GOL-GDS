extends Node2D

@onready var timer := $Timer
@onready var world := $World
@onready var viewer := $Viewer
var started := false
var playing := false

var tile_size := 32

var target := Vector2.ZERO
var changes: int

var blueprint_mode := false
var blueprint: TileMapPattern

var wanowan: TileMapPattern = TileMapPattern.new()

# @onready var patterns := {
# 	"blueprint_mode": world.tile_set.get_pattern(0).get_used_cells(),
# 	"glider2": world.tile_set.get_pattern(1).get_used_cells(),
# }


func _ready():
	viewer.change_speed(timer.wait_time / 0.5)
	viewer.update_zoom()
	target = floor(get_global_mouse_position() / Vector2(tile_size, tile_size))
	viewer.update_target(target)
	viewer.update_playing(playing)
	viewer.update_changes(world.uncommitted())

	# var file := FileAccess.open("res://test.pattern", FileAccess.WRITE_READ)
	# file.store_line(var_to_str(patterns))
	# file.close()

	var file := FileAccess.open("res://patterns", FileAccess.READ)
	var text = file.get_file_as_string("res://patterns")
	var patterns = str_to_var(text)
	file.close()

	# for pattern in patterns:
	# 	for active_cell in patterns[pattern]:
	# 		wanowan.set_cell(active_cell, 0, Vector2i(0,0), 0)
	for active_cell in patterns["101"]:
		wanowan.set_cell(active_cell, 0, Vector2i(0,0), 0)
	
	world.tile_set.add_pattern(wanowan, 0)


func _input(event):
	target = floor(get_global_mouse_position() / Vector2(tile_size, tile_size))
	viewer.update_target(target)

	if Input.is_action_just_released("blueprint"):
		blueprint_mode = !blueprint_mode
		if blueprint_mode and not blueprint:
			blueprint = world.tile_set.get_pattern(0)

	if event is InputEventKey and event.is_released() and event.keycode >= KEY_1 and event.keycode <= KEY_9:
		if (event.keycode - KEY_0 - 1) < world.tile_set.get_patterns_count():
			blueprint = world.tile_set.get_pattern(event.keycode - KEY_0 - 1)

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
			if blueprint_mode:
				world.set_pattern(1, target, blueprint)
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
