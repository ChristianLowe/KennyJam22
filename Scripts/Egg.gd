extends Area2D

var health = 15

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		bounce()
		health -= 1
		if health <= 0:
			pop()

func bounce():
	var small = Vector2(0.7, 0.7)
	var normal = Vector2(1.0, 1.0)
	$Tween.interpolate_property(
		$Sprite,
		"scale",
		small, normal, .55,
		Tween.TRANS_BOUNCE, Tween.EASE_OUT
	)
	$Tween.start()

func pop():
	var pet_scene = load("res://Actors/Pet.tscn")
	var pet = pet_scene.instance()
	pet.position = position
	get_parent().add_child(pet)
	queue_free()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
