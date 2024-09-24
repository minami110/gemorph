extends CanvasLayer

var _current_entity: Node

func _enter_tree() -> void:
	%LineEdit.text_submitted.connect(_on_LineEdit_text_entered)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_TAB:
			if visible:
				_hide_terminal()
			else:
				show()
				%LineEdit.grab_focus()


func _hide_terminal() -> void:
	# Clear input text
	%LineEdit.text = ""
	# Hide this menu
	hide()	

func _on_LineEdit_text_entered(input: String) -> void:

	# Global Commands
	if input == "exit":
		_hide_terminal()
		return

	# TODO: Godot の関数も全部出ちゃう涙
	elif input == "help":
		if _current_entity:
			var ad = _current_entity.get_method_list()
			for d in ad:
				%Console.text += d["name"]
				%Console.text += ", "
		else:
			%Console.text = "Error: No target entity"
		return

	if _current_entity:
		if _current_entity.has_method(input):
			_current_entity.call(input)
			# ToDo: Result
			%Console.text = input
		else:
			# Failed to find method
			%Console.text = "Error: Method %s not found" % input

	%LineEdit.text = ""

func set_target_entity(entity: Node3D) -> void:
	_current_entity = entity
	if _current_entity:
		%TargetName.text = entity.name
	else:
		%TargetName.text = "None"