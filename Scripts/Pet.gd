extends Area2D

signal jumped

enum Status { 
	Content,
	Bored,
	Hungry,
	NeedsAttention,
	Sleepy
}

var drive = {
	"hunger": [100.0,1.0],# 0.010],
	"thirst": [100.0,5.0],#0.015],
	"sleepy": [100.0, 0.033],
	"boring": [100.0, 3.0]#0.055],
}

export var sway_amount = 10.0
export var shake_amount = 5.0

var sway_direction_amount = [-sway_amount, sway_amount]
var level: int = 0
var status: int = Status.Content

var sprite_frames_resources = [
	"res://Resources/Pet0SpriteFrames.tres",
	"res://Resources/Pet1SpriteFrames.tres",
	"res://Resources/Pet2SpriteFrames.tres"
]

onready var ui = get_tree().get_root().get_node('Main/UIFeed')
onready var hunger_progress_bar: TextureProgress = ui.get_node("ButtonBar/ButtonFeedBackground/ProgressBar")
onready var thirst_progress_bar: TextureProgress = ui.get_node("ButtonBar/ButtonDrinkBackground/ProgressBar")
onready var bored_progress_bar: TextureProgress = ui.get_node("ButtonBar/ButtonPlayBackground/ProgressBar")

func _ready() -> void:
	ui.connect("feed_button_pressed", self, "_on_ui_feed_button_pressed")
	ui.connect("drink_button_pressed", self, "_on_ui_drink_button_pressed")
	ui.connect("play_button_pressed", self, "_on_ui_play_button_pressed")
	ui.connect("clean_button_pressed", self, "_on_ui_clean_button_pressed")
	ui.connect("pet_button_pressed", self, "_on_ui_pet_button_pressed")
	
	initialize_progress_bar_values()

func initialize_progress_bar_values() -> void:
	hunger_progress_bar.set_max(drive["hunger"][0])
	hunger_progress_bar.set_value(drive["hunger"][0])
	
	thirst_progress_bar.set_max(drive["thirst"][0])
	thirst_progress_bar.set_value(drive["thirst"][0])
	
	bored_progress_bar.set_max(drive["boring"][0])
	bored_progress_bar.set_value(drive["boring"][0])
	

func _on_ui_feed_button_pressed() -> void:
	drive["hunger"][0] = min(drive["hunger"][0] + 5.0, 100.0)
	jump(100.0)
	
func _on_ui_drink_button_pressed() -> void:
	drive["thirst"][0] = min(drive["thirst"][0] + 5.0, 100.0)
	
func _on_ui_play_button_pressed() -> void:
	drive["boring"][0] = min(drive["boring"][0] + 5.0, 100.0)
	
func _on_ui_clean_button_pressed() -> void:
	pass
	
func _on_ui_pet_button_pressed() -> void:
	pass
	

func evolve(new_level: int) -> void:
	level = new_level
	var sprite_frames: SpriteFrames = load(sprite_frames_resources[new_level])
	$Sprite.set_sprite_frames(sprite_frames)

func sway() -> void:
	$SwayTween.interpolate_property(
		$Sprite,
		"rotation_degrees",
		sway_direction_amount[0],
		sway_direction_amount[1],
		1.0,
		Tween.TRANS_BACK,
		Tween.EASE_IN_OUT,
		0.05
	)
	$SwayTween.start()

func stop_sway() -> void:
	$SwayTween.stop_all()
	$SwayTween.reset_all()
	$SwayTween.remove_all()
	
	$Sprite.rotation_degrees = 0.0
	sway_amount = [-20.0, 20.0]
	
func shake(iterations: int = 5) -> void:
	for i in range(iterations):
		$ShakeTween.interpolate_property(
			$Sprite,
			"offset:x" if randf() < 0.5 else "offset:y",
			0.0,
			shake_amount,
			0.1,
			Tween.TRANS_BOUNCE,
			Tween.EASE_OUT
		)
		
		$ShakeTween.start()
		yield($ShakeTween,"tween_all_completed")
	
func squish() -> void:
	var normal_scale = $Sprite.scale
	$SquishTween.interpolate_property(
		$Sprite,
		"scale:y",
		normal_scale.y,
		normal_scale.y/1.5,
		0.5,
		Tween.TRANS_ELASTIC,
		Tween.EASE_OUT
	)
	
	$SquishTween.interpolate_property(
		$Sprite,
		"scale:x",
		normal_scale.x,
		normal_scale.x*1.5,
		0.5,
		Tween.TRANS_ELASTIC,
		Tween.EASE_OUT
	)
	$SquishTween.start()

func unsquish() -> void:
	var normal_scale = $Sprite.scale
	$UnsquishTween.interpolate_property(
		$Sprite,
		"scale:y",
		normal_scale.y,
		normal_scale.y*1.5,
		0.5,
		Tween.TRANS_SINE,
		Tween.EASE_OUT
	)
	$UnsquishTween.interpolate_property(
		$Sprite,
		"scale:x",
		normal_scale.x,
		normal_scale.x/1.5,
		0.5,
		Tween.TRANS_SINE,
		Tween.EASE_OUT
	)
	$UnsquishTween.start()
	
func stretch() -> void:
	var normal_scale = $Sprite.scale
	$StretchTween.interpolate_property(
		$Sprite,
		"scale:y",
		normal_scale.y,
		1.25,
		0.5,
		Tween.TRANS_SINE,
		Tween.EASE_OUT
	)
	$StretchTween.interpolate_property(
		$Sprite,
		"scale:x",
		normal_scale.x,
		0.5,
		0.5,
		Tween.TRANS_SINE,
		Tween.EASE_OUT
	)
	$StretchTween.start()
	
func straighten() -> void:
	var normal_scale = $Sprite.scale
	$StraightenTween.interpolate_property(
		$Sprite,
		"scale:y",
		normal_scale.y,
		1.0,
		0.25,
		Tween.TRANS_SINE,
		Tween.EASE_OUT
	)
	$StraightenTween.interpolate_property(
		$Sprite,
		"scale:x",
		normal_scale.x,
		1.0,
		0.25,
		Tween.TRANS_SINE,
		Tween.EASE_OUT
	)
	$StraightenTween.start()
	
func jump(jump_height: float = 300.0, move: bool = false) -> void:
	squish()
	yield($SquishTween,"tween_all_completed")
	$JumpTween.interpolate_property(
		$Sprite,
		"position:y",
		$Sprite.position.y,
		$Sprite.position.y-jump_height,
		0.75,
		Tween.TRANS_QUINT,
		Tween.EASE_OUT
	)
	$JumpTween.start()
	move()
	stretch()
	yield($StretchTween,"tween_all_completed")
	shake()
	$FallTween.interpolate_property(
		$Sprite,
		"position:y",
		$Sprite.position.y,
		$Sprite.position.y+jump_height,
		0.25,
		Tween.TRANS_SINE,
		Tween.EASE_IN
	)
	$FallTween.start()
	yield($FallTween,"tween_all_completed")
	squish()

func move(move_distance: float = 46.0) -> void:
	var sprite_texture_size_x: float = 46.0
	var move_to_position_x: float = clamp(
		position.x + rand_range(-move_distance, move_distance),
		0.0,
		get_viewport().size.x-sprite_texture_size_x
	)
	
	$MoveTween.interpolate_property(
		self,
		"position:x",
		position.x,
		move_to_position_x,
		0.75,
		Tween.TRANS_SINE,
		Tween.EASE_OUT
	)
	$MoveTween.start()

func _input(event):
	# This event handler is just for testing using keys.
	if event.is_pressed() and event is InputEventKey:
		match event.scancode:
			KEY_1:
				jump(250.0, true)
			KEY_2:
				sway()
				yield($SwayTween,"tween_all_completed")
				sway_direction_amount.invert()
				sway()
				yield($SwayTween,"tween_all_completed")
				stop_sway()
			KEY_3:
				shake()
			KEY_4:
				evolve((level+1)%3)
			KEY_6:
				set_status(Status.Content)
			KEY_7:
				set_status(Status.Bored)
			KEY_8:
				set_status(Status.Hungry)
			KEY_9:
				set_status(Status.NeedsAttention)
			KEY_0:
				set_status(Status.Sleepy)

func remove_status_icons() -> void:
	for child in get_children():
		if child is PetStatusIcon:
			child.queue_free()

func set_status(new_status: int) -> void:
	remove_status_icons()
		
	var pet_status_icon_scene = load("res://Interface/PetStatusIcon.tscn").instance()
	
	match new_status:
		Status.Content:
			$Sprite.set_animation("default")
		Status.Bored:
			pet_status_icon_scene.set_animation("bored")
			$Sprite.set_animation("bored")
		Status.Hungry:
			pet_status_icon_scene.set_animation("hungry")
			$Sprite.set_animation("hungry")
		Status.NeedsAttention:
			pet_status_icon_scene.set_animation("pet")
		Status.Sleepy:
			pet_status_icon_scene.set_animation("sleepy")
			$Sprite.set_animation("sleepy")
	
	if new_status != Status.Content:
		add_child(pet_status_icon_scene)
		pet_status_icon_scene.set_position(Vector2(120.0, -100.0))
		pet_status_icon_scene.float_up_and_down()
				
	status = new_status

func _process(delta):
	for d in drive:
		drive[d][0] -= drive[d][1] * delta
		print(d + " " + str(drive[d][0]))
	
	hunger_progress_bar.set_value(drive["hunger"][0])
	thirst_progress_bar.set_value(drive["thirst"][0])
	bored_progress_bar.set_value(drive["boring"][0])
