import 'package:flutter/material.dart';
import 'package:front_colegio/feature/estudiante/estudiante_agenda/entrega_tarea/entrega_tarea_repository.dart';
import 'package:front_colegio/feature/estudiante/estudiante_agenda/entrega_tarea/entrega_tarea_viewmodel.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'core/router/app_router.dart';
import 'core/dio/dio_client.dart';

// Repositories
import 'feature/login/auth_repository.dart';
import 'feature/login/auth_viewmodel.dart';
import 'feature/tenant/tenant_repository.dart';
import 'feature/tenant/tenant_viewmodel.dart';
import 'feature/subject/subject_repository.dart';
import 'feature/subject/subject_viewmodel.dart';
import 'feature/curso/curso_repository.dart';
import 'feature/curso/curso_viewmodel.dart';
import 'feature/paralelo/paralelo_repository.dart';
import 'feature/paralelo/paralelo_viewmodel.dart';
import 'feature/asignacion_horario/asignacion_repository.dart';
import 'feature/asignacion_horario/asignacion_viewmodel.dart';
import 'feature/profesor/profesor_repository.dart';
import 'feature/profesor/profesor_viewmodel.dart';
import 'feature/estudiante/estudiante_repository.dart';
import 'feature/estudiante/estudiante_viewmodel.dart';
import 'feature/padre/padre_familia_repository.dart';
import 'feature/padre/padre_familia_viewmodel.dart';
import 'feature/periodo_academico/academic_period_repository.dart';
import 'feature/periodo_academico/academic_period_viewmodel.dart';
import 'feature/periodo_evaluacion/periodo_evaluacion_repository.dart';
import 'feature/periodo_evaluacion/periodo_evaluacion_viewmodel.dart';
import 'feature/circulares/circular_repository.dart';
import 'feature/circulares/circular_viewmodel.dart';
import 'feature/inscripcion/inscripcion_repository.dart';
import 'feature/inscripcion/inscripcion_viewmodel.dart';
import 'feature/estudiante/estudiante_horario/estudiante_horario_repository.dart';
import 'feature/estudiante/estudiante_horario/estudiante_horario_viewmodel.dart';
import 'feature/estudiante/estudiante_materias/estudiante_materia_repository.dart';
import 'feature/estudiante/estudiante_materias/estudiante_materia_viewmodel.dart';
import 'feature/estudiante/estudiante_agenda/estudiante_agenda_repository.dart';
import 'feature/estudiante/estudiante_agenda/estudiante_agenda_viewmodel.dart';
import 'feature/anecdotario/anecdotario_repository.dart';
import 'feature/anecdotario/anecdotario_viewmodel.dart';
import 'feature/asistencia/asistencia_repository.dart';
import 'feature/asistencia/asistencia_viewmodel.dart';
import 'feature/agenda/agenda_repository.dart';
import 'feature/agenda/agenda_viewmodel.dart';
import 'feature/modulos/module_repository.dart';
import 'feature/modulos/module_viewmodel.dart';
import 'feature/criterio/criterio_repository.dart';
import 'feature/criterio/criterio_viewmodel.dart';
import 'feature/libro_calificaciones/libro_calificaciones_repository.dart';
import 'feature/libro_calificaciones/libro_calificaciones_viewmodel.dart';
import 'feature/padre_agenda/padre_agenda_repository.dart';
import 'feature/padre_agenda/padre_agenda_viewmodel.dart';
import 'feature/padre_asistencia/padre_asistencia_repository.dart';
import 'feature/padre_asistencia/padre_asistencia_viewmodel.dart';
import 'feature/padre_anecdotario/padre_anecdotario_repository.dart';
import 'feature/padre_anecdotario/padre_anecdotario_viewmodel.dart';
import 'feature/padre_nota/padre_nota_repository.dart';
import 'feature/padre_nota/padre_nota_viewmodel.dart';
import  'feature/estudiante/estudiantes_clase_viewmodel.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  setUrlStrategy(PathUrlStrategy());
  WidgetsFlutterBinding.ensureInitialized();

  final dio = DioClient.create();
  final authViewModel = AuthViewModel(repository: AuthRepository(dio));
  await authViewModel.loadSession();
  final router = createRouter(authViewModel);

  runApp(
    MultiProvider(
      providers: [
        // Auth
        ChangeNotifierProvider.value(value: authViewModel),
        //  Tenant
        ChangeNotifierProvider(
          create: (_) => TenantViewModel(repository: TenantRepository(dio)),
        ),

        // Subject
        ChangeNotifierProvider(
          create: (_) => SubjectViewModel(repository: SubjectRepository(dio)),
        ),

        // Curso
        ChangeNotifierProvider(
          create:
              (_) => CursoViewModel(
                repository: CursoRepository(dio),
                periodoRepository: AcademicPeriodRepository(dio),
              ),
        ),

        // Paralelo
        ChangeNotifierProvider(
          create: (_) => ParaleloViewModel(repository: ParaleloRepository(dio)),
        ),

        // Profesor
        ChangeNotifierProvider(
          create: (_) => ProfesorViewModel(repository: ProfesorRepository(dio)),
        ),

        //  Estudiante
        ChangeNotifierProvider(
          create:
              (_) => EstudianteViewModel(repository: EstudianteRepository(dio)),
        ),

        //  Padre de familia
        ChangeNotifierProvider(
          create:
              (_) => PadreFamiliaViewModel(
                repository: PadreFamiliaRepository(dio),
              ),
        ),

        // Periodo académico
        ChangeNotifierProvider(
          create:
              (_) => AcademicPeriodViewModel(
                repository: AcademicPeriodRepository(dio),
              )..loadPeriodoActivo(),
        ),
        ChangeNotifierProvider(
          create:
              (_) => PeriodoEvaluacionViewModel(
                repository: PeriodoEvaluacionRepository(dio),
              ),
        ),
        // Asignación
        ChangeNotifierProvider(
          create:
              (_) => AsignacionViewModel(
                repository: AsignacionRepository(dio),
                periodoRepository: AcademicPeriodRepository(dio),
              ),
        ),

        ChangeNotifierProvider(
          create: (_) => CircularViewModel(repository: CircularRepository(dio)),
        ),
        ChangeNotifierProvider(
          create:
              (_) => InscripcionViewModel(
                repository: InscripcionRepository(dio),
                periodoRepository: AcademicPeriodRepository(dio),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (_) => EstudiantesClaseViewModel(
                repository: InscripcionRepository(dio),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (_) =>
                  AnecdotarioViewModel(repository: AnecdotarioRepository(dio)),
        ),
        ChangeNotifierProvider(
          create:
              (_) => AsistenciaViewModel(repository: AsistenciaRepository(dio)),
        ),
        ChangeNotifierProvider(
          create: (_) => AgendaViewModel(repository: AgendaRepository(dio)),
        ),
        ChangeNotifierProvider(
          create: (_) => ModuleViewModel(repository: ModuleRepository(dio)),
        ),
        ChangeNotifierProvider(
          create: (_) => CriterioViewModel(repository: CriterioRepository(dio)),
        ),
        ChangeNotifierProvider(
          create:
              (_) => LibroCalificacionesViewModel(
                repository: LibroCalificacionesRepository(dio),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (_) =>
                  PadreAgendaViewModel(repository: PadreAgendaRepository(dio)),
        ),
        ChangeNotifierProvider(
          create:
              (_) => PadreAsistenciaViewModel(
                repository: PadreAsistenciaRepository(dio),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (_) => PadreAnecdotarioViewModel(
                repository: PadreAnecdotarioRepository(dio),
              ),
        ),
        ChangeNotifierProvider(
  create: (_) => EstudianteHorarioViewModel(
    repository: EstudianteHorarioRepository(dio),
  ),
),
ChangeNotifierProvider(
  create: (_) =>
      EstudianteMateriaViewModel(
    repository:
        EstudianteMateriaRepository(
      dio,
    ),
  ),
),
        ChangeNotifierProvider(
          create:
              (_) => PadreNotaViewModel(repository: PadreNotaRepository(dio)),
        ),
        ChangeNotifierProvider(create: 
        (_) => EstudianteAgendaViewModel(repository: EstudianteAgendaRepository(dio))),
ChangeNotifierProvider(
  create: (_) => EntregaTareaViewModel(
    repository: EntregaTareaRepository(dio),
  ),
),
      ],
      child: MyApp(router: router),
    ),
  );
}

class MyApp extends StatelessWidget {
  final GoRouter router;
  const MyApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MI COLE APP',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}
