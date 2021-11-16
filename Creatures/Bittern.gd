extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var max_movement_speed
var movement_speed_scalar
var movement_speed = 0.0
var rotating = 0.0

const WEIGHT_DIVISION = 100000000.0

var genome : Array


# Called when the node enters the scene tree for the first time.
func _ready():
	generate_random_genome(randi() % get_max_amount_of_synapses())
	process_genome()


func get_max_amount_of_synapses():
	var possible_neurons = $Brain.get_children()
	
	var sensory_neurons = []
	var hidden_neurons = []
	var action_neurons = []
	for neuron in possible_neurons:
		var neuron_name = neuron.get_name()
		if "sensor" in neuron_name:
			sensory_neurons.append(neuron)
		elif "hidden" in neuron_name:
			hidden_neurons.append(neuron)
		elif "action" in neuron_name:
			action_neurons.append(neuron)
	
	var number_of_possible_combinations = 0
	for sensory_neuron in sensory_neurons:
		for hidden_neuron in hidden_neurons:
			number_of_possible_combinations += 1
		for action_neuron in action_neurons:
			number_of_possible_combinations += 1
	
	for hidden_neuron in hidden_neurons:
		for hidden_neuron_alt in hidden_neurons:
			number_of_possible_combinations += 1
		for action_neuron in action_neurons:
			number_of_possible_combinations += 1
	
	return number_of_possible_combinations

func process_genome():
	for gene in genome:
		var gene_type = gene[-1]
		if gene_type == "attribute":
			add_attribute(gene)
		elif gene_type == "synapse":
			$Brain.add_synapse(gene)

func add_attribute(gene):
	if gene[0] == "max_movement_speed":
		max_movement_speed = gene[1]
	
	elif gene[0] == "movement_speed_scalar":
		movement_speed_scalar = gene[1]

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass


func _physics_process(delta):
	if transform.origin.y > 0.052:
		move_and_slide(Vector3(transform.origin.x, get_node("/root/Global").SPAWN_HEIGHT * - 100, transform.origin.z) * delta)
	
	if get_parent().complete:
		rotate_y(rotating)
		move_and_slide(global_transform.basis.z * min(movement_speed * movement_speed_scalar, max_movement_speed) * delta)


func generate_random_genome(amount_of_synapses):
	for synapse in amount_of_synapses:
		genome.append(generate_random_synapse())
	
	genome.append(["movement_speed_scalar", randi() % 10, "attribute"])
	genome.append(["max_movement_speed", randi() % 500, "attribute"])

func generate_random_synapse():
	var synapse = []
	var source_neuron = get_random_neuron(["sensor", "hidden"])
	var destination_neuron = get_random_neuron(["hidden", "action"])
	if is_unique_synapse(source_neuron, destination_neuron):
		synapse.append(source_neuron)
		synapse.append(destination_neuron)
		synapse.append(randi() / WEIGHT_DIVISION)
		synapse.append("synapse")
		return synapse
	else:
		return generate_random_synapse()
	
	
func is_unique_synapse(source_neuron, destination_neuron):
	for synapse in genome:
		if source_neuron in synapse and destination_neuron in synapse:
			return false
	
	return true

func get_random_neuron(allowed_types):
	var neuron = $Brain.get_children()[randi() % $Brain.get_children().size()]
	
	if not "any" in allowed_types:
		while not neuron.neuron_type in allowed_types:
			neuron = $Brain.get_children()[randi() % $Brain.get_children().size()]
			
	return neuron
