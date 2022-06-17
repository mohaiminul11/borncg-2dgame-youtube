extends Area2D

signal coin_collected

func _on_coin_body_entered(body: Node) -> void:
#	queue_free()
	$AnimationPlayer.play("bounce");
#	player=body;
	emit_signal("coin_collected")
	set_collision_mask_bit(0,0)
	$SoundCoinCollected.play()



func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
#	player.add_coin();
	queue_free();
