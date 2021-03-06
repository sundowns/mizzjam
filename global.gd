extends Node

onready var music: AudioStreamPlayer = $Music

var levels: Array = [
	"tutorial1.tscn",
	"tutorial2.tscn",
	"tutorial3.tscn",
	"tutorial4.tscn",
	"tutorial5.tscn",
	"tutorial6.tscn",
	"tutorial7.tscn",
	"tutorial8.tscn",
	"tutorial9.tscn"
]

var dialogue: Dictionary = {
	0: [["For so long have I watched over the critters of the forest... so so long", 3.5], ["All they do is eat..... All day long they feast on cheese and steak", 3.5], ["Is this right? Does the food hurt? Who watches over cheese?", 3.5], ["Was I wrong all this time? Food needs protecting...not critters", 3.5], ["Thats it! I will use the sacred powers of the SPACE BAR to protect all food.", 3.5], ["I..... I MUST PROTECT CHEESE..................", 2], [".....................with the SPACE BAR!", 2]],
	1: [["It seems I was right... The cheese was rescued by a power even mightier than I!", 3.5], ["The signs are clear. I will protect the foods of the forest!",3.5], ["No critter can stop me!", 1.25], ["Well..... as long as there is only one!",2]],
	2: [["Who is leaving all this cheese out in the open?!",2], ["Why dont they put it somewhere safe inside and... SHUT THE DOOR!!", 2]],
	3: [["This would be a lot easier if I could just pick up the food...", 2], ["Well the lazy developer didnt put that in... So I am going to need some backup!", 2], ["Cats dont like cheese right?", 2]],
	5: [["Maybe not all critters are so bad after all.... ", 2.25], ["Those rats are definitely jerks though", 2], ["Well... and anything that hurts those sweet little cats!", 2.5]],
	6: [["Rats....Cats......Bears....Oh my!", 2]],
	7: [[".......Wow that meat actually smells pretty good...", 2.5]]
}
var post_game_dialogue = [["............. has cheese always looked so.....", 3], ["Delicious?!", 1]]
var current_level_index = -1

func _ready():
	dialogue[levels.size()] = post_game_dialogue

func start_game():
	current_level_index = 0
	music.play()
	load_dialogue_scene()

func load_next_level():
	current_level_index += 1
	if current_level_index == levels.size():
		#play final dialogue
		load_dialogue_scene()
	elif current_level_index > levels.size():
		all_levels_complete()
		return
	else:
		if dialogue.has(current_level_index):
			load_dialogue_scene()
		else: 
			# need this unpause or scenes with no dialogue can start paused
			get_tree().paused = false
			get_tree().change_scene("res://levels/%s" % levels[current_level_index])
		

func load_dialogue_scene():
	var dialogue_scene: PackedScene = load("res://Dialogue.tscn")
	get_tree().change_scene_to(dialogue_scene)
	call_deferred('set_dialogue_scene_text', dialogue.get(current_level_index))

func set_dialogue_scene_text(text):
	get_tree().current_scene.dialogue = text

func all_levels_complete():
	get_tree().change_scene("res://UI/GameComplete.tscn")

func dialogue_finished():
	if current_level_index == levels.size():
		all_levels_complete()
		return
	else:
		get_tree().change_scene("res://levels/%s" % levels[current_level_index])
