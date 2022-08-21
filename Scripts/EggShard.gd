extends Node2D

var gravity = -1600
var h_speed = 0
var v_speed = 0
var r_speed = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init(sprite_num, h_speed, v_speed, r_speed):
	self.h_speed = h_speed
	self.v_speed = v_speed
	self.r_speed = r_speed
	
	var sprite_path = "res://Sprites/EggShard" + str(sprite_num) + ".png"
	$Sprite.texture = load(sprite_path)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	v_speed -= gravity * delta
	position.x += h_speed * delta
	position.y += v_speed * delta
	rotation += r_speed * delta
	
	if position.y > get_viewport().size.y * 2:
		queue_free()
