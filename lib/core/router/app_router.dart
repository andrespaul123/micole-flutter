import 'package:go_router/go_router.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../models/profesor.dart';
import '../../models/curso.dart';
// Auth
import '../../screen/login/login_screen.dart';
import '../../screen/login/register_screen.dart'; 
// Director
import '../../screen/subject/subject_list_screen.dart';
import '../../screen/subject/subject_screen.dart';
import '../../screen/director/profesor_list_screen.dart';
import '../../screen/director/profesor_create_screen.dart';
import '../../screen/director/asignar_materia_screen.dart';
import '../../screen/director/asignar_horario_screen.dart';
import '../../screen/curso/curso_list_screen.dart';
import '../../screen/curso/curso_create_screen.dart';
import '../../screen/paralelo/paralelo_list_screen.dart';
import '../../screen/paralelo/paralelo_create_screen.dart';
import '../../screen/periodo_academico/periodo_list_screen.dart';
import '../../screen/periodo_academico/periodo_create_screen.dart';
import '../../screen/tenant/my_tenant_screen.dart';
import '../../screen/tenant/director_tenant_screen.dart';
import '../../screen/estudiante/estudiante_list_screen.dart';
import '../../screen/estudiante/estudiante_create_screen.dart';
import '../../screen/padre_familia/padre_list_screen.dart';
import '../../screen/padre_familia/padre_create_screen.dart';
import '../../screen/director/horario_profesor_screen.dart';
import '../../screen/horario/horario_curso_screen.dart';
import '../../screen/circular/circular_create_screen.dart';
import '../../screen/circular/circular_list_screen.dart';
import '../../screen/circular/circular_detail_screen.dart';
import '../../screen/inscripcion/inscripcion_create_screen.dart';
import '../../screen/inscripcion/inscripcion_list_screen.dart';
import '../../screen/profesor/mis_clases_screen.dart';

// Super Admin
import '../../screen/tenant/tenant_list_screen.dart';
import '../../screen/tenant_screen.dart';

// Layout
import '../layout/main_layout.dart';
import '../layout/home_dashboard.dart';


late GoRouter _routerInstance;

/// Redirige al login sin contexto (usado en el interceptor 401 de Dio).
void redirectToLogin() => _routerInstance.go('/login');

// ── Creación del router ────────────────────────────────────────────────────────
GoRouter createRouter(AuthViewModel authViewModel) {
  _routerInstance = GoRouter(
    initialLocation: authViewModel.isLoggedIn ? '/home' : '/login',

    // Se re-evalúa el redirect cada vez que AuthViewModel notifica cambios.
    refreshListenable: authViewModel,

    redirect: (context, state) {
      final loggedIn  = authViewModel.isLoggedIn;
      final isAuthPage = state.matchedLocation == '/login' ||
                         state.matchedLocation == '/register';

      if (!loggedIn && !isAuthPage) return '/login';
      if (loggedIn  &&  isAuthPage) return '/home';
      return null;
    },

    routes: [
      // ── Autenticación ────────────────────────────────────────────────
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (_, __) => const RegisterScreen(),
      ),

      // ── Shell principal (AppBar + BottomNav) ─────────────────────────
      ShellRoute(
        builder: (context, state, child) => MainLayout(
          child: child,
          //location: state.matchedLocation,
          location: state.matchedLocation,
        ),
        routes: [

          // ── Home ──────────────────────────────────────────────────────
          GoRoute(
            path: '/home',
            builder: (_, __) => const HomeDashboard(),
          ),

          // ── DIRECTOR: Materias ────────────────────────────────────────
          GoRoute(
            path: '/materias',
            builder: (_, __) => const SubjectListScreen(),
            routes: [
              GoRoute(
                path: 'create',
                builder: (_, __) => const SubjectScreen(),
              ),
            ],
          ),

          // ── DIRECTOR: Profesores ──────────────────────────────────────
          GoRoute(
            path: '/profesores',
            builder: (_, __) => const ProfesorListScreen(),
            routes: [
              GoRoute(
                path: 'create',
                builder: (_, __) => const ProfesorCreateScreen(),
              ),
              GoRoute(
                // extra: Profesor
                path: ':id/materia',
                builder: (_, state) {
                    final id = int.parse(state.pathParameters['id']!);
                    return AsignarMateriaScreen(profesorId: id);},
              ),
              GoRoute(
                // extra: Profesor
                path: ':id/horario',
                builder: (_, state) {
                    final id = int.parse(state.pathParameters['id']!);
                    return AsignarHorarioScreen(profesorId: id);},
              ),
              GoRoute(
                path: ':id/ver-horario',
                builder:(_,state){
                final id = int.parse(state.pathParameters['id']!);
                return HorarioProfesorScreen(profesorId: id);},
              ),

            ],
          ),
             GoRoute(
               path: '/estudiantes',
               builder: (_, __) => const EstudianteListScreen(),
              routes: [
              GoRoute(
              path: 'create',
              builder: (_, __) => const EstudianteCreateScreen(),
      ),
            ],
          ),
          GoRoute(
          path: '/padres',
          builder: (_, __) => const PadreListScreen(),
            routes: [
       GoRoute(
      path: 'create',
      builder: (_, __) => const PadreCreateScreen(),
    ),
  ],
),
          

          // ── DIRECTOR: Cursos ──────────────────────────────────────────
         GoRoute(
  path: '/cursos',
  builder: (_, __) => const CursoListScreen(),
  routes: [
    GoRoute(
      path: 'create',
      builder: (_, __) => const CursoCreateScreen(),
    ),

    GoRoute(
      path: ':cursoId/paralelos',
      builder: (_, state) {
        final cursoId = int.parse(state.pathParameters['cursoId']!);
        return ParaleloListScreen(cursoId: cursoId);
      },
      routes: [
        GoRoute(
          path: 'create',
          builder: (_, state) {
            final cursoId = int.parse(state.pathParameters['cursoId']!);
            return ParaleloCreateScreen(cursoId: cursoId);
          },
        ),
        GoRoute(
          path: ':paraleloId/horario',
          builder: (_, state) {
            final cursoId    = int.parse(state.pathParameters['cursoId']!);
            final paraleloId = int.parse(state.pathParameters['paraleloId']!);
            return HorarioCursoScreen(
              cursoId:    cursoId,
              paraleloId: paraleloId,
            );
          },
        ),
      ],
    ),
  ],
),

          // ── DIRECTOR: Periodos académicos ─────────────────────────────
          GoRoute(
            path: '/periodos',
            builder: (_, __) => const PeriodoListScreen(),
            routes: [
              GoRoute(
                path: 'create',
                builder: (_, __) => const PeriodoCreateScreen(),
              ),
            ],
          ),

          // ── DIRECTOR: Mi colegio ──────────────────────────────────────
          GoRoute(
            path: '/colegio',
            builder: (_, __) => const MyTenantScreen(),
            routes: [
              GoRoute(
                path: 'editar',
                builder: (_, __) => const DirectorTenantScreen(),
              ),
            ],
          ),

          // ── SUPER ADMIN: Colegios ─────────────────────────────────────
          GoRoute(
            path: '/colegios',
            builder: (_, __) => const TenantListScreen(),
            routes: [
              GoRoute(
                path: 'create',
                builder: (_, __) => const TenantScreen(),
              ),
            ],
          ),
          GoRoute(
       path: '/circulares',
  builder: (_, __) => const CircularListScreen(),
  routes: [
    GoRoute(
      path: 'create',
      builder: (_, __) => const CircularCreateScreen(),
    ),
    GoRoute(
      path: ':id',
      builder: (_, state) {
        final id = int.parse(state.pathParameters['id']!);
        return CircularDetailScreen(id: id);
      },
    ),
  ],
),
GoRoute(
  path: '/inscripciones',
  builder: (_, __) => const InscripcionListScreen(),
  routes: [
    GoRoute(
      path: 'create',
      builder: (_, __) => const InscripcionCreateScreen(),
    ),
  ],
),
GoRoute(
  path: '/mis-clases',
  builder: (_, __) => const MisClasesScreen(),
),
        ],
      ),
    ],
  );

  return _routerInstance;
}