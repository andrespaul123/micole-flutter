import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../subject/subject.dart';
import '../../curso/curso.dart';
import '../../paralelo/paralelo.dart';

import '../asignacion_viewmodel.dart';
import '../../profesor/profesor_viewmodel.dart';
import '../../curso/curso_viewmodel.dart';
import '../../paralelo/paralelo_viewmodel.dart';

import '../../../core/widgest/auth_card.dart';

class AsignarHorarioScreen extends StatefulWidget {
  final int profesorId;

  const AsignarHorarioScreen({
    super.key,
    required this.profesorId,
  });

  @override
  State<AsignarHorarioScreen> createState() => _AsignarHorarioScreenState();
}

class _AsignarHorarioScreenState extends State<AsignarHorarioScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _dia;
  Subject? _subject;
  Curso? _curso;
  Paralelo? _paralelo;

  TimeOfDay? _horaInicio;
  TimeOfDay? _horaFin;

  final _dias = [
    'Lunes',
    'Martes',
    'Miercoles',
    'Jueves',
    'Viernes',
    'Sabado',
  ];

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final profVM = context.read<ProfesorViewModel>();
      final cursoVM = context.read<CursoViewModel>();
      final paraleloVM = context.read<ParaleloViewModel>();

      await profVM.loadSubjectsProfesor(widget.profesorId);
      await cursoVM.loadCursos();
      await paraleloVM.loadParalelos();
    });
  }

  String _formatTime(TimeOfDay t) {
    return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}:00';
  }

  Future<void> _pickTime(bool isInicio) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        if (isInicio) {
          _horaInicio = picked;
        } else {
          _horaFin = picked;
        }
      });
    }
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    if (_dia == null ||
        _subject == null ||
        _curso == null ||
        _paralelo == null ||
        _horaInicio == null ||
        _horaFin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos')),
      );
      return;
    }

    final inicio = _horaInicio!.hour * 60 + _horaInicio!.minute;
    final fin = _horaFin!.hour * 60 + _horaFin!.minute;

    if (fin <= inicio) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La hora fin debe ser mayor')),
      );
      return;
    }

    FocusScope.of(context).unfocus();

    final vm = context.read<AsignacionViewModel>();

    final success = await vm.crearAsignacion(
      profesorId: widget.profesorId,
      subjectId: _subject!.id!,
      cursoId: _curso!.id!,
      paraleloId: _paralelo!.id!,
      dia: _dia!,
      horaInicio: _formatTime(_horaInicio!),
      horaFin: _formatTime(_horaFin!),
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Horario asignado correctamente')),
      );
      context.go('/profesores');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.error ?? 'Error al asignar horario')),
      );
    }
  }

  InputDecoration _dropdownDecoration(String hint, IconData icon) {
    return InputDecoration(
      labelText: hint,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _timeTile({
    required String label,
    required TimeOfDay? value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.access_time),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          value == null ? 'Seleccionar' : _formatTime(value),
          style: TextStyle(
            color: value == null ? Colors.grey.shade600 : Colors.black87,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AsignacionViewModel>();
    final profVM = context.watch<ProfesorViewModel>();
    final cursoVM = context.watch<CursoViewModel>();
    final paraleloVM = context.watch<ParaleloViewModel>();

    final paralelos = _curso == null
        ? paraleloVM.paralelos
        : paraleloVM.paralelos.where((p) => p.cursoId == _curso!.id).toList();

    final loading = vm.loading || profVM.loading || cursoVM.loading;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(title: const Text('Asignar horario')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : AuthCard(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.event_available,
                        size: 60, color: Colors.blue),
                    const SizedBox(height: 10),
                    const Text(
                      'Asignar horario',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    DropdownButtonFormField<String>(
                      value: _dia,
                      decoration: _dropdownDecoration('Día', Icons.calendar_today),
                      items: _dias
                          .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                          .toList(),
                      onChanged: (v) => setState(() => _dia = v),
                      validator: (v) => v == null ? 'Seleccione un día' : null,
                    ),
                    const SizedBox(height: 16),

                    _timeTile(
                      label: 'Hora inicio',
                      value: _horaInicio,
                      onTap: () => _pickTime(true),
                    ),
                    const SizedBox(height: 16),

                    _timeTile(
                      label: 'Hora fin',
                      value: _horaFin,
                      onTap: () => _pickTime(false),
                    ),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<Subject>(
                      value: _subject,
                      decoration: _dropdownDecoration('Materia', Icons.menu_book),
                      items: profVM.subjectsProfesor
                          .map((s) => DropdownMenuItem(
                                value: s,
                                child: Text(s.name ?? ''),
                              ))
                          .toList(),
                      onChanged: (v) => setState(() => _subject = v),
                      validator: (v) => v == null ? 'Seleccione una materia' : null,
                    ),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<Curso>(
                      value: _curso,
                      decoration: _dropdownDecoration('Curso', Icons.class_),
                      items: cursoVM.cursos
                          .map((c) => DropdownMenuItem(
                                value: c,
                                child: Text('${c.nombre} · ${c.nivel}'),
                              ))
                          .toList(),
                      onChanged: (v) {
                        setState(() {
                          _curso = v;
                          _paralelo = null;
                        });
                      },
                      validator: (v) => v == null ? 'Seleccione un curso' : null,
                    ),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<Paralelo>(
                      value: _paralelo,
                      decoration: _dropdownDecoration('Paralelo', Icons.groups),
                      items: paralelos
                          .map((p) => DropdownMenuItem(
                                value: p,
                                child: Text('${p.nombre} · ${p.turno ?? ''}'),
                              ))
                          .toList(),
                      onChanged: (v) => setState(() => _paralelo = v),
                      validator: (v) => v == null ? 'Seleccione un paralelo' : null,
                    ),

                    if (vm.error != null) ...[
                      const SizedBox(height: 14),
                      Text(
                        vm.error!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: vm.creating ? null : _guardar,
                        child: vm.creating
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Guardar'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}