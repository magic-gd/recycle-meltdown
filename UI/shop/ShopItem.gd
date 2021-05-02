extends Control

#
# A shop item
# For tiered upgrades, add another invisible shop item
# and assign it to next_tier_item_path
#

signal buy

export var type = "upgrade"
export var item_id = "id"
export var item_name = "Item"
export var description = "Description"
export var price = {}
export (NodePath) var next_tier_item_path = null

func _ready():
	_connect()
	_check_tier()
	_update_display()

func _connect():
	$BuyButton.connect("pressed", self, "buy")
	GameData.connect("resource_change", self, "_update_display")

func buy():
	emit_signal("buy", self)
	if next_tier_item_path:
		var next_item = get_node(next_tier_item_path)
		if next_item:
			_replace_self_with(next_item)
	else:
		queue_free()

func _check_tier():
	if not next_tier_item_path: return
	if not get_parent() is VBoxContainer: return
	
	var next_item = get_node(next_tier_item_path)
	if item_id in GameData.upgrades:
		if not next_item._check_tier():
			_replace_self_with(next_item)
		visible = false
		return true
	else:
		next_item.visible = false
		return false

func _replace_self_with(shop_item):
	if not shop_item: return
	shop_item.visible = true
	
	# Keep position
	var child_pos = get_position_in_parent()
	get_parent().call_deferred("move_child", shop_item, child_pos)
	
	queue_free()

func _update_display():
	$VBoxContainer/NameLabel.text = item_name
	$VBoxContainer/DescriptionLabel.text = description
	$VBoxContainer/PriceLabel.text = _price_to_text()
	_check_available()

func _check_available():
	if item_id in GameData.upgrades:
		$BuyButton.text = "Bought!"
		$VBoxContainer/PriceLabel.text = ""
		$BuyButton.disabled = true
		return
	for price_type in price:
		if GameData.resources[price_type] < price[price_type]:
			$BuyButton.disabled = true

func _price_to_text():
	if not price: return "Free"
	var price_string = ""
	for price_type in price:
		price_string += price_type
		price_string += ": %s  " % str(price[price_type])
	
	return price_string
