extends StaticBody2D

signal score(amount)

const COL_SIZE := 60
# var width : float
var cols : int = 10
var cartons := Array()

# func _ready():
	# width = get_viewport().size.x
	# cols = width / COL_SIZE

func _on_GroundArea_area_entered(area):
	var parent = area.get_parent()
	if parent.is_in_group("cartons"):
		cartons.append(parent)
		check_row()
		
		
func check_row():
	if cartons.size() == cols:
		emit_signal("score", cols)
		for c in cartons:
			rem_node(c)
		cartons.clear()

func rem_node(node : Node):
	node.get_parent().remove_child(node)
