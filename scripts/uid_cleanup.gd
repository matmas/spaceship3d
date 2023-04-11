#If UID references break, run this script (right click and choose run) to fix it.
@tool
extends EditorScript

# From https://github.com/perfoon/Abandoned-Spaceship-Godot-Demo
# All code Copyright (c) 2023 Jaanus Jaggo (Perfoon)
#
# MIT License
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


func _run() -> void:
	print("Re-saving resources:")
	for file in get_files_recursively("res://"):
		print(file)
		ResourceSaver.save(load(file))
	print("Done.")


func get_files_recursively(directory: String) -> Array[String]:
	var files: Array[String] = []
	for filename in DirAccess.get_files_at(directory):
		if filename.get_extension() in ["tscn", "tres"]:
			files.append(directory.path_join(filename))
	for d in DirAccess.get_directories_at(directory):
		files.append_array(get_files_recursively(directory.path_join(d)))
	return files
