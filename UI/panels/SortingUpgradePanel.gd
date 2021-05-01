extends Control

func _ready():
	_connect()

func _connect():
	$BackButton.connect("pressed", SceneManager, "goto_main")
	
	for item in $ShopList/ScrollContainer/ItemVBox.get_children():
		item.connect("buy", self, "_on_buy")

func _on_buy(item):
	for price_type in item.price:
		GameData.change_resource(price_type, -item.price[price_type])
	
	UpgradeManager.apply_upgrade(item.item_id)
	item.queue_free()
