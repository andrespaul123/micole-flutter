
import 'package:front_colegio/feature/agenda/screens/entregas_list_screen.dart';

import '../../feature/agenda/screens/agenda_create_screen.dart';
import '../../feature/agenda/screens/agenda_detail_screen.dart';
import '../../feature/agenda/screens/agenda_list_screen.dart';
import '../../feature/anecdotario/screens/anecdotario_create_screen.dart';
import '../../feature/anecdotario/screens/anecdotario_list_screen.dart';
import '../../feature/asignacion_horario/screens/agregar_horario_screen.dart';
import '../../feature/asignacion_horario/screens/materias_asignadas_screen.dart';
import '../../feature/asistencia/screens/asistencia_create_screen.dart';
import '../../feature/criterio/screens/CriterioScreen.dart';
import '../../feature/estudiante/estudiante_agenda/entrega_tarea/screen/estudiante_entrega_tarea_screen.dart';
import '../../feature/estudiante/estudiante_agenda/screens/estudiante_agenda_screen.dart';
import '../../feature/estudiante/estudiante_biblioteca/screens/estudiante_biblioteca_screen.dart';
import '../../feature/estudiante/estudiante_horario/screens/estudiante_horario_screen.dart';
import '../../feature/estudiante/estudiante_materias/screens/estudiante_materia_detalle_screen.dart';
import '../../feature/estudiante/estudiante_materias/screens/estudiante_materias_screen.dart';
import '../../feature/estudiante/screens/estudiante_edit_screen.dart';
import '../../feature/libro_calificaciones/screens/libro_calificaciones_screen.dart';
import '../../feature/padre/screens/mis_hijos_screen.dart';
import '../../feature/padre/screens/padre_asignar_estudiante_screen.dart';
import '../../feature/padre/screens/padre_dashboard_screen.dart';
import '../../feature/padre/screens/padre_edit_screen.dart';
import '../../feature/padre_agenda/padre_agenda.dart';
import '../../feature/padre_agenda/screens/padre_agenda_screen.dart';
import '../../feature/padre_anecdotario/screens/padre_anecdotario_screen.dart';
import '../../feature/padre_asistencia/screens/padre_asistencia_screen.dart';
import '../../feature/padre_nota/screens/padre_nota_screen.dart';
import 'package:front_colegio/feature/profesor/screens/asignar_materia_screen.dart';
import '../../feature/profesor/screens/clase_dashboard_screen.dart';
import '../../feature/profesor/screens/mis_clases_screen.dart';
import '../../feature/profesor/screens/profesor_edit_screen.dart';
import '../../feature/subject/screens/subject_edit_screen.dart';
import 'package:go_router/go_router.dart';
import '../../feature/login/auth_viewmodel.dart';
// Auth
import '../../feature/login/screens/login_screen.dart';
import '../../feature/login/screens/register_screen.dart';
// Director
import '../../feature/subject/screens/subject_list_screen.dart';
import '../../feature/subject/screens/subject_screen.dart';
import '../../feature/profesor/screens/profesor_list_screen.dart';
import '../../feature/profesor/screens/profesor_create_screen.dart';

import '../../feature/estudiante/screens/estudiante_list_screen.dart';
import '../../feature/estudiante/screens/estudiante_create_screen.dart';
import '../../feature/padre/screens/padre_list_screen.dart';
import '../../feature/padre/screens/padre_create_screen.dart';

import '../../feature/curso/screens/curso_list_screen.dart';
import '../../feature/curso/screens/curso_create_screen.dart';
import '../../feature/paralelo/screens/paralelo_list_screen.dart';
import '../../feature/paralelo/screens/paralelo_create_screen.dart';
import '../../feature/periodo_academico/screens/periodo_list_screen.dart';
import '../../feature/periodo_academico/screens/periodo_create_screen.dart';
import '../../feature/periodo_evaluacion/screens/PeriodoEvaluacionCreateScreen.dart';
import '../../feature/periodo_evaluacion/screens/PeriodoEvaluacionListScreen.dart';

import '../../feature/tenant/screens/tenant_list_screen.dart';
import '../../feature/tenant/screens/tenant_screen.dart';
import '../../feature/tenant/screens/my_tenant_screen.dart';
import '../../feature/tenant/screens/director_tenant_screen.dart';

import '../../feature/modulos/screens/module_screen.dart';
import '../../feature/circulares/screens/circular_list_screen.dart';
import '../../feature/circulares/screens/circular_create_screen.dart';
import '../../feature/circulares/screens/circular_detail_screen.dart';

import '../../feature/inscripcion/screens/inscripcion_list_screen.dart';
import '../../feature/inscripcion/screens/inscripcion_create_screen.dart';

import '../../feature/asignacion_horario/screens/horario_curso_screen.dart';
import '../../feature/asignacion_horario/screens/horario_profesor_screen.dart';
import '../../feature/asignacion_horario/screens/asignar_horario_screen.dart';
import '../../feature/agenda/screens/EntregaDetalleProfesorScreen.dart';
// Layout
import '../layout/main_layout.dart';
import '../layout/home_dashboard.dart';

late GoRouter _routerInstance;

// Redirige al login sin contexto (usado en el interceptor 401 de Dio).
void redirectToLogin() => _routerInstance.go('/login');

GoRouter createRouter(AuthViewModel authViewModel) {
  _routerInstance = GoRouter(
    initialLocation: authViewModel.isLoggedIn ? '/home' : '/login',

    // Se re-evalúa el redirect cada vez que AuthViewModel notifica cambios.
    refreshListenable: authViewModel,

    redirect: (context, state) {
      final loggedIn = authViewModel.isLoggedIn;
      final isAuthPage =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      if (!loggedIn && !isAuthPage) return '/login';
      if (loggedIn && isAuthPage) return '/home';
      return null;
    },

    routes: [
      //Autenticación
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),

      // ── Shell principal (AppBar + BottomNav) ─────────────────────────
      ShellRoute(
        builder:
            (context, state, child) => MainLayout(
              child: child,
              //location: state.matchedLocation,
              location: state.matchedLocation,
            ),
        routes: [
          // ── Home
          GoRoute(path: '/home', builder: (_, __) => const HomeDashboard()),

          // DIRECTOR: Materias
          GoRoute(
            path: '/materias',
            builder: (_, __) => const SubjectListScreen(),
            routes: [
              GoRoute(
                path: 'create',
                builder: (_, __) => const SubjectScreen(),
              ),
              GoRoute(
                path: ':id/edit',
                builder: (_, state) {
                  final id = int.parse(state.pathParameters['id']!);
                  return SubjectEditScreen(id: id);
                },
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
                path: ':id/edit',
                builder: (_, state) {
                  final id = int.parse(state.pathParameters['id']!);

                  return ProfesorEditScreen(id: id);
                },
              ),

              GoRoute(
                // extra: Profesor
                path: ':id/materia',
                builder: (_, state) {
                  final id = int.parse(state.pathParameters['id']!);
                  return AsignarMateriaScreen(profesorId: id);
                },
              ),

              GoRoute(
                // extra: Profesor
                path: ':id/horario',
                builder: (_, state) {
                  final id = int.parse(state.pathParameters['id']!);
                  return AsignarHorarioScreen(profesorId: id);
                },
              ),
              GoRoute(
                path: ':id/ver-horario',
                builder: (_, state) {
                  final id = int.parse(state.pathParameters['id']!);
                  return HorarioProfesorScreen(profesorId: id);
                },
              ),
              // Materias asignadas
              GoRoute(
                path: ':id/materias-asignadas',
                builder: (_, state) {
                  final profesorId = int.parse(state.pathParameters['id']!);

                  return MateriasAsignadasScreen(profesorId: profesorId);
                },
                routes: [
                  // Agregar horario a una asignación existente
                  GoRoute(
                    path: ':asignacionId/agregar-horario',
                    builder: (_, state) {
                      return AgregarHorarioScreen(
                        profesorId: int.parse(state.pathParameters['id']!),
                        asignacionId: int.parse(
                          state.pathParameters['asignacionId']!,
                        ),
                      );
                    },
                  ),
                ],
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
              GoRoute(
                path: ':id/edit',
                builder: (_, state) {
                  final id = int.parse(state.pathParameters['id']!);

                  return EstudianteEditScreen(id: id);
                },
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
              GoRoute(
                path: ':id/edit',
                builder: (_, state) {
                  final id = int.parse(state.pathParameters['id']!);

                  return PadreEditScreen(id: id);
                },
              ),
              GoRoute(
                path: ':id/estudiantes',
                builder: (_, state) {
                  final id = int.parse(state.pathParameters['id']!);

                  return PadreAsignarEstudianteScreen(padreId: id);
                },
              ),
            ],
          ),
          // ── PADRE: Mis hijos
          GoRoute(
            path: '/mis-hijos',
            builder: (_, __) => const MisHijosScreen(),
            routes: [
              GoRoute(
                path: ':estudianteId',
                builder:
                    (_, state) => PadreDashboardScreen(
                      estudianteId: int.parse(
                        state.pathParameters['estudianteId']!,
                      ),
                    ),
                routes: [
                  GoRoute(
                    path: 'agendas', // /mis-hijos/:estudianteId/agendas
                    builder:
                        (_, state) => PadreAgendaScreen(
                          estudianteId: int.parse(
                            state.pathParameters['estudianteId']!,
                          ),
                        ),
                  ),
                  GoRoute(
                    path: 'notas',
                    builder:
                        (_, state) => PadreNotaScreen(
                          estudianteId: int.parse(
                            state.pathParameters['estudianteId']!,
                          ),
                        ),
                  ),
                  GoRoute(
                    path: 'asistencias',
                    builder:
                        (_, state) => PadreAsistenciaScreen(
                          estudianteId: int.parse(
                            state.pathParameters['estudianteId']!,
                          ),
                        ),
                  ),
                  GoRoute(
                    path: 'anecdotarios',
                    builder:
                        (_, state) => PadreAnecdotarioScreen(
                          estudianteId: int.parse(
                            state.pathParameters['estudianteId']!,
                          ),
                        ),
                  ),
                ],
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
                      final cursoId = int.parse(
                        state.pathParameters['cursoId']!,
                      );
                      return ParaleloCreateScreen(cursoId: cursoId);
                    },
                  ),
                  GoRoute(
                    path: ':paraleloId/horario',
                    builder: (_, state) {
                      final cursoId = int.parse(
                        state.pathParameters['cursoId']!,
                      );
                      final paraleloId = int.parse(
                        state.pathParameters['paraleloId']!,
                      );
                      return HorarioCursoScreen(
                        cursoId: cursoId,
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
              GoRoute(
                path: ':periodoId/periodos-evaluacion',
                builder: (_, state) {
                  final periodoId = int.parse(
                    state.pathParameters['periodoId']!,
                  );

                  return PeriodoEvaluacionListScreen(periodoId: periodoId);
                },
                routes: [
                  GoRoute(
                    path: 'create',
                    builder: (_, state) {
                      final periodoId = int.parse(
                        state.pathParameters['periodoId']!,
                      );

                      return PeriodoEvaluacionCreateScreen(
                        periodoId: periodoId,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          // ── DIRECTOR: Mi colegio
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

          // ── SUPER ADMIN: Colegios
          GoRoute(
            path: '/colegios',
            builder: (_, __) => const TenantListScreen(),
            routes: [
              GoRoute(path: 'create', builder: (_, __) => const TenantScreen()),
              GoRoute(
                path: ':tenantId/modules',

                builder: (_, state) {
                  return ModuleScreen(
                    tenantId: int.parse(state.pathParameters['tenantId']!),
                  );
                },
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
            routes: [
              GoRoute(
                path: ':periodoId/:cursoId/:paraleloId/:asignacionId',
                builder:
                    (_, state) => ClaseDashboardScreen(
                      periodoId: int.parse(state.pathParameters['periodoId']!),
                      cursoId: int.parse(state.pathParameters['cursoId']!),
                      paraleloId: int.parse(
                        state.pathParameters['paraleloId']!,
                      ),
                      asignacionId: int.parse(
                        state.pathParameters['asignacionId']!,
                      ),
                      curso: state.uri.queryParameters['curso'] ?? '',
                      paralelo: state.uri.queryParameters['paralelo'] ?? '',
                      materia: state.uri.queryParameters['materia'] ?? '',
                    ),
                    
                routes: [
                  GoRoute(
                    path: 'anecdotarios',
                    builder:
                        (_, state) => AnecdotarioListScreen(
                          periodoId: int.parse(
                            state.pathParameters['periodoId']!,
                          ),
                          asignacionId: int.parse(
                            state.pathParameters['asignacionId']!,
                          ),
                        ),
                    routes: [
                      GoRoute(
                        path: 'create',
                        builder:
                            (_, state) => AnecdotarioCreateScreen(
                              periodoId: int.parse(
                                state.pathParameters['periodoId']!,
                              ),
                              cursoId: int.parse(
                                state.pathParameters['cursoId']!,
                              ),
                              paraleloId: int.parse(
                                state.pathParameters['paraleloId']!,
                              ),
                              asignacionId: int.parse(
                                state.pathParameters['asignacionId']!,
                              ),
                            ),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'asistencia',
                    builder:
                        (_, state) => AsistenciaCreateScreen(
                          periodoId: int.parse(
                            state.pathParameters['periodoId']!,
                          ),
                          cursoId: int.parse(state.pathParameters['cursoId']!),
                          paraleloId: int.parse(
                            state.pathParameters['paraleloId']!,
                          ),
                          asignacionId: int.parse(
                            state.pathParameters['asignacionId']!,
                          ),
                        ),
                  ),
                  GoRoute(
                    path: 'agendas',
                    builder:
                        (_, state) => AgendaListScreen(
                          periodoId: int.parse(
                            state.pathParameters['periodoId']!,
                          ),
                          cursoId: int.parse(state.pathParameters['cursoId']!),
                          paraleloId: int.parse(
                            state.pathParameters['paraleloId']!,
                          ),
                          asignacionId: int.parse(
                            state.pathParameters['asignacionId']!,
                          ),
                        ),
                    routes: [
                      GoRoute(
                        path: 'create',
                        builder:
                            (_, state) => AgendaCreateScreen(
                              periodoId: int.parse(
                                state.pathParameters['periodoId']!,
                              ),
                              cursoId: int.parse(
                                state.pathParameters['cursoId']!,
                              ),
                              paraleloId: int.parse(
                                state.pathParameters['paraleloId']!,
                              ),
                              asignacionId: int.parse(
                                state.pathParameters['asignacionId']!,
                              ),
                            ),
                      ),
                      GoRoute(
                        path: ':agendaId',
                        builder:
                            (_, state) => AgendaDetailScreen(
                              agendaId: int.parse(
                                state.pathParameters['agendaId']!,
                              ),
                            ),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'criterios',
                    builder:
                        (_, state) => CriterioScreen(
                          periodoId: int.parse(
                            state.pathParameters['periodoId']!,
                          ),
                          asignacionId: int.parse(
                            state.pathParameters['asignacionId']!,
                          ),
                        ),
                  ),
                  GoRoute(
                    path: 'libro-calificaciones',
                    builder:
                        (_, state) => LibroCalificacionesScreen(
                          asignacionId: int.parse(
                            state.pathParameters['asignacionId']!,
                          ),
                        ),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
  path: '/agendas/:agendaId/entregas',
  builder: (_, state) => EntregasListScreen(
    agendaId: int.parse(state.pathParameters['agendaId']!),
  ),
  routes: [
    GoRoute(
      path: ':entregaId', // /agendas/:agendaId/entregas/:entregaId
      builder: (_, state) => EntregaDetalleProfesorScreen(
        entregaId: int.parse(state.pathParameters['entregaId']!),
      ),
    ),
  ],
),
          GoRoute(
            path: '/mi-horario',
            builder: (_, __) => const EstudianteHorarioScreen(),
          ),
          GoRoute(
            path: '/estudiante/materias',
            builder: (_, __) => const EstudianteMateriasScreen(),
            routes: [
              GoRoute(
                path: ':asignacionId',
                builder:
                    (_, state) => EstudianteMateriaDetalleScreen(
                      asignacionId: int.parse(
                        state.pathParameters['asignacionId']!,
                      ),
                    ),
                routes: [
                  GoRoute(
                    path: 'pendientes',
                    builder:
                        (_, state) => EstudianteAgendaScreen(
                          asignacionId: int.parse(
                            state.pathParameters['asignacionId']!,
                          ),
                          tipo: "tarea",
                        ),
                    routes: [
                      GoRoute(
                        path: ':agendaId/entrega',
                        builder: (_, state) {
                          final agenda = state.extra as PadreAgenda;
                          return EstudianteEntregaTareaScreen(agenda: agenda);
                        },
                      ),
                    ],
                  ),

                  GoRoute(
                    path: 'biblioteca',
                    builder:
                        (_, state) => EstudianteBibliotecaScreen(
                          asignacionId: int.parse(
                            state.pathParameters['asignacionId']!,
                          ),
                        ),
                  ),
                  GoRoute(
                    path: 'examenes',
                    builder:
                        (_, state) => EstudianteAgendaScreen(
                          asignacionId: int.parse(
                            state.pathParameters['asignacionId']!,
                          ),
                          tipo: "examen",
                        ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );

  return _routerInstance;
}
