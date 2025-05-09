class_name NodeExtension
extends Node

func forEachChildren(iterationCall : Callable) -> void:
	for child in get_children():
		if iterationCall.is_valid():
			iterationCall.call(child)
