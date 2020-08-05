extends Node



func get_main_node() -> Node:
	var root_node : Node = get_tree().get_root()
	return root_node.get_child(root_node.get_child_count() -1)
