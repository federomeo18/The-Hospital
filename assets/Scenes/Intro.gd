extends Node

var item = 0
var nomaterial = null

var textblink = preload("res://assets/Weapons/Items.tres")

#$AnimatedSprite.material = attackblink
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$New_Game.material = textblink
	$Tutorial.material = nomaterial

func _process(delta):
	if Input.is_action_pressed("Up"):
		item = 0
		$New_Game.material = textblink
		$Tutorial.material = nomaterial
	if Input.is_action_pressed("Down"):
		item = 1
		$Tutorial.material = textblink
		$New_Game.material = nomaterial
	if item == 0 && Input.is_action_just_pressed("Action"):
		Scene_handler.next_level()
	elif item == 1 && Input.is_action_just_pressed("Action"):
		item = 2
		$New_Game.visible = false
		$Tutorial.visible = false
		$Title.visible = false
		$Bar.visible = true
		$Text1.visible = true
		$Text2.visible = true
		$Text3.visible = true
		$Monster.visible = true
		$Back.material = textblink
		$Next.material = nomaterial
		$Back.visible = true
		$Next.visible = true
		$Text4.visible = false
		$Text5.visible = false
		$Text6.visible = false
		$Text7.visible = false
		$Text8.visible = false
		$Text9.visible = false
		$Text10.visible = false
		$Arrows.visible = false
		$Shift_Control.visible = false
		$Enter.visible = false
		$Space.visible = false
	elif item == 2 && Input.is_action_just_pressed("Action"):
		item = 1
		$New_Game.visible = true
		$Tutorial.visible = true
		$Title.visible = true
		$Bar.visible = false
		$Text1.visible = false
		$Text2.visible = false
		$Text3.visible = false
		$Monster.visible = false
		$Back.material = textblink
		$Next.material = nomaterial
		$Back.visible = false
		$Next.visible = false
		$Text4.visible = false
		$Text5.visible = false
		$Text6.visible = false
		$Text7.visible = false
		$Text8.visible = false
		$Text9.visible = false
		$Text10.visible = false
		$Arrows.visible = false
		$Shift_Control.visible = false
		$Enter.visible = false
		$Space.visible = false
	if item == 3 && Input.is_action_just_pressed("Action"):
		item = 1
		$New_Game.visible = false
		$Tutorial.visible = false
		$Title.visible = false
		$Bar.visible = false
		$Text1.visible = false
		$Text2.visible = false
		$Text3.visible = false
		$Monster.visible = false
		$Back.material = textblink
		$Next.material = nomaterial
		$Back.visible = true
		$Next.visible = false
		$Text4.visible = true
		$Text5.visible = true
		$Text6.visible = true
		$Text7.visible = true
		$Text8.visible = true
		$Text9.visible = true
		$Text10.visible = true
		$Arrows.visible = true
		$Shift_Control.visible = true
		$Enter.visible = true
		$Space.visible = true
	if (item == 2 && Input.is_action_just_pressed("Left")) || (item == 3 && Input.is_action_just_pressed("Left")):
		item = 2
		$Back.material = textblink
		$Next.material = nomaterial
	if (item == 2 && Input.is_action_just_pressed("Right")) || (item == 3 && Input.is_action_just_pressed("Right")):
		item = 3
		$Back.material = nomaterial
		$Next.material = textblink