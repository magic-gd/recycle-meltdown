extends Control

signal buy

export var item_id = "id"
export var item_name = "Item"
export var description = "Description"
export var price = {}

func _ready():
	_connect()
	_update_display()

func _connect():
	$BuyButton.connect("pressed", self, "buy")
	GameData.connect("resource_change", self, "_update_display")

func buy():
	emit_signal("buy", self)

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
