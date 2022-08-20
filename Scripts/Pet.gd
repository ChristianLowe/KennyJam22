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

#func _ready():
#	$SquishTween.connect("tween_all_completed", self, "unsquish")
#	$UnsquishTween.connect("tween_all_completed", self, "squish")
#	$SwayTween.connect("tween_completed", self, "_on_sway_tween_completed")
	
#	sway()

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
	
func _on_sway_tween_completed(object, key) -> void:
	# Sway back the other way.
	sway_direction_amount.invert()
	sway()

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
	# This event handler is just for testing using the SPACE BAR.
	if event.is_action_pressed("ui_accept"):
		jump()

func _process(delta):
	pass
