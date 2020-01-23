extends Area2D

export (int) var speed
var noiselevel = 0
#var can_move = true
#var can_attack = true
var can_hide = false
var is_hidden = false
var velocity = Vector2()
var nomaterial = null
var step_animation = false
var attackblink = preload("res://assets/MC/MainChar.tres")

signal playerattack
signal noiselevelchanged(noiselevel)

onready var ray:=$RayCastFront

func start(pos):
	position = pos

func _ready():
	$AnimatedSprite.material = nomaterial

func _process(delta):
	get_input()
	_check_shaders()
	_check_animation()
	position += velocity * delta

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") && ray.is_colliding():
		emit_signal("playerattack")

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("ui_lshift") && (Input.is_action_pressed("ui_left") || Input.is_action_pressed("ui_right")) && is_hidden == false:
		speed = 80
		noiselevel = 80
		emit_signal("noiselevelchanged",noiselevel)
	elif Input.is_action_pressed("ui_lctrl") && (Input.is_action_pressed("ui_left") || Input.is_action_pressed("ui_right")) && is_hidden == false:
		speed = 20
		noiselevel = 20
		emit_signal("noiselevelchanged",noiselevel)
	elif (!Input.is_action_pressed("ui_lshift") || !Input.is_action_pressed("ui_lctrl")) && (Input.is_action_pressed("ui_left") || Input.is_action_pressed("ui_right")) && is_hidden == false:
		speed = 40
		noiselevel = 50
		emit_signal("noiselevelchanged",noiselevel)
	else:
		speed = 40
		noiselevel = 0
		emit_signal("noiselevelchanged",noiselevel)
	if Input.is_action_pressed("ui_left") && is_hidden == false:
		velocity.x -= 1
		$AnimatedSprite.flip_h = true
		step_animation = true
		$RayCastFront.cast_to = Vector2(-20,0)
	elif Input.is_action_pressed("ui_right") && is_hidden == false:
		velocity.x += 1
		$AnimatedSprite.flip_h = false
		step_animation = true
		$RayCastFront.cast_to = Vector2(20,0)
	elif !Input.is_action_pressed("ui_left") or !Input.is_action_pressed("ui_right"):
		speed = 0
		noiselevel = 0
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	if Input.is_action_pressed("ui_up") && can_hide == true:
		visible = false
		is_hidden = true
	if Input.is_action_pressed("ui_down") && is_hidden == true:
		visible = true
		is_hidden = false

func _on_MainChar_area_entered(area):
	if area.is_in_group("doors"):
		can_hide = true

func _on_MainChar_area_exited(area):
	if area.is_in_group("doors"):
		can_hide = false

func _check_shaders():
	if ray.is_colliding():
		$AnimatedSprite.material = attackblink
	else:
		$AnimatedSprite.material = nomaterial

func _on_Enemy1_enemyattack():
	ray.enabled = false
	#pass
	#visible = false
	#queue_free()

func _check_animation():
	if step_animation == true:
		$AnimatedSprite.play("walking")