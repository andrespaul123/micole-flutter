import 'package:flutter/material.dart';
import 'package:front_colegio/models/academic_period.dart';
import '../models/asignacion.dart';
import '../repository/asignacion_repository.dart';
import '../repository/academic_period_repository.dart';
import '../models/horario_curso.dart';
import '../models/mi_clase.dart';


class AsignacionViewModel extends ChangeNotifier {
  final AsignacionRepository repository;
  final AcademicPeriodRepository periodoRepository;

  AsignacionViewModel({required this.repository, required this.periodoRepository});

  bool loading = false;
  bool creating = false;

  Map<String, List<Asignacion>> horario = {};
  AcademicPeriod? periodoActivo;
  List<MiClase> misClases = [];
  List<AcademicPeriod> periodosProfesor = [];
  AcademicPeriod? periodoSeleccionadoClases;
  bool loadingClases = false;

   Future<void> loadPeriodo() async {
    periodoActivo = await periodoRepository.getPeriodoActivo();
    notifyListeners();
  }

  Future<void> loadHorario(int profesorId) async {
    loading = true;
    notifyListeners();

    horario = await repository.getHorario(profesorId);

    loading = false;
    notifyListeners();
  }
Future<String?> crearAsignacion({
    required int profesorId,
    required int subjectId,
    required int cursoId,
    required int paraleloId,
    required String dia,
    required String horaInicio,
    required String horaFin,
  }) async {
    if (creating) return "Ya se está creando una asignación";

    creating = true;
    notifyListeners();

    try {
      // 🔥 cargar periodo si no existe
      if (periodoActivo == null) {
        await loadPeriodo();
      }

      // 🔥 VALIDACIÓN IMPORTANTE
      if (periodoActivo == null || periodoActivo!.id == null) {
        return "No hay periodo académico activo";
      }

      final error = await repository.crearAsignacion(
        periodoId: periodoActivo!.id!,
        profesorId: profesorId,
        subjectId: subjectId,
        cursoId: cursoId,
        paraleloId: paraleloId,
        dia: dia,
        horaInicio: horaInicio,
        horaFin: horaFin,
      );

      if (error == null) {
        await loadHorario(profesorId);
      }

      return error;
    } finally {
      creating = false;
      notifyListeners();
    }
  }

  Map<String, List<HorarioItem>> horarioCurso = {};
bool loadingCurso = false;

/* Future<void> loadHorarioCurso({
  required int periodoId,
  required int cursoId,
  required int paraleloId,
}) async {
  loadingCurso = true;
  notifyListeners();

  horarioCurso = await repository.getHorarioCurso(
    periodoId:  periodoId,
    cursoId:    cursoId,
    paraleloId: paraleloId,
  );

  loadingCurso = false;
  notifyListeners();
}
} */
/* Future<void> loadHorarioCurso({
  required int cursoId,
  required int paraleloId,
}) async {
  loadingCurso = true;
  notifyListeners();

  // 🔥 ASEGURAR PERIODO
  if (periodoActivo == null) {
    await loadPeriodo();
  }

  if (periodoActivo == null) {
    horarioCurso = {};
    loadingCurso = false;
    notifyListeners();
    return;
  }

  horarioCurso = await repository.getHorarioCurso(
    periodoId:  periodoActivo!.id!,
    cursoId:    cursoId,
    paraleloId: paraleloId,
  );

  loadingCurso = false;
  notifyListeners();
} */
Future<void> loadHorarioCurso({
  required int cursoId,
  required int paraleloId,
}) async {
  loadingCurso = true;
  notifyListeners();

  // 🔥 asegurar periodo
  if (periodoActivo == null) {
    await loadPeriodo();
  }

  // 🔥 si no hay periodo → limpiar y salir
  if (periodoActivo == null) {
    horarioCurso = {};
    loadingCurso = false;
    notifyListeners();
    return;
  }

  horarioCurso = await repository.getHorarioCurso(
    periodoId: periodoActivo!.id!,
    cursoId: cursoId,
    paraleloId: paraleloId,
  );

  loadingCurso = false;
  notifyListeners();
}

Future<void> loadPeriodosYClases() async {
  loadingClases = true;
  notifyListeners();

  periodosProfesor = await periodoRepository.getPeriodos();

  if (periodosProfesor.isNotEmpty) {
    periodoSeleccionadoClases = periodosProfesor.firstWhere(
      (p) => p.activo == true,
      orElse: () => periodosProfesor.first,
    );
    await _cargarMisClases();
  } else {
    loadingClases = false;
    notifyListeners();
  }
}
Future<void> cambiarPeriodoClases(AcademicPeriod periodo) async {
  periodoSeleccionadoClases = periodo;
  misClases = [];
  notifyListeners();
  await _cargarMisClases();
}

Future<void> _cargarMisClases() async {
  if (periodoSeleccionadoClases?.id == null) return;
  loadingClases = true;
  notifyListeners();
  misClases = await repository.getMisClases(
      periodoSeleccionadoClases!.id!);
  loadingClases = false;
  notifyListeners();
}
}