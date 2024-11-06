import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class Tarea {
  String nombre;
  String prioridad; // 'Baja', 'Media', 'Alta'
  String estado; // 'Pendiente', 'Completada'
  DateTime fechaCreacion;

  Tarea({
    required this.nombre,
    required this.prioridad,
    required this.estado,
    required this.fechaCreacion,
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión de Tareas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TareasScreen(),
    );
  }
}

class TareasScreen extends StatefulWidget {
  @override
  _TareasScreenState createState() => _TareasScreenState();
}

class _TareasScreenState extends State<TareasScreen> {
  final List<Tarea> tareas = [];
  final TextEditingController _nombreController = TextEditingController();
  String _filtroPrioridad = 'Todas';
  bool _mostrarCompletadas = false;

  void _agregarTarea() {
    if (_nombreController.text.trim().isEmpty) {
      return;
    }
    setState(() {
      tareas.add(Tarea(
        nombre: _nombreController.text,
        prioridad: 'Baja',
        estado: 'Pendiente',
        fechaCreacion: DateTime.now(),
      ));
      _nombreController.clear();
    });
  }

  void _completarTarea(int index) {
    setState(() {
      if (tareas[index].estado == 'Pendiente') {
        tareas[index].estado = 'Completada';
      } else {
        tareas.removeAt(index);
      }
    });
  }

  void _toggleMostrarCompletadas(bool value) {
    setState(() {
      _mostrarCompletadas = value;
    });
  }

  void _cambiarFiltroPrioridad(String value) {
    setState(() {
      _filtroPrioridad = value;
    });
  }

  List<Tarea> getTareasFiltradas() {
    return tareas.where((tarea) {
      final estadoCondicion = _mostrarCompletadas ? tarea.estado == 'Completada' : true;
      final prioridadCondicion = _filtroPrioridad == 'Todas' || tarea.prioridad == _filtroPrioridad;
      return estadoCondicion && prioridadCondicion;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final tareasFiltradas = getTareasFiltradas();
    int totalTareas = tareas.length;
    int totalCompletadas = tareas.where((t) => t.estado == 'Completada').length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tareas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Entrada de nueva tarea
            TextField(
              controller: _nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre de la tarea',
                border: OutlineInputBorder(),
              ),
            ),
            DropdownButton<String>(
              value: 'Baja',
              items: ['Baja', 'Media', 'Alta'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  // Actualizar la prioridad de la nueva tarea
                });
              },
            ),
            ElevatedButton(
              onPressed: _agregarTarea,
              child: Text('Agregar Tarea'),
            ),
            Row(
              children: [
                Checkbox(
                  value: _mostrarCompletadas,
                  onChanged: _toggleMostrarCompletadas,
                ),
                Text('Mostrar solo completadas'),
              ],
            ),
            DropdownButton<String>(
              value: _filtroPrioridad,
              items: ['Todas', 'Baja', 'Media', 'Alta'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: _cambiarFiltroPrioridad,
            ),
            SizedBox(height: 20),
            // Mostrar las tareas
            Expanded(
              child: ListView.builder(
                itemCount: tareasFiltradas.length,
                itemBuilder: (context, index) {
                  final tarea = tareasFiltradas[index];
                  return Card(
                    color: _getPrioridadColor(tarea.prioridad),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(tarea.nombre),
                      subtitle: Text('${tarea.prioridad} - ${tarea.estado}'),
                      trailing: ElevatedButton(
                        onPressed: () => _completarTarea(index),
                        child: Text(tarea.estado == 'Pendiente' ? 'Completar' : 'Eliminar'),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Contadores
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Total de tareas: $totalTareas'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Tareas completadas: $totalCompletadas'),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPrioridadColor(String prioridad) {
    switch (prioridad) {
      case 'Baja':
        return Colors.green.shade100;
      case 'Media':
        return Colors.yellow.shade100;
      case 'Alta':
        return Colors.red.shade100;
      default:
        return Colors.white;
    }
  }
}
