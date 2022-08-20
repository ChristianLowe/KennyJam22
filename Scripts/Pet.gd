extends Area2D

var drive = {
	"hunger": 100.0,
	"thirst": 100.0,
	"sleepy": 100.0,
	"boring": 100.0,
}

export var sway_amount = 20.0
export var shake_amount = 5.0

var sway_direction_amount = [-sway_amount, sway_amount]
var level: int = 1

var sprite_frames_resources = [
	"res://Resources/Pet0SpriteFrames.tres",
	"res://Resources/Pet1SpriteFrames.tres"
]

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
	
func jump(jump_height: float = 300.0) -> void:
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

func _input(event):
	# This event handler is just for testing using keys.
	if event.is_pressed() and event is InputEventKey:
		match event.scancode:
			KEY_1:
				jump()
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
				evolve(0)
			KEY_5:
				evolve(1)

func _process(delta):
	pass
