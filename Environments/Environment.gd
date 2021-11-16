extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var complete = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var global = get_node("/root/Global")
	global.register_environment(self)
	
	var BITTERN = preload("res://Creatures/Bittern.tscn")
	var population = global.generate_random_population(100, BITTERN)
	global.populate_environment(population)
	$FoodSpawner.start()
	complete = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
