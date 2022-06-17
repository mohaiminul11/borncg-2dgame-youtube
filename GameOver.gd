extends Control


func _ready() -> void:
	$Timer.start()


func _on_Timer_timeout() -> void:
	get_tree().change_scene("res://TitleMenu.tscn")
