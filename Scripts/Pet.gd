extends Area2D

signal jumped

enum Status { 
	Content,
	Bored,
	Hungry,
	Thirsty,
	NeedsLove,
	Sleepy,
	Trashy
}

var sway_amount = 10.0
var shake_amount = 5.0

export var hunger_drive_delta: float = 0.010
export var thirst_drive_delta: float = 0.015
export var sleepy_drive_delta: float = 0.033
export var boring_drive_delta: float = 0.055
export var loving_drive_delta: float = 0.095
export var trashy_drive_delta: float = 0.025

export var food_reward_amount: float = 15.0
export var drink_reward_amount: float = 15.0
export var pet_reward_amount: float = 15.0
export var love_reward_amount: float = 15.0
export var clean_reward_amount: float = 15.0

export var max_seconds_until_evolve: int = 60.0*10.0
onready var seconds_until_evolve: int = max_seconds_until_evolve

var drive = {
	"hunger": [100.0, hunger_drive_delta, Status.Hungry],
	"thirst": [100.0, thirst_drive_delta, Status.Thirsty],
	"sleepy": [100.0, sleepy_drive_delta, Status.Sleepy],
	"boring": [100.0, boring_drive_delta, Status.Bored],
	"loving": [100.0, loving_drive_delta, Status.NeedsLove],
	"trashy": [100.0, trashy_drive_delta, Status.Trashy]
}

var drive_threshold: float = 0.75

var sway_direction_amount = [-sway_amount, sway_amount]
var level: int = 0

var sprite_frames_resources = [
	"res://Resources/Pet0SpriteFrames.tres",
	"res://Resources/Pet1SpriteFrames.tres",
	"res://Resources/Pet2SpriteFrames.tres"
]

onready var ui = get_tree().get_root().get_node('Main/UIFeed')

func _ready() -> void:
	ui.connect("feed_button_pressed", self, "_on_ui_feed_button_pressed")
	ui.connect("drink_button_pressed", self, "_on_ui_drink_button_pressed")
	ui.connect("play_button_pressed", self, "_on_ui_play_button_pressed")
	ui.connect("clean_button_pressed", self, "_on_ui_clean_button_pressed")
	ui.connect("pet_button_pressed", self, "_on_ui_pet_button_pressed")

func _spawn_heart() -> void:
	var heart = load("res://Actors/Heart.tscn").instance()
	heart.position = $Sprite.position + Vector2(0, -120)
	add_child(heart)
	
	if randi() % 2 == 0:
		get_parent().get_node("Audio").play_sfx("happy1")
	else:
		get_parent().get_node("Audio").play_sfx("happy2")

func _on_JumpTimer_timeout() -> void:
	jump(250.0, true)
	
func _on_GrowTimer_timeout() -> void:
	seconds_until_evolve -= 1
	print("seconds_until_evolve %d" % seconds_until_evolve)
	
	if seconds_until_evolve <= 0:
		grow(level + 1)
		seconds_until_evolve = max_seconds_until_evolve
	elif seconds_until_evolve == 2:
		transition_into_black()
	
func _on_ui_feed_button_pressed() -> void:
	_spawn_heart()
	drive["hunger"][0] = min(drive["hunger"][0] + food_reward_amount, 100.0)

	if drive["hunger"][0] > drive_threshold and has_node("PetStatusIcon"):
		get_node("PetStatusIcon").queue_free()
	
func _on_ui_drink_button_pressed() -> void:
	_spawn_heart()
	drive["thirst"][0] = min(drive["thirst"][0] + drink_reward_amount, 100.0)
	
	if drive["thirst"][0] > drive_threshold and has_node("PetStatusIcon"):
		get_node("PetStatusIcon").queue_free()
	
func _on_ui_play_button_pressed() -> void:
	_spawn_heart()
	drive["boring"][0] = min(drive["boring"][0] + pet_reward_amount, 100.0)
	if drive["boring"][0] > drive_threshold and has_node("PetStatusIcon"):
		get_node("PetStatusIcon").queue_free()
	
func _on_ui_clean_button_pressed() -> void:
	_spawn_heart()
	drive["trashy"][0] = min(drive["trashy"][0] + clean_reward_amount, 100.0)
	if drive["trashy"][0] > drive_threshold and has_node("PetStatusIcon"):
		get_node("PetStatusIcon").queue_free()
	
func _on_ui_pet_button_pressed() -> void:
	_spawn_heart()
	drive["loving"][0] = min(drive["loving"][0] + love_reward_amount, 100.0)
	if drive["loving"][0] > drive_threshold and has_node("PetStatusIcon"):
		get_node("PetStatusIcon").queue_free()

func transition_into_black() -> void:
	var tween = Tween.new()
	tween.interpolate_property(
		$Sprite,
		"modulate",
		Color.white,
		Color.black,
		1.0,
		Tween.TRANS_QUAD,
		Tween.EASE_IN
	)
	add_child(tween)
	tween.connect("tween_all_completed", self, "transition_into_white")
	tween.start()

func transition_into_white() -> void:
	var tween = Tween.new()
	tween.interpolate_property(
		$Sprite,
		"modulate",
		Color.black,
		Color.white,
		2.0,
		Tween.TRANS_QUAD,
		Tween.EASE_IN,
		1.0
	)
	add_child(tween)
	tween.start()

func grow(new_level: int) -> void:
	level = new_level
	var sprite_frames: SpriteFrames = load(sprite_frames_resources[new_level])
	$Sprite.set_sprite_frames(sprite_frames)
	
	if level >= 2:
		$GrowTimer.stop()
		
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
	var original_position_y: float = $Sprite.position.y
	$JumpTween.interpolate_property(
		$Sprite,
		"position:y",
		original_position_y,
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
		original_position_y,
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

func remove_status_icons() -> void:
	for child in get_children():
		if child is PetStatusIcon:
			child.queue_free()

func show_icons() -> void:
	var pet_status_icon_scene: AnimatedSprite = load("res://Interface/PetStatusIcon.tscn").instance()
	
	var is_content: bool = true
	for d in drive:
		if drive[d][0]/100.0 <= drive_threshold:
			var status: int = drive[d][2]
			is_content = false
			match status:
				Status.Bored:
					pet_status_icon_scene.set_animation("bored")
					$Sprite.set_animation("bored")
				Status.Hungry:
					pet_status_icon_scene.set_animation("hungry")
					$Sprite.set_animation("hungry")
				Status.NeedsLove:
					pet_status_icon_scene.set_animation("pet")
				Status.Thirsty:
					pet_status_icon_scene.set_animation("thirsty")
					$Sprite.set_animation("hungry")
				Status.Trashy:
					pet_status_icon_scene.set_animation("trashy")
					$Sprite.set_animation("hungry")
				Status.Sleepy:
					pet_status_icon_scene.set_animation("sleepy")
					$Sprite.set_animation("sleepy")
			
			add_child(pet_status_icon_scene)
			pet_status_icon_scene.set_position(Vector2(120.0, -100.0))
			pet_status_icon_scene.float_up_and_down()
			
			break
	
	if is_content:
		$Sprite.set_animation("default")

func _process(delta):
	for d in drive:
		drive[d][0] -= drive[d][1] * delta
		
		if not has_node("PetStatusIcon"):
			show_icons()
		
		if drive[d][0] <= 0.0:
			queue_free()
