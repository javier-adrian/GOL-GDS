extends Node2D

@onready var timer := $Timer
@onready var ui := $UserInterface


func _ready():
	ui.change_speed(timer.wait_time / 0.5)


func _input(event):
	if Input.is_action_just_released("faster"):
		timer.wait_time /= 2
		ui.change_speed(timer.wait_time / 0.5)
	if Input.is_action_just_released("slower"):
		timer.wait_time *= 2
		ui.change_speed(timer.wait_time / 0.5)
