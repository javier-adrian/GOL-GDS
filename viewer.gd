extends Camera2D

var pan_mode := false
var mouse_offset = Vector2.ZERO

var commits_template := preload("res://commits_template.tscn")

func change_speed(speed: float):
	$UserInterface/MarginContainer/VBoxContainer/Speed.text = "Speed: " + str(speed) + "x"

func update_zoom():
	$UserInterface/MarginContainer/VBoxContainer/Zoom.text = "Zoom: " + str(zoom.x) + "x"

func update_target(coords: Vector2):
	$UserInterface/MarginContainer/VBoxContainer/Target.text = "X/Y: " + str(coords.x) + " / " + str(coords.y)

func update_playing(playing: bool):
	$UserInterface/Playing.visible = playing

func update_changes(changes: bool):
	$UserInterface/Changes.visible = changes
	
func update_commits(changes: int):
	var commit_label := commits_template.instantiate()
	commit_label.text = str(changes) + " changes committed."
	$UserInterface/Committed/VBoxContainer.add_child(commit_label)
	var commit_labels := $UserInterface/Committed/VBoxContainer.get_children()

	var commit_object := commit_labels[commit_labels.size() - 1]

	var tween = create_tween()
	tween = tween.tween_property(commit_object, "modulate", Color(1, 1, 1, 0), 3)

	tween.finished.connect(delete_last_commit)

func delete_last_commit():
	var commit_labels := $UserInterface/Committed/VBoxContainer.get_children()

	# the tween signals get mangled when commit is spammed
	# hence the purpose of why the following way of culling labels is done.

	for commit_object in commit_labels:
		if commit_object.modulate == Color(1, 1, 1, 0):
			commit_object.queue_free()

##TODO
## edit and play mode should be exclusive to each other
## ui for edit and play mode

func _input(event):
	if Input.is_action_just_released("zoom in") and not pan_mode:
		zoom *= 2
		update_zoom()
	if Input.is_action_just_released("zoom out") and not pan_mode:
		zoom /= 2
		update_zoom()

	if Input.is_action_just_pressed("pan"):
		pan_mode = true
		mouse_offset = get_global_mouse_position()
	if Input.is_action_just_released("pan"):
		pan_mode = false

	if pan_mode:
		position -= get_global_mouse_position() - mouse_offset
	
	if Input.is_action_just_released("toggle ui"):
		$UserInterface.visible = !$UserInterface.visible
