class_name ObjectToIndex
extends RefCounted

var _objects: Array[Object] = []
var oldest_object_index = 0


func _init(capacity: int) -> void:
	_objects.resize(capacity)


func get_index(object: Object) -> int:
	var index := _objects.find(object)
	if index == -1:
		index = oldest_object_index
		_objects[index] = object
		oldest_object_index = (oldest_object_index + 1) % _objects.size()
	return index
