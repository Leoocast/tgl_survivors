@tool
extends EditorInspectorPlugin

#Config
const FONT_ROUTE: String = "res://addons/enabled_checkbox/NotoSans-Bold.ttf"

#Customize
const TITLE: String = "Arky Addons"
const TITLE_FONT_COLOR: Color = Color("#cdcfd2")
const TITLE_FONT_SIZE: int = 21
const TITLE_BACKGROUND_COLOR: Color = Color("#40444c")

#Internal
var visibleStateBeforeChange = false

#UndoRedo
var undoRedo : EditorUndoRedoManager 

func _can_handle(object):
	# Aplica a todos los nodos, pero puedes filtrar por tipo si quieres
	return object is Node

func createFont() -> FontFile:
	var font := FontFile.new()
	font.load_dynamic_font(FONT_ROUTE)
	return font

func _parse_begin(object):

	var font = createFont()

	createHeader(font)

	var row = HBoxContainer.new()
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	# ----- Left column -----
	var label = Label.new()
	label.text = "Enabled"
	label.size_flags_horizontal = Control.SIZE_EXPAND
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT

	# ----- Right column -----
	var right_panel = createRightPanel()

	# CheckBox 
	var checkbox = createCheckbox(object)

	# Add childs
	right_panel.add_child(checkbox)
	row.add_child(label)
	row.add_child(right_panel)
	
	add_custom_control(row)

	# -------------- Reset Position Button --------------
	var row3 = HBoxContainer.new()
	row3.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var label3 = Label.new()
	label3.text = "Position"
	label3.size_flags_horizontal = Control.SIZE_EXPAND
	label3.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT

	var right_panel3 = createRightPanel()
	var positionButton = createPositionButton(object)
	
	right_panel3.add_child(positionButton)
	row3.add_child(label3)
	row3.add_child(right_panel3)

	add_custom_control(row3)

	# -------------- Reset Scale Button --------------
	var row2 = HBoxContainer.new()
	row2.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var label2 = Label.new()
	label2.text = "Scale"
	label2.size_flags_horizontal = Control.SIZE_EXPAND
	label2.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT

	var right_panel2 = createRightPanel()
	var button = createScaleButton(object)
	
	right_panel2.add_child(button)
	row2.add_child(label2)
	row2.add_child(right_panel2)

	add_custom_control(row2)

func createPositionButton(object) -> Button:
	var button = Button.new()
	button.text = "Reset"
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.pressed.connect(func():
		undoRedo.create_action("Arky addon: Reset Position")
		undoRedo.add_undo_property(object, "position", object.position)
		undoRedo.add_do_property(object, "position", Vector2(0, 0))
		undoRedo.commit_action()
	)
	return button

func createScaleButton(object) -> Button:
	var button = Button.new()
	button.text = "Reset"
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.pressed.connect(func():
		undoRedo.create_action("Arky addon: Reset Scale")
		undoRedo.add_undo_property(object, "scale", object.scale)
		undoRedo.add_do_property(object, "scale", Vector2(1, 1))
		undoRedo.commit_action()
	)
	return button

func createCheckbox(object) -> CheckBox:
	var checkbox = CheckBox.new()
	checkbox.text = "On"
	
	# checkbox.button_pressed = true 
	checkbox.button_pressed = object.process_mode == Node.PROCESS_MODE_INHERIT
	checkbox.focus_mode = Control.FOCUS_NONE
	checkbox.size_flags_horizontal  = Control.SIZE_EXPAND
	checkbox.text = "On"
	# checkbox.button_pressed  = true

	checkbox.toggled.connect(func(enabled):
		print_rich("[color=#888b90]Arky Addon: Set process_mode[/color]")
		print_rich("[color=#888b90]Arky Addon: Toggle Visible if was visible[/color]")

		#If is not visible when enabled
		if not enabled:
			visibleStateBeforeChange = object.visible
			object.visible = enabled

		if enabled:
			object.visible = visibleStateBeforeChange

		object.set_process(enabled)
		object.set_physics_process(enabled)
		object.process_mode = Node.PROCESS_MODE_INHERIT if enabled else  Node.PROCESS_MODE_DISABLED 
	)

	return checkbox

func createHeader(font: FontFile) -> void:
	var header_panel = PanelContainer.new()
	header_panel.add_theme_stylebox_override("panel", header_stylebox())
	
	var header_label = Label.new()
	header_label.text = TITLE
	header_label.add_theme_font_override("font", font)

	#Vertical size
	header_panel.custom_minimum_size = Vector2(0, 5)
	
	#Alignament
	header_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	header_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	header_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	#Font
	header_label.add_theme_color_override("font_color", TITLE_FONT_COLOR)
	header_label.add_theme_font_size_override("font_size", TITLE_FONT_SIZE)
	
	header_panel.add_child(header_label)
	add_custom_control(header_panel)


func header_stylebox() -> StyleBoxFlat:
	var sb = StyleBoxFlat.new()
	sb.bg_color = TITLE_BACKGROUND_COLOR

	#Margin
	sb.content_margin_left = 0
	sb.content_margin_right = 0
	sb.content_margin_top = 0
	sb.content_margin_bottom = 0
	
	#Border
	sb.border_width_bottom = 0
	sb.border_color = Color("#40444c")
	
	#Corner radius
	sb.set_corner_radius_all(4)

	return sb


func createRightPanel() -> PanelContainer:
	var right_panel = PanelContainer.new()
	right_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	#Custom Width
	# right_panel.custom_minimum_size = Vector2(220, 0)  
	
	right_panel.add_theme_stylebox_override("panel", colored_stylebox(Color("#1d2229")))
	return right_panel

func colored_stylebox(color: Color) -> StyleBoxFlat:
	var sb = StyleBoxFlat.new()
	sb.bg_color = color
	sb.content_margin_left = 6
	sb.content_margin_right = 6
	sb.content_margin_top = 4
	sb.content_margin_bottom = 4
	sb.corner_radius_top_right = 4
	sb.corner_radius_bottom_right = 4
	return sb