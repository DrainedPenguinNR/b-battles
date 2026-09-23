extends Node2D

const unit_scale = 35
const lane_height = 40
const max_units_per_row = 12
const bottom_Y = 980
const top_Y = 100
const center_x = 1920/2 + 40

@export var order = ["archer", "knight", "chaff"]
@export var teams = ["t1", "t2"]

func _ready() -> void:
	reflow_layout()

func reflow_layout():
	for t in range(teams.size()):
		var team = teams[t]
		var anchor_y = bottom_Y if team == "t1" else top_Y
		var direction = -1 if team == "t1" else 1
		var cursor_y = anchor_y
		
		for u in range(order.size()):
			var units = get_units_of_class(team, order[u])
			var row_count = calculate_lane_positions(units, cursor_y, direction)
			var band_height = max(lane_height, row_count * unit_scale)
			cursor_y += direction * band_height

func calculate_lane_positions(unit_list, lane_y, direction):
	var count = unit_list.size()
	if count == 0:
		return 0
	
	for i in range(count):
		var row = i / max_units_per_row
		var col = i % max_units_per_row
		
		var units_in_this_row = min(max_units_per_row, count - row * max_units_per_row)
		var total_width = (units_in_this_row - 1) * unit_scale
		var x = col * unit_scale + center_x - total_width / 2.0
		
		var y = lane_y + (direction * row * unit_scale)
		
		x += randf_range(-5, 5)
		y += randf_range(-5, 5)
		
		unit_list[i].current_pos = Vector2(x, y)
	
	return int(ceil(float(count) / max_units_per_row))

func get_units_of_class(team, class_name_str):
	var team_units = get_tree().get_nodes_in_group(team)
	var class_units = get_tree().get_nodes_in_group(class_name_str)
	var result = []
	for unit in team_units:
		if unit in class_units:
			result.append(unit)
	return result
