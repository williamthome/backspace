extends Node

func _on_player_speed_changed(speed: float):
	get_node("CanvasLayer/SpeedLabel").text = "%d" % speed
