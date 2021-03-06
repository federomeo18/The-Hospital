extends KinematicBody2D

export (int) var speed
export (PackedScene) var can
export (PackedScene) var brick

export var noiselevel = 0
var can_move = true

var can_hide = false
var can_enter_blue = false
var can_enter_red = false
var in_puddle = false
var is_hidden = false
var velocity = Vector2()
var nomaterial = null
var can_move_left = true

var attackblink = preload("res://assets/MC/MainChar.tres")

signal playerattack
signal playerhidden
signal noiselevelchanged(noiselevel)

onready var ray:=$RayCastFront

func start(pos):
	position = pos

func _ready():
	$AnimatedSprite.material = nomaterial

func _process(delta):
	if Scene_handler.cut_scene == false:
		get_input()
		_check_shaders()
		shoot_can()
		position += velocity * delta
	else:
		_cutscene_handler()

func _unhandled_input(event):
	if event.is_action_pressed("Action") && ray.is_colliding():
		if Scene_handler.weapon[1] == true:
			$AnimatedSprite.play("knife")
			emit_signal("playerattack")
			can_move = false
			$Attack.play()
			yield($AnimatedSprite, "animation_finished" )
			Scene_handler.weapon[1] = false
			$AnimatedSprite.play("idle")
			can_move = true
		if Scene_handler.weapon[2] == true:
			$AnimatedSprite.play("pipe")
			emit_signal("playerattack")
			can_move = false
			$Attack.play()
			yield($AnimatedSprite, "animation_finished" )
			Scene_handler.weapon[2] = false
			$AnimatedSprite.play("idle")
			can_move = true
		if Scene_handler.weapon[3] == true:
			$AnimatedSprite.play("syringe")
			emit_signal("playerattack")
			can_move = false
			$Attack.play()
			yield($AnimatedSprite, "animation_finished" )
			Scene_handler.weapon[3] = false
			$AnimatedSprite.play("idle")
			can_move = true

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("Run") && (Input.is_action_pressed("Left") || Input.is_action_pressed("Right")) && is_hidden == false && in_puddle == false:
		speed = 80
		noiselevel = 80
		emit_signal("noiselevelchanged",noiselevel)
		$Normal_Step.volume_db = 10
		if not $Normal_Step.is_playing():
			$Normal_Step.play()
	elif Input.is_action_pressed("Run") && (Input.is_action_pressed("Left") || Input.is_action_pressed("Right")) && is_hidden == false && in_puddle == true:
		speed = 80
		noiselevel = 100
		emit_signal("noiselevelchanged",noiselevel)
		$Water_Step.volume_db = 10
		if not $Water_Step.is_playing():
			$Water_Step.play()
	elif Input.is_action_pressed("Crouch") && (Input.is_action_pressed("Left") || Input.is_action_pressed("Right")) && is_hidden == false && in_puddle == false:
		speed = 40
		noiselevel = 20
		emit_signal("noiselevelchanged",noiselevel)
		$Normal_Step.volume_db = -10
		if not $Normal_Step.is_playing():
			$Normal_Step.play()
	elif Input.is_action_pressed("Crouch") && (Input.is_action_pressed("Left") || Input.is_action_pressed("Right")) && is_hidden == false && in_puddle == true:
		speed = 40
		noiselevel = 50
		emit_signal("noiselevelchanged",noiselevel)
		$Water_Step.volume_db = -5
		if not $Water_Step.is_playing():
			$Water_Step.play()
	elif (!Input.is_action_pressed("Run") || !Input.is_action_pressed("Crouch")) && (Input.is_action_pressed("Left") || Input.is_action_pressed("Right")) && is_hidden == false && in_puddle == false:
		speed = 60
		noiselevel = 50
		emit_signal("noiselevelchanged",noiselevel)
		$Normal_Step.volume_db = 0
		if not $Normal_Step.is_playing():
			$Normal_Step.play()
	elif (!Input.is_action_pressed("Run") || !Input.is_action_pressed("Crouch")) && (Input.is_action_pressed("Left") || Input.is_action_pressed("Right")) && is_hidden == false && in_puddle == true:
		speed = 60
		noiselevel = 80
		emit_signal("noiselevelchanged",noiselevel)
		$Water_Step.volume_db = 2
		if not $Water_Step.is_playing():
			$Water_Step.play()
	else:
		speed = 40
		noiselevel = 0
		emit_signal("noiselevelchanged",noiselevel)
		$Normal_Step.stop()
	if Input.is_action_pressed("Left") && is_hidden == false && can_move == true:
		velocity.x -= 1
		$AnimatedSprite.flip_h = true
		$RayCastFront.cast_to = Vector2(-20,0)
		if ($Camera2D.offset.x > -60):
			$Camera2D.offset.x -= 0.5
		if Input.is_action_pressed("Crouch"):
			$AnimatedSprite.play("crouching")
		else:
			$AnimatedSprite.play("walking")
	elif Input.is_action_pressed("Right") && is_hidden == false && can_move == true:
		velocity.x += 1
		$AnimatedSprite.flip_h = false
		$RayCastFront.cast_to = Vector2(20,0)
		if ($Camera2D.offset.x < 60):
			$Camera2D.offset.x += 0.5
		if Input.is_action_pressed("Crouch"):
			$AnimatedSprite.play("crouching")
		else:
			$AnimatedSprite.play("walking")
	elif (!Input.is_action_pressed("Left") or !Input.is_action_pressed("Right")) && Scene_handler.cut_scene == false:
		speed = 0
		noiselevel = 0
		if is_hidden == false && !Input.is_action_pressed("Crouch") && can_move == true:
			$AnimatedSprite.play("idle")
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	if Input.is_action_pressed("Up") && can_hide == true:
		is_hidden = true
		emit_signal("playerhidden",is_hidden)
		$AnimatedSprite.play("hiding")
	if Input.is_action_pressed("Up") && can_enter_blue == true:
		if Scene_handler.current_level == 2:
			Scene_handler.current_level = 3
		elif Scene_handler.current_level == 3:
			Scene_handler.current_level = 2
		Scene_handler.next_level()
	if Input.is_action_pressed("Up") && can_enter_red == true && Scene_handler.keys[0] == true:
		Scene_handler.current_level = 4
		Scene_handler.next_level()
	if Input.is_action_pressed("Down") && is_hidden == true:
		$AnimatedSprite.play("unhide")
		yield($AnimatedSprite, "animation_finished" )
		is_hidden = false
		emit_signal("playerhidden",is_hidden)
		$AnimatedSprite.play("idle")

func _on_MainChar_area_entered(area):
	if area.is_in_group("bluedoor"):
		can_enter_blue = true
	if area.is_in_group("reddoor"):
		can_enter_red = true
	if area.is_in_group("doors"):
		can_hide = true
	if area.is_in_group("endhallway"):
		Scene_handler.current_level = 5
		Scene_handler.next_level()
	if area.is_in_group("scalpel"):
		Scene_handler.weapon[0] = false
		Scene_handler.weapon[1] = true
		area._pickup()
		$Pickup.play()
	if area.is_in_group("redkey"):
		Scene_handler.keys[0] = true
		area._pickup()
		$Pickup.play()
	if area.is_in_group("pipe"):
		Scene_handler.weapon[0] = false
		Scene_handler.weapon[2] = true
		area._pickup()
		$Pickup.play()
	if area.is_in_group("syringe"):
		Scene_handler.weapon[0] = false
		Scene_handler.weapon[3] = true
		area._pickup()
		$Pickup.play()
	if area.is_in_group("brick"):
		Scene_handler.weapon[0] = false
		Scene_handler.weapon[4] = true
		area._pickup()
		$Pickup.play()
	if area.is_in_group("can"):
		Scene_handler.weapon[0] = false
		Scene_handler.weapon[5] = true
		area._pickup()
		$Pickup.play()
	if area.is_in_group("cutscene"):
		area._end()
	if area.is_in_group("lateral"):
		Scene_handler.current_level = 1
		Scene_handler.next_level()
	if area.is_in_group("hallway"):
		Scene_handler.current_level = 2
		Scene_handler.next_level()
	if area.is_in_group("puddle"):
		in_puddle = true
	if area.is_in_group("leftwall"):
		#velocity.x += 1
		speed
		print("Wall")

func _on_MainChar_area_exited(area):
	if area.is_in_group("doors"):
		can_hide = false
	if area.is_in_group("bluedoor"):
		can_enter_blue = false
	if area.is_in_group("reddoor"):
		can_enter_red = false
	if area.is_in_group("puddle"):
		in_puddle = false
		if $Water_Step.is_playing():
			$Water_Step.stop()

func _check_shaders():
	if ray.is_colliding() && (Scene_handler.weapon[1] || Scene_handler.weapon[2] || Scene_handler.weapon[3]):
		$AnimatedSprite.material = attackblink
	else:
		$AnimatedSprite.material = nomaterial

func _on_Enemy1_enemyattack():
	visible = false
	can_move = false
	ray.enabled = false
	Scene_handler.current_level = Scene_handler.current_level
	yield(get_tree().create_timer(2), 'timeout')
	Scene_handler.next_level()

func shoot_can():
	if Input.is_action_pressed("Action") && Scene_handler.weapon[5] == true:
		can_move = false
		Scene_handler.weapon[5] = false
		var can_instance = can.instance()
		can_instance.position.x = get_global_position().x
		can_instance.position.y = get_global_position().y - 15
		if $AnimatedSprite.flip_h == false:
			can_instance.rotation = get_angle_to(Vector2(5760,0))
		else:
			can_instance.rotation = get_angle_to(Vector2(90,0))
		$AnimatedSprite.play("throwing")
		yield($AnimatedSprite, "animation_finished")
		get_parent().add_child(can_instance)
		can_move = true
		$AnimatedSprite.play("idle")
		yield(get_tree().create_timer(2.6), 'timeout')
		$Can.play()
	if Input.is_action_pressed("Action") && Scene_handler.weapon[4] == true:
		can_move = false
		Scene_handler.weapon[4] = false
		var brick_instance = brick.instance()
		brick_instance.position.x = get_global_position().x
		brick_instance.position.y = get_global_position().y - 15
		if $AnimatedSprite.flip_h == false:
			brick_instance.rotation = get_angle_to(Vector2(5760,0))
		else:
			brick_instance.rotation = get_angle_to(Vector2(90,0))
		$AnimatedSprite.play("throwing")
		yield($AnimatedSprite, "animation_finished")
		get_parent().add_child(brick_instance)
		can_move = true
		$AnimatedSprite.play("idle")
		yield(get_tree().create_timer(2.6), 'timeout')
		$Can.play()


func _on_Cutscene_Trigger_area_entered(area):
	Scene_handler.cut_scene = true
	
func _cutscene_handler():
	if !Scene_handler.cut_scene_n == 5:
		$AnimatedSprite.play("idle")
	if Input.is_action_pressed("Action"):
		Scene_handler.cut_scene = false