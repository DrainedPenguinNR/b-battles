extends Node2D

@export var move_speed = 1
@export var attack_damage = 1
@export var health = 1
@export var max_health = 10
@export var attack_speed = 1
@export var speed = 100

var attack_range
var current_pos = Vector2(0,0)
var fighting = false
var in_range = false
var is_moving = false

func _ready() -> void:
	attack_range = $AttackRange
	health = max_health

func _physics_process(delta: float) -> void:
	if fighting:
		if in_range:
			attack()
		else:
			current_pos = seek_enemy()
	move(delta)

func start_fight():
	pass

func seek_enemy():
	pass

func move(delta):
	position = position.move_toward(current_pos, speed * delta)

func _on_attack_range_area_entered(area: Area2D) -> void:
	var self_team = get_team(self)
	var entering_team = get_team(area.get_parent())
	
	if self_team != entering_team:
		in_range = true
	else:
		pass

func _on_attack_range_area_exited(area: Area2D) -> void:
	pass # Replace with function body.

func attack():
	pass

func take_damage(damage):
	health -= damage
	if health > 0:
		pass
	else:
		die()

func die():
	pass

func get_team(node):
	for group in node.get_groups():
		if group.begins_with("t1_"):
			return 1
		if group.begins_with("t2_"):
			return 2
			
	return 0
