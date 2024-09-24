extends Area3D

signal focus_entity_changed(entity: Node3D)

var _current_focus_entity: Node3D
var _overlapping: Array[Node3D] = []

func _physics_process(_delta: float) -> void:
	_overlapping.clear()

	if has_overlapping_areas():
		_overlapping.append_array(get_overlapping_areas())

	if has_overlapping_bodies():
		_overlapping.append_array(get_overlapping_bodies())

	if _overlapping.is_empty():
		if _current_focus_entity:
			_current_focus_entity = null
			focus_entity_changed.emit(null)
		return

	# 最も距離が近いものを選択する
	var closest_entity: Node3D = null
	for entity in _overlapping:
		if not closest_entity:
			closest_entity = entity
			continue

		var current_distance = (global_transform.origin - closest_entity.global_transform.origin).length_squared()
		var new_distance = (global_transform.origin - entity.global_transform.origin).length_squared()

		if new_distance < current_distance:
			closest_entity = entity
			
	if _current_focus_entity != closest_entity:
		_current_focus_entity = closest_entity
		focus_entity_changed.emit(_current_focus_entity)