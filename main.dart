import 'package:flutter/material.dart';

void main() {
  runApp(GestionTareasApp());
}

class GestionTareasApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión de Tareas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TareasPage(),
    );
  }
}

class Tarea {
  String nombre;
  String prioridad;
  bool completada;

  Tarea({required this.nombre, required this.prioridad, this.completada = false});
}

class TareasPage extends StatefulWidget {
  @override
  _TareasPageState createState() => _TareasPageState();
}

class _TareasPageState extends State<TareasPage> {
  final TextEditingController nombreController = TextEditingController();
  String prioridadSeleccionada = 'Baja';
  bool mostrarSoloCompletadas = false;
  List<Tarea> tareas = [];

  void agregarTarea() {
    if (nombreController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('El nombre de la tarea no puede estar vacío.')),
      );
      return;
    }

    setState(() {
      tareas.add(Tarea(nombre: nombreController.text, prioridad: prioridadSeleccionada));
      nombreController.clear();
    });
  }

  void completarOEliminarTarea(int index) {
    setState(() {
      if (tareas[index].completada) {
        tareas.removeAt(index);
      } else {
        tareas[index].completada = true;
      }
    });
  }

  Color getColorPorPrioridad(String prioridad) {
    switch (prioridad) {
      case 'Alta':
        return Colors.red[100]!;
      case 'Media':
        return Colors.yellow[100]!;
      case 'Baja':
      default:
        return Colors.green[100]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Tareas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Formulario de entrada de tareas
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: nombreController,
                    decoration: InputDecoration(
                      labelText: 'Nombre de la tarea',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: prioridadSeleccionada,
                  items: ['Baja', 'Media', 'Alta']
                      .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                      .toList(),
                  onChanged: (valor) {
                    setState(() {
                      prioridadSeleccionada = valor!;
                    });
                  },
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: agregarTarea,
                  child: Text('Agregar'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: mostrarSoloCompletadas,
                      onChanged: (value) {
                        setState(() {
                          mostrarSoloCompletadas = value!;
                        });
                      },
                    ),
                    Text('Mostrar solo completadas'),
                  ],
                ),
                DropdownButton<String>(
                  value: 'Todas',
                  items: ['Todas', 'Baja', 'Media', 'Alta']
                      .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                      .toList(),
                  onChanged: (valor) {
                    // Lógica para filtrar por prioridad
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: tareas.length,
                itemBuilder: (context, index) {
                  final tarea = tareas[index];

                  if (mostrarSoloCompletadas && !tarea.completada) {
                    return SizedBox.shrink();
                  }

                  return Card(
                    color: getColorPorPrioridad(tarea.prioridad),
                    child: ListTile(
                      title: Text(
                        tarea.nombre,
                        style: TextStyle(
                          decoration: tarea.completada
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      subtitle: Text('Prioridad: ${tarea.prioridad}'),
                      trailing: ElevatedButton(
                        onPressed: () => completarOEliminarTarea(index),
                        child: Text(tarea.completada ? 'Eliminar' : 'Completar'),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Text('Total de tareas: ${tareas.length}'),
            Text('Tareas completadas: ${tareas.where((t) => t.completada).length}'),
          ],
        ),
      ),
    );
  }
}
