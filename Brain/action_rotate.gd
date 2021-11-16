extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var neuron_type = "action"
var input_connections = []
var output : float

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	output = 0.0
	for input_connection in input_connections:
		output += input_connection[0].output * input_connection[1]
	
	get_parent().get_parent().rotating = output
