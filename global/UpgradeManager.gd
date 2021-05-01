extends Node

func apply_upgrade(upgrade_id):
	if not upgrade_id: return
	print("applying upgrade %s" % upgrade_id)
	GameData.upgrades.append(upgrade_id)
	
	match upgrade_id:
		"":
			pass
