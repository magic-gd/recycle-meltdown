extends Control

func _ready():
	_connect()

func _connect():
	$BackButton.connect("pressed", SceneManager, "goto_main")
	
	for item in $ShopList/ScrollContainer/ItemVBox.get_children():
		item.connect("buy", self, "_on_buy")

func _on_buy(item):
	var item_id = item.item_id
	var price = item.price
	
	for price_type in price:
		GameData.change_resource(price_type, -price[price_type])
	
	UpgradeManager.apply_upgrade(item_id)
