extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const SPAWN_HEIGHT = 10

var ENVIRONMENT : Spatial
var ENVIRONMENT_SIZE
var X_MIN : float
var X_MAX : float
var Z_MIN : float
var Z_MAX : float

var FOOD


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	FOOD = preload("res://Objects/Food.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func spawn_food():
	var rand_x = int(round(rand_range(X_MIN, X_MAX)))
	var rand_z = int(round(rand_range(Z_MIN, Z_MAX)))
	var food_translation = Vector3(rand_x, 0, rand_z)
	var food = FOOD.instance()
	ENVIRONMENT.add_child(food)
	food.translation = food_translation


func generate_random_population(amount, creature):
	var population = []
	
	for individual in amount:
		population.append(creature.instance())
	
	return population


func register_environment(environment: Spatial):
	ENVIRONMENT = environment
	ENVIRONMENT_SIZE = environment.get_node("Floor").scale
	X_MIN = ENVIRONMENT_SIZE.x * -1 + ENVIRONMENT_SIZE.x * 0.1
	X_MAX = ENVIRONMENT_SIZE.x - ENVIRONMENT_SIZE.x * 0.1
	Z_MIN = ENVIRONMENT_SIZE.z * -1 + ENVIRONMENT_SIZE.z * 0.1
	Z_MAX = ENVIRONMENT_SIZE.z - ENVIRONMENT_SIZE.z * 0.1


func populate_environment(population):
	for individual in population:
		var rand_x = int(round(rand_range(X_MIN, X_MAX)))
		var rand_z = int(round(rand_range(Z_MIN, Z_MAX)))
		var new_translation = Vector3(rand_x, SPAWN_HEIGHT, rand_z)
		ENVIRONMENT.add_child(individual)
		individual.translation = new_translation
		yield(get_tree().create_timer(0.01), "timeout")
