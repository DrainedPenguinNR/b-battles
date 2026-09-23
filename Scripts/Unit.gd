extends CharacterBody2D

@export var move_speed = 1
@export var attack_damage = 1
@export var health = 1
@export var max_health = 10
@export var attack_speed = 1.0
@export var speed = 100

var hitbox
var attack_range
var attack_timer
var current_pos = Vector2(0, 0)
var current_target = null
var fighting = false
var in_range = false
var animation

func _ready() -> void:
	hitbox = $HitBox
	attack_range = $AttackRange
	attack_range.connect("area_entered", _on_attack_range_area_entered)
	attack_range.connect("area_exited", _on_attack_range_area_exited)
	
	attack_timer = $AttackTimer
	attack_timer.wait_time = attack_speed
	attack_timer.connect("timeout", perform_attack)
	
	animation = $AnimationPlayer
	
	health = max_health

func _physics_process(delta: float) -> void:
	if fighting:
		if in_range:
			attack()
		else:
			current_pos = seek_enemy()
	
	if !in_range:
		move(delta)
	
	if velocity <= Vector2(0.1, 0.1):
		animation.play("idle")
	elif velocity > Vector2(0.1, 0.1):
		animation.play("run")

func start_fight():
	fighting = true

func get_team(node):
	if node.is_in_group("t1"):
		return 1
	if node.is_in_group("t2"):
		return 2
	return 0

func get_enemy_team_group():
	var my_team = get_team(self)
	if my_team == 1:
		return "t2"
	elif my_team == 2:
		return "t1"
	return null

func seek_enemy():
	var enemy_group = get_enemy_team_group()
	if enemy_group == null:
		return current_pos
	
	var enemies = get_tree().get_nodes_in_group(enemy_group)
	if enemies.is_empty():
		return current_pos  # nobody left — stay put (see note below)
	
	var closest = enemies[0]
	var closest_dist = global_position.distance_squared_to(closest.global_position)
	
	for enemy in enemies:
		var dist = global_position.distance_squared_to(enemy.global_position)
		if dist < closest_dist:
			closest = enemy
			closest_dist = dist
	
	return closest.global_position

func move(delta):
	var to_target = current_pos - position
	if to_target.length() < 1.0:
		velocity = Vector2.ZERO
	else:
		velocity = to_target.normalized() * speed
	move_and_slide()

func _on_attack_range_area_entered(area: Area2D) -> void:
	var self_team = get_team(self)
	var entering_team = get_team(area.get_parent())
	
	if self_team != entering_team and current_target == null:
		current_target = area.get_parent()
		in_range = true

func _on_attack_range_area_exited(area: Area2D) -> void:
	if area.get_parent() == current_target:
		current_target = null
		in_range = false

func attack():
	if attack_timer.is_stopped():
		attack_timer.start()

func perform_attack():
	if current_target == null or not is_instance_valid(current_target):
		current_target = null
		in_range = false
		attack_timer.stop()
		return
	current_target.take_damage(attack_damage)

func take_damage(damage):
	health -= damage
	$Sprite2D.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	$Sprite2D.modulate = Color.WHITE
	if health > 0:
		pass
	else:
		die()

func die():
	animation.stop()
	animation.play("die")
	await get_tree().create_timer(1).timeout
	queue_free()
