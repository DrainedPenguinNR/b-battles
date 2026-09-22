extends Node2D

const HAND_COUNT = 3
const CARD_PATH = "res://Scenes/card.tscn"

const HAND_POS_X = 320
const HAND_POS_Y = 890
const CARD_WIDTH = 190


var player_hand = []


func _ready() -> void:
	var card_scene = preload(CARD_PATH)
	for i in range(HAND_COUNT):
		var new_card = card_scene.instantiate()
		$"../CardManager".add_child(new_card)
		new_card.name = "Card"
		add_card_to_hand(new_card)

func add_card_to_hand(card):
	if card not in player_hand:
		player_hand.insert(0, card)
		update_hand_positions()
	else:
		animate_card_to_pos(card, card.hand_position)

func update_hand_positions():
	for i in range(player_hand.size()):
		var new_pos = Vector2(calculate_card_position(i), HAND_POS_Y)
		var card = player_hand[i]
		card.hand_position = new_pos
		animate_card_to_pos(card, new_pos)

func calculate_card_position(index):
	var total_width = (player_hand.size() - 1) * CARD_WIDTH
	var x_offset = HAND_POS_X + index * CARD_WIDTH - total_width / 2
	return x_offset

func animate_card_to_pos(card, pos):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", pos, 0.1)

func remove_card_from_hand(card):
	if card in player_hand:
		player_hand.erase(card)
		update_hand_positions()
