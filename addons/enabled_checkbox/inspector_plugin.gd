@tool
extends EditorInspectorPlugin

const fontRoute = "res://assets/fonts/NotoSans-Bold.ttf"

func _can_handle(object):
	# Aplica a todos los nodos, pero puedes filtrar por tipo si quieres
	return object is Node

func _parse_begin(object):

	var font := FontFile.new()
	font.load_dynamic_font(fontRoute)

	header(font)

	var row = HBoxContainer.new()
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	# ----- Columna izquierda (label) -----
	var label = Label.new()
	label.text = "Enabled"
	label.size_flags_horizontal = Control.SIZE_EXPAND
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT

	# Container a la derecha (con color)
	var right_panel = PanelContainer.new()
	right_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	# right_panel.custom_minimum_size = Vector2(220, 0)  # ajusta ancho si quieres
	right_panel.add_theme_stylebox_override("panel", get_colored_stylebox(Color("#1d2229")))

	# CheckBox dentro del panel
	var checkbox = CheckBox.new()
	checkbox.text = "On"
	checkbox.button_pressed = true
	checkbox.focus_mode = Control.FOCUS_NONE
	checkbox.size_flags_horizontal  = Control.SIZE_EXPAND
	right_panel.add_child(checkbox)

	# Armado final
	row.add_child(label)
	row.add_child(right_panel)
	add_custom_control(row)

	# var checkbox = CheckBox.new()
	checkbox.text = "On"
	checkbox.button_pressed  = true

	checkbox.toggled.connect(func(enabled):
		object.visible = enabled
		object.set_process(enabled)
		object.set_physics_process(enabled)
		object.process_mode = Node.PROCESS_MODE_INHERIT if enabled else  Node.PROCESS_MODE_DISABLED 
	)

func get_colored_stylebox(color: Color) -> StyleBoxFlat:
	var sb = StyleBoxFlat.new()
	sb.bg_color = color
	sb.content_margin_left = 6
	sb.content_margin_right = 6
	sb.content_margin_top = 4
	sb.content_margin_bottom = 4
	sb.corner_radius_top_right = 4
	sb.corner_radius_bottom_right = 4
	return sb

func get_header_stylebox() -> StyleBoxFlat:
	var sb = StyleBoxFlat.new()
	sb.bg_color = Color("#40444c")
	sb.content_margin_left = 0
	sb.content_margin_right = 0
	sb.content_margin_top = 0
	sb.content_margin_bottom = 0
	sb.border_width_bottom = 0
	sb.border_color = Color("#40444c")
	sb.set_corner_radius_all(4)
	return sb

func header(font: FontFile) -> void:
	var header_panel = PanelContainer.new()
	header_panel.add_theme_stylebox_override("panel", get_header_stylebox())
	var header_label = Label.new()

	header_panel.custom_minimum_size = Vector2(0, 5)  # Cambia 30 por el alto que quieras
	header_label.add_theme_font_override("font", font)
	header_label.text = "Arky Addons"
	header_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	header_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	header_label.add_theme_color_override("font_color", Color("#cdcfd2"))
	header_label.add_theme_font_size_override("font_size", 21)
	header_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	header_panel.add_child(header_label)
	add_custom_control(header_panel)