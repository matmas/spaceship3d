class_name ObjectToIndex
extends RefCounted

var _num_last_objects: int
var _last_objects: Array[Object] = []


func _init(num_last_objects: int) -> void:
	_num_last_objects = num_last_objects


func get_index(object: Object) -> int:
	var index := _last_objects.find(object)
	if index == -1:
		_last_objects.push_back(object)
		while _last_objects.size() > _num_last_objects:
			_last_objects.pop_front()
		return _last_objects.size() - 1
	return index
