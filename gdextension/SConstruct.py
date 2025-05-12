import os
import shutil
import platform

env = Environment()

# Ruta al godot-cpp
godot_cpp_path = os.path.join('..', 'godot-cpp')

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
    '#genetic',
    '#pathfinder'
])

env.Append(LIBPATH=[os.path.join(godot_cpp_path, 'bin')])
env.Append(LIBS=['godot-cpp'])
env.Append(CXXFLAGS=['-std=c++17', '-g', '-O2', '-fPIC'])

# Archivos fuente que se compilan
sources = [
    'gdexample.cpp',
    'register_types.cpp', #aquí vna los registros del A* y el algoritmo genético
    'pathfinder/pathfinder.cpp',
    'pathfinder/astar_grid.cpp',
    'genetic/GeneticAlgorithm.cpp',
    'genetic/GeneticManager.cpp',
]

# Nombre base sin extensión (SCons la agregará)
target = 'libgdexample'

# Compila la librería compartida en el directorio actual
so_file = env.SharedLibrary(target=target, source=sources)

# Ruta final donde queremos colocarla
output_dir = os.path.join('..', 'demo', 'gdextensiondemo', 'bin')
output_path = os.path.join(output_dir, f'{target}.so')

# Acción personalizada: mover la librería después de compilar
def move_lib_to_bin(source, target, env):
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)
    if os.path.exists(output_path):
        os.remove(output_path)
    shutil.copy(str(target[0]), output_path)
    print(f'📦 Librería copiada a {output_path}, pues el proyecto necesita esa librería en bin/')

# Asociar la acción personalizada a la compilación
env.AddPostAction(so_file, move_lib_to_bin)
