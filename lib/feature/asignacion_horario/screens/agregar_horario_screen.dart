import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widgest/auth_card.dart';
import '../asignacion_viewmodel.dart';

class AgregarHorarioScreen extends StatefulWidget {
  final int asignacionId;
  final int profesorId;

  const AgregarHorarioScreen({
    super.key,
    required this.asignacionId,
    required this.profesorId,
  });

  @override
  State<AgregarHorarioScreen> createState() =>
      _AgregarHorarioScreenState();
}

class _AgregarHorarioScreenState
    extends State<AgregarHorarioScreen> {
  final _formKey = GlobalKey<FormState>();

  final _horaInicioController =
      TextEditingController();

  final _horaFinController =
      TextEditingController();

  String _dia = "Lunes";

  final List<String> dias = const [
    "Lunes",
    "Martes",
    "Miercoles",
    "Jueves",
    "Viernes",
    "Sabado",
  ];

  @override
  void dispose() {
    _horaInicioController.dispose();
    _horaFinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AsignacionViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text("Agregar horario"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: AuthCard(
            child: Form(
              key: _formKey,
              child: Column(
                children: [

                  const Text(
                    "Nuevo horario",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 25),

                  DropdownButtonFormField<String>(
                    value: _dia,
                    decoration: const InputDecoration(
                      labelText: "Día",
                      border: OutlineInputBorder(),
                    ),
                    items: dias
                        .map(
                          (d) => DropdownMenuItem(
                            value: d,
                            child: Text(d),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _dia = value!;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _horaInicioController,
                    decoration: const InputDecoration(
                      labelText: "Hora inicio",
                      hintText: "07:00",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty) {
                        return "Ingrese la hora de inicio";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _horaFinController,
                    decoration: const InputDecoration(
                      labelText: "Hora fin",
                      hintText: "09:00",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty) {
                        return "Ingrese la hora de fin";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: vm.creating
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.save),

                      label: Text(
                        vm.creating
                            ? "Guardando..."
                            : "Guardar horario",
                      ),

                      onPressed: vm.creating
                          ? null
                          : () async {

                              if (!_formKey.currentState!
                                  .validate()) {
                                return;
                              }

                              final ok =
                                  await vm.agregarHorario(
                                asignacionId:
                                    widget.asignacionId,
                                profesorId:
                                    widget.profesorId,
                                dia: _dia,
                                horaInicio:
                                    _horaInicioController
                                        .text,
                                horaFin:
                                    _horaFinController
                                        .text,
                              );

                              if (!mounted) return;

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                SnackBar(
                                  content: Text(
                                    ok
                                        ? "Horario agregado correctamente"
                                        : vm.error ??
                                            "Error",
                                  ),
                                ),
                              );  
                            },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}