import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'core/router/app_router.dart';   
import 'core/dio/dio_client.dart';

// Repositories
import 'repository/auth_repository.dart';
import 'repository/tenant_repository.dart';
import 'repository/subject_repository.dart';
import 'repository/curso_repository.dart';
import 'repository/paralelo_repository.dart';
import 'repository/asignacion_repository.dart';
import 'repository/academic_period_repository.dart';
import 'repository/profesor_repository.dart';
import 'repository/estudiante_repository.dart';
import 'repository/padre_familia_repository.dart';
import 'repository/circular_repository.dart';
import 'repository/inscripcion_repository.dart';
import 'repository/anecdotario_repository.dart';
import 'repository/asistencia_repository.dart';

// ViewModels
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/tenant_viewmodel.dart';
import 'viewmodels/subject_repository.dart';
import 'viewmodels/curso_viewmodel.dart';
import 'viewmodels/paralelo_viewmodel.dart';
import 'viewmodels/asignacion_viewmodel.dart';
import 'viewmodels/academic_period_viewmodel.dart';
import 'viewmodels/profesor_viewmodel.dart';
import 'viewmodels/estudiante_viewmodel.dart';
import 'viewmodels/padre_familia_viewmodel.dart'; 
import 'viewmodels/circular_viewmodel.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'viewmodels/inscripcion_viewmodel.dart';
import 'viewmodels/estudiantes_clase_viewmodel.dart';
import 'viewmodels/anecdotario_viewmodel.dart';
import 'viewmodels/asistencia_viewmodel.dart';


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
          create: (_) => TenantViewModel(
            repository: TenantRepository(dio),
          ),
        ),

        // Subject
        ChangeNotifierProvider(
          create: (_) => SubjectViewModel(
            repository: SubjectRepository(dio),
          ),
        ),

        // Curso
        ChangeNotifierProvider(
          create: (_) => CursoViewModel(
            repository: CursoRepository(dio),
            periodoRepository: AcademicPeriodRepository(dio),
          ),
        ),

        // Paralelo
        ChangeNotifierProvider(
          create: (_) => ParaleloViewModel(
            repository: ParaleloRepository(dio),
          ),
        ),

        // Profesor
        ChangeNotifierProvider(
          create: (_) => ProfesorViewModel(
            repository: ProfesorRepository(dio),
          ),
        ),

        //  Estudiante
        ChangeNotifierProvider(
          create: (_) => EstudianteViewModel(
            repository: EstudianteRepository(dio),
          ),
        ),

        //  Padre de familia
        ChangeNotifierProvider(
          create: (_) => PadreFamiliaViewModel(
            repository: PadreFamiliaRepository(dio),
          ),
        ),

        // Periodo académico
        ChangeNotifierProvider(
          create: (_) => AcademicPeriodViewModel(
            repository: AcademicPeriodRepository(dio),
          )..loadPeriodoActivo(),
        ),

        // Asignación
        ChangeNotifierProvider(
          create: (_) => AsignacionViewModel(
            repository: AsignacionRepository(dio),
            periodoRepository: AcademicPeriodRepository(dio),
          ),
        ),

        ChangeNotifierProvider(
          create: (_) => CircularViewModel(
            repository: CircularRepository(dio),  
          ),
        ),
        ChangeNotifierProvider(
      create: (_) => InscripcionViewModel(
    repository: InscripcionRepository(dio),
    periodoRepository: AcademicPeriodRepository(dio),
  ),
),
ChangeNotifierProvider(
  create: (_) => EstudiantesClaseViewModel(
    repository:        InscripcionRepository(dio),
  ),
),
ChangeNotifierProvider(
  create: (_) => AnecdotarioViewModel(
    repository: AnecdotarioRepository(dio),
  ),
),
ChangeNotifierProvider(
  create: (_) => AsistenciaViewModel(
    repository: AsistenciaRepository(dio),
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