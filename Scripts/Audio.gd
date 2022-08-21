extends AudioStreamPlayer

var sfx = [
	"bored",
	"click1",
	"click2",
	"happy1",
	"happy2",
	"hungry",
	"needy",
	"rollover1",
	"rollover2",
	"switch2",
	"switch3",
	"thirsty",
	"unclean",
]

# Called when the node enters the scene tree for the first time.
func _ready():
	for name in sfx:
		var p = AudioStreamPlayer.new()
		p.name = "player_" + name
		p.stream = load("res://Interface/Sounds/Resources/" + name + ".ogg")
		
		p.stream.loop = false
		add_child(p)

func play_sfx(name):
	get_node("player_" + name).play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
