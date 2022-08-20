extends Area2D

var drive = {
	"hunger": 100.0,
	"thirst": 100.0,
	"sleepy": 100.0,
	"boring": 100.0,
}

func _ready():
	$SquishTween.connect("tween_all_completed", self, "unsquish")
	$UnsquishTween.connect("tween_all_completed", self, "squish")
	
	squish()

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


func _process(delta):
	pass
