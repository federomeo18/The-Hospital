extends Area2D

export (int) var speed
export (PackedScene) var can

var noiselevel = 0
var can_move = true
var weapon = [true, false, false, false, false, false]
#0 = no weapon, 1 = scalpel, 2 = pipe, 3 = needle, 4 = brick, 5 = can

var direction = 0

var can_hide = false
var is_hidden = false
var velocity = Vector2()
var nomaterial = null

var attackblink = preload("res://assets/MC/MainChar.tres")
#var can = preload("res://assets/Weapons/Can/Can.tscn")

signal playerattack
signal playerhidden
signal noiselevelchanged(noiselevel)

onready var ray:=$RayCastFront

func start(pos):
	position = pos

func _ready():
	$AnimatedSprite.material = nomaterial

func _process(delta):
	get_input()
	_check_shaders()
	shoot_can()
	position += velocity * delta

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") && ray.is_colliding():
		if weapon[1] == true:
			$AnimatedSprite.play("knife")
			emit_signal("playerattack")
			can_move = false
			yield($AnimatedSprite, "animation_finished" )
			$AnimatedSprite.play("idle")
			can_move = true

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("ui_lshift") && (Input.is_action_pressed("ui_left") || Input.is_action_pressed("ui_right")) && is_hidden == false:
		speed = 80
		noiselevel = 80
		emit_signal("noiselevelchanged",noiselevel)
	elif Input.is_action_pressed("ui_lctrl") && (Input.is_action_pressed("ui_left") || Input.is_action_pressed("ui_right")) && is_hidden == false:
		speed = 40
		noiselevel = 20
		emit_signal("noiselevelchanged",noiselevel)
	elif (!Input.is_action_pressed("ui_lshift") || !Input.is_action_pressed("ui_lctrl")) && (Input.is_action_pressed("ui_left") || Input.is_action_pressed("ui_right")) && is_hidden == false:
		speed = 60
		noiselevel = 50
		emit_signal("noiselevelchanged",noiselevel)
	else:
		speed = 40
		noiselevel = 0
		emit_signal("noiselevelchanged",noiselevel)
	if Input.is_action_pressed("ui_left") && is_hidden == false && can_move == true:
		velocity.x -= 1
		$AnimatedSprite.flip_h = true
		$RayCastFront.cast_to = Vector2(-20,0)
		if Input.is_action_pressed("ui_lctrl"):
			$AnimatedSprite.play("crouching")
		else:
			$AnimatedSprite.play("walking")
	elif Input.is_action_pressed("ui_right") && is_hidden == false && can_move == true:
		velocity.x += 1
		$AnimatedSprite.flip_h = false
		$RayCastFront.cast_to = Vector2(20,0)
		if Input.is_action_pressed("ui_lctrl"):
			$AnimatedSprite.play("crouching")
		else:
			$AnimatedSprite.play("walking")
	elif !Input.is_action_pressed("ui_left") or !Input.is_action_pressed("ui_right"):
		speed = 0
		noiselevel = 0
		if is_hidden == false && !Input.is_action_pressed("ui_lctrl") && can_move == true:
			$AnimatedSprite.play("idle")
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	if Input.is_action_pressed("ui_up") && can_hide == true:
		is_hidden = true
		emit_signal("playerhidden",is_hidden)
		$AnimatedSprite.play("hiding")
	if Input.is_action_pressed("ui_down") && is_hidden == true:
		$AnimatedSprite.play("unhide")
		yield($AnimatedSprite, "animation_finished" )
		is_hidden = false
		emit_signal("playerhidden",is_hidden)
		$AnimatedSprite.play("idle")

func _on_MainChar_area_entered(area):
	if area.is_in_group("doors"):
		can_hide = true
	if area.is_in_group("scalpel"):
		weapon[0] = false
		weapon[1] = true
		area._pickup()
	if area.is_in_group("can"):
		weapon[0] = false
		weapon[5] = true
		area._pickup()
	if area.is_in_group("brick"):
		weapon[0] = false
		weapon[4] = true
		area._pickup()

func _on_MainChar_area_exited(area):
	if area.is_in_group("doors"):
		can_hide = false

func _check_shaders():
	if ray.is_colliding() && (weapon[1] || weapon[2] || weapon[3]):
		$AnimatedSprite.material = attackblink
	else:
		$AnimatedSprite.material = nomaterial

func _on_Enemy1_enemyattack():
	visible = false
	can_move = false
	ray.enabled = false

func shoot_can():
	if Input.is_action_pressed("ui_accept") && weapon[5] == true:
		can_move = false
		weapon[5] = false
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