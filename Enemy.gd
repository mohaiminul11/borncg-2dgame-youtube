extends KinematicBody2D
var speed=50
var velocity = Vector2() 
export var direction = "left";
export var detects_cliffs = true;

func _ready() -> void:
	if direction=='right':
		$AnimatedSprite.flip_h=true;
	$FloorChecker.enabled = detects_cliffs;
	
	if(!detects_cliffs):
		set_modulate(Color(1,.7,.0,1))

func handle_enemy_direction(first=true):
		if direction =="left":
			if(!first):
				direction="right"
			$FloorChecker.position.x=$CollisionShape2D.shape.get_extents().x;
		elif direction =="right":
			if(!first):
				direction="left"
			$FloorChecker.position.x=-$CollisionShape2D.shape.get_extents().x;

func _physics_process(delta: float) -> void:
	#	is_on_wall() detects-> crash to wall
	if is_on_wall() || (detects_cliffs && !$FloorChecker.is_colliding() && is_on_floor()):
		handle_enemy_direction(false);
#		print(direction)

			
		$AnimatedSprite.flip_h=!$AnimatedSprite.flip_h
#		print(direction)
	
	velocity.y+=20
	
	if(direction=='left'):
		velocity.x=-speed;
	elif(direction=='right'):
		velocity.x=speed;
#	print(velocity.x)
	velocity = move_and_slide(velocity,Vector2.UP)
#	print(velocity)


func _on_TopChecker_body_entered(body: Node) -> void:
	$AnimatedSprite.play('squashed')
	speed=0
	set_collision_layer_bit(4,false)
	set_collision_mask_bit(0,false)
	$TopChecker.set_collision_layer_bit(4,false)
	$TopChecker.set_collision_mask_bit(0,false)
	$sides_checker.set_collision_layer_bit(4,false)
	$sides_checker.set_collision_mask_bit(0,false)
	$Timer.start()
	if body.name=='Sumon':
		body.bounce()
	$SoundSquash.play()
		

	


func _on_sides_checker_body_entered(body: Node) -> void:
#	print('entered!!')
#	get_tree().change_scene("res://Level1.tscn")
	if body.name=='Sumon':
		body.ouch(position.x);


func _on_Timer_timeout() -> void:
	queue_free()
