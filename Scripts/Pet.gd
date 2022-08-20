extends Area2D

var drive = {
	"hunger": 100.0,
	"thirst": 100.0,
	"sleepy": 100.0,
	"boring": 100.0,
}

func _ready():
	$GrowTween.connect("tween_all_completed", self, "shrink")
	$ShrinkTween.connect("tween_all_completed", self, "grow")
	
	grow()

func grow() -> void:
	var normal_scale = $Sprite.scale
	$GrowTween.interpolate_property(
		$Sprite,
		"scale:y",
		normal_scale.y,
		normal_scale.y/1.5,
		0.5,
		Tween.TRANS_ELASTIC,
		Tween.EASE_OUT
	)
	
	$GrowTween.interpolate_property(
		$Sprite,
		"scale:x",
		normal_scale.x,
		normal_scale.x*1.5,
		0.5,
		Tween.TRANS_ELASTIC,
		Tween.EASE_OUT
	)
	$GrowTween.start()

func shrink() -> void:
	var normal_scale = $Sprite.scale
	$ShrinkTween.interpolate_property(
		$Sprite,
		"scale:y",
		normal_scale.y,
		normal_scale.y*1.5,
		0.5,
		Tween.TRANS_SINE,
		Tween.EASE_OUT
	)
	$ShrinkTween.interpolate_property(
		$Sprite,
		"scale:x",
		normal_scale.x,
		normal_scale.x/1.5,
		0.5,
		Tween.TRANS_SINE,
		Tween.EASE_OUT
	)
	$ShrinkTween.start()


func _process(delta):
	pass
