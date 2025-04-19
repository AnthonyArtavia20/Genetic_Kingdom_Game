import os
import platform

env = Environment()

godot_cpp_path = os.path.join('..', 'godot-cpp')
godot_cpp_bin = os.path.join(godot_cpp_path, 'bin')
env.Append(CPPPATH=[
    godot_cpp_path,
    os.path.join(godot_cpp_path, 'include'),
    os.path.join(godot_cpp_path, 'include', 'core'),
    os.path.join(godot_cpp_path, 'include', 'gen'),
    os.path.join(godot_cpp_path, 'gen', 'include'),
    os.path.join(godot_cpp_path, 'gen', 'include', 'godot_cpp'),
    os.path.join(godot_cpp_path, 'gen', 'include', 'godot_cpp', 'classes'),
    os.path.join(godot_cpp_path, 'gen', 'include', 'godot_cpp', 'variant'),
    os.path.join(godot_cpp_path, 'gdextension'),
])

env.Append(LIBPATH=[godot_cpp_bin])
env.Append(LIBS=['godot-cpp'])
env.Append(CXXFLAGS=['-std=c++17', '-g', '-O2', '-fPIC'])

sources = [
    'gdexample.cpp',
    'register_types.cpp',
    "pathfinder/pathfinder.cpp",
    'pathfinder/astar_grid.cpp',
]

target = 'libgdexample.so'

env.SharedLibrary(target=target.replace('.so', ''), source=sources)
