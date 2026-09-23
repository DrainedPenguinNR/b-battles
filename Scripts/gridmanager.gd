extends Node2D

@export var order = ["chaff", "knight", "archer"]
@export var teams = ["t1", "t2"]

func _ready() -> void:
	reflow_layout()

func reflow_layout():
	for t in range(teams.size()):
		for u in range(order.size()):
			print (teams[t],order[u])
			get_units_of_class(teams[t], order[u])

func get_units_of_class(team, name):
	var group_name = team + "_" + name
	print (group_name)
	print(get_tree().get_nodes_in_group(group_name))
