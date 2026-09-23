extends Node2D

const unit_scale = 35
const lane_height = 40
const max_units_per_row = 12
const bottom_Y = 980
const center_x = 1920/2 + 40

@export var order = ["chaff", "knight", "archer"]
@export var teams = ["t1", "t2"]

func _ready() -> void:
	reflow_layout()

func reflow_layout():
	for t in range(teams.size()):
		for u in range(order.size()):
			calculate_lane_positions(get_units_of_class(teams[t], order[u]), u)
			

func get_units_of_class(team, name):
	var group_name = team + "_" + name
	return get_tree().get_nodes_in_group(group_name)

func calculate_lane_positions(unit_list, lane_index):
	var lane_y = bottom_Y - (lane_index * lane_height)
	var count = unit_list.size()
	
	for i in range(count):
		var row = i / max_units_per_row       # integer division — which row within the lane
		var col = i % max_units_per_row        # position within that row
		
		var units_in_this_row = min(max_units_per_row, count - row * max_units_per_row)
		var total_width = (units_in_this_row - 1) * unit_scale
		var x = col * unit_scale + center_x - total_width / 2.0
		
		var y = lane_y - (row * unit_scale)  # rows stack toward center as it overflows
		
		x += randf_range(-5, 5)
		y += randf_range(-5, 5)
		
		unit_list[i].current_pos = Vector2(x, y)
