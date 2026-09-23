extends Node2D

@onready var gridmanager = $"../GridManager"
@onready var t1_knightlist = $"../UnitManager/Team1/KnightList"
@onready var knight = preload("res://Scenes/knightunit.tscn")

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_SPACE:
			var knight = knight.instantiate()
			t1_knightlist.add_child(knight)
			knight.add_to_group("t1_knight")
			knight.position = Vector2(1920/2, 1000)
			gridmanager.reflow_layout()

func summon():
	var knight = knight.instantiate()
	t1_knightlist.add_child(knight)
	knight.add_to_group("t1_knight")
	knight.position = Vector2(1920/2, 1000)
