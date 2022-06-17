extends KinematicBody2D

enum States {AIR = 1, FLOOR, LADDER, WALL}

var state = States.AIR;

var velocity = Vector2(0,0)
var coins = 0
const SPEED = 210
const RUNSPEED = 400
const GRAVTY = 30
const JUMPFORCE = -1000
const FIREBALL = preload("res://Fireball.tscn")

func _physics_process(delta: float) -> void:
	match state:
		States.AIR:
			if is_on_floor():
				state = States.FLOOR
				continue
			$Sprite.play('air')
#			$SoundJump.play()

			if Input.is_action_pressed("ui_right"):
#				velocity.x=SPEED
				velocity.x=lerp(velocity.x,SPEED,0.1) if velocity.x<=SPEED else lerp(velocity.x,SPEED,0.01)
				$Sprite.flip_h=false
			elif Input.is_action_pressed("ui_left"):
				velocity.x=lerp(velocity.x,-SPEED,0.1) if velocity.x>=-SPEED else lerp(velocity.x,-SPEED,0.01)
				$Sprite.flip_h=true
			else:
				velocity.x=lerp(velocity.x,0,0.2)
			move_and_fall()
			fire()
		States.FLOOR:
			if !is_on_floor():
				state=States.AIR
				continue
			if Input.is_action_pressed("ui_right"):
				if Input.is_action_pressed("run"):
					$Sprite.set_speed_scale(1.8)
					velocity.x=lerp(velocity.x,RUNSPEED,0.1)
				else:
					velocity.x=lerp(velocity.x,SPEED,0.1)
					$Sprite.set_speed_scale(1)
				$Sprite.flip_h=false
				$Sprite.play('walk')
			elif Input.is_action_pressed("ui_left"):
				if Input.is_action_pressed("run"):
					velocity.x=lerp(velocity.x,-RUNSPEED,0.1)
					$Sprite.set_speed_scale(1.8)
				else:
					velocity.x=lerp(velocity.x,-SPEED,0.1)
					$Sprite.set_speed_scale(1.0)
				$Sprite.flip_h=true
				$Sprite.play('walk')
			else:
				$Sprite.play('idle')
				velocity.x=lerp(velocity.x,0,0.2)

			if Input.is_action_just_released("jump"):
				velocity.y=JUMPFORCE
				$SoundJump.play()
				state=States.AIR
				
			move_and_fall()
			fire()
#
#
#	velocity=move_and_slide(velocity,Vector2.UP)
#	velocity.x=lerp(velocity.x,0,0.2)

func fire():
	if(Input.is_action_just_pressed("fire")):
		var f = FIREBALL.instance()
		get_parent().add_child(f)
		f.position.y=position.y
		f.position.x=position.x
	

func move_and_fall():
	velocity.y=velocity.y+GRAVTY
	velocity=move_and_slide(velocity,Vector2.UP)
	

func bounce():
	velocity.y = JUMPFORCE/3
	
func ouch(enemy_posx):
	set_modulate(Color(1,0,0,.5))
	velocity.y = JUMPFORCE/3
	if position.x<enemy_posx:
		velocity.x=-800
	else:
		velocity.x=-800
		
	Input.action_release("ui_left")
	Input.action_release("ui_right")
	
	$Timer.start()
	

func _on_fallZone_body_entered(body: Node) -> void:
#	get_tree().change_scene("res://Level1.tscn")
	get_tree().change_scene("res://GameOver.tscn")
	
	


func _on_Timer_timeout() -> void:
#	get_tree().change_scene("res://Level1.tscn")
	get_tree().change_scene("res://GameOver.tscn")
