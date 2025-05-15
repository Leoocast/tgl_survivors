@tool
extends EditorPlugin

var inspectorPlugin

const INSPECTOR_PLUGIN = preload("res://addons/enabled_checkbox/inspector_plugin.gd")

func _enter_tree():
    inspectorPlugin = INSPECTOR_PLUGIN.new()
    add_inspector_plugin(inspectorPlugin)

func _exit_tree():
    remove_inspector_plugin(inspectorPlugin)