import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión de Tareas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Tarea> tareas = [];
  bool mostrarCompletadas = false;
  String filtroPrioridad = 'Todas';
  final TextEditingController _controllerNombre = TextEditingController();
  String selectedPrioridad = 'Baja';

  void agregarTarea() {
    final nombre = _controllerNombre.text;
    if (nombre.isEmpty) {
      return; // Puedes agregar un mensaje de error si lo deseas.
    }
    setState(() {
      tareas.add(Tarea(nombre, selectedPrioridad, 'Pendiente'));
      _controllerNombre.clear();
    });
  }

  void completarTarea(int index) {
    setState(() {
      if (tareas[index].estado == 'Pendiente') {
        tareas[index].estado = 'Completada';
      } else {
        tareas.removeAt(index);
      }
    });
  }

  String obtenerContadores() {
    final totalTareas = tareas.length;
    final totalCompletadas = tareas.where((t) => t.estado == 'Completada').length;
    return 'Total de tareas: $totalTareas\nTareas completadas: $totalCompletadas';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tareas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Campos de entrada y botones
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controllerNombre,
                    decoration: InputDecoration(hintText: 'Nombre de la tarea'),
                  ),
                ),
                DropdownButton<String>(
                  value: selectedPrioridad,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedPrioridad = newValue!;
                    });
                  },
                  items: ['Baja', 'Media', 'Alta'].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                ElevatedButton(
                  onPressed: agregarTarea,
                  child: Text('Agregar Tarea'),
                ),
              ],
            ),

            // Filtros
            Row(
              children: [
                Checkbox(
                  value: mostrarCompletadas,
                  onChanged: (bool? newValue) {
                    setState(() {
                      mostrarCompletadas = newValue!;
                    });
                  },
                ),
                Text('Mostrar solo completadas'),
                DropdownButton<String>(
                  value: filtroPrioridad,
                  onChanged: (String? newValue) {
                    setState(() {
                      filtroPrioridad = newValue!;
                    });
                  },
                  items: ['Todas', 'Baja', 'Media', 'Alta']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),

            // Lista de tareas
            Expanded(
              child: ListView.builder(
                itemCount: tareas.length,
                itemBuilder: (context, index) {
                  if (mostrarCompletadas && tareas[index].estado != 'Completada') {
                    return Container(); // No mostrar si la tarea no está completada
                  }
                  if (filtroPrioridad != 'Todas' && tareas[index].prioridad != filtroPrioridad) {
                    return Container(); // No mostrar si la prioridad no coincide
                  }

                  return ListTile(
                    title: Text(tareas[index].nombre),
                    subtitle: Text('${tareas[index].prioridad} - ${tareas[index].estado}'),
                    trailing: ElevatedButton(
                      onPressed: () => completarTarea(index),
                      child: Text(tareas[index].estado == 'Pendiente' ? 'Completar' : 'Eliminar'),
                    ),
                  );
                },
              ),
            ),
            // Contadores
            Text(obtenerContadores(), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class Tarea {
  String nombre;
  String prioridad;
  String estado;

  Tarea(this.nombre, this.prioridad, this.estado);
}
