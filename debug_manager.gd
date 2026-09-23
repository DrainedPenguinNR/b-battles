extends Node2D

@onready var gridmanager = $"../GridManager"
@onready var t1_knightlist = $"../UnitManager/Team1/KnightList"
@onready var t2_knightlist = $"../UnitManager/Team2/KnightList"
@onready var t1_archerlist = $"../UnitManager/Team1/ArcherList"
@onready var t2_archerlist = $"../UnitManager/Team2/ArcherList"
@onready var unit_manager = $"../UnitManager"
@onready var knight = preload("res://Scenes/knightunit.tscn")
@onready var archer = preload("res://Scenes/ArcherUnit.tscn")

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_Q:
			var knight = knight.instantiate()
			t1_knightlist.add_child(knight)
			knight.add_to_group("t1")
			knight.add_to_group("knight")
			knight.position = Vector2(1920/2, 1080)
			gridmanager.reflow_layout()
			
		if event.keycode == KEY_W:
			var archer = archer.instantiate()
			t1_archerlist.add_child(archer)
			archer.add_to_group("t1")
			archer.add_to_group("archer")
			archer.position = Vector2(1920/2, 1080)
			gridmanager.reflow_layout()
		
			
		if event.keycode == KEY_O:
			var knight = knight.instantiate()
			t2_knightlist.add_child(knight)
			knight.add_to_group("t2")
			knight.add_to_group("knight")
			knight.position = Vector2(1920/2, 0)
			gridmanager.reflow_layout()
			
		if event.keycode == KEY_P:
			var archer = archer.instantiate()
			t2_archerlist.add_child(archer)
			archer.add_to_group("t2")
			archer.add_to_group("archer")
			archer.position = Vector2(1920/2, 0)
			gridmanager.reflow_layout()
		
		if event.keycode == KEY_F:
			get_tree().call_group("t1", "start_fight")
			get_tree().call_group("t2", "start_fight")
