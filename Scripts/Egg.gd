extends Area2D

var health = 5

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
	
	var egg_shard_scene = load("res://Actors/EggShard.tscn")
	spawn_shard(egg_shard_scene, 1, 40, -650, .5)
	spawn_shard(egg_shard_scene, 2, 700, -350, 3.5)
	spawn_shard(egg_shard_scene, 3, -620, -240, -3.3)
	
	pet.jump()
	queue_free()
	
func spawn_shard(scene, shard_num, h_speed, v_speed, r_speed):
	var shard = scene.instance()
	shard.position = position
	shard.init(shard_num, h_speed, v_speed, r_speed)
	get_parent().add_child(shard)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
