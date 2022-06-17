extends CanvasLayer

var coins = 0

func _ready() -> void:
	$Coins.text=String(coins)


func _on_coin_collected() -> void:
	coins+=1
	$Coins.text=String(coins)
	if coins == 5:
#		get_tree().change_scene("res://Level1.tscn")
		get_tree().change_scene("res://YouWin!.tscn")
		

