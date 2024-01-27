extends Control


func change_speed(speed: float):
	$MarginContainer/VBoxContainer/Speed.text = "Wait Time: " + str(speed)
