import '../../agenda/agenda_archivo.dart';

class EstudianteBiblioteca {
  final int id;
  final String titulo;
  final String descripcion;
  final String materia;
  final String profesor;
  final String createdAt;
  final List<AgendaArchivo> archivos;

  EstudianteBiblioteca({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.materia,
    required this.profesor,
    required this.createdAt,
    required this.archivos,
  });

  factory EstudianteBiblioteca.fromJson(Map<String, dynamic> json) {
    return EstudianteBiblioteca(
      id: json['id'],
      titulo: json['titulo'] ?? '',
      descripcion: json['descripcion'] ?? '',
      materia: json['materia'] ?? '',
      profesor: json['profesor'] ?? '',
      createdAt: json['created_at'] ?? '',
      archivos: (json['archivos'] as List<dynamic>?)
              ?.map((e) => AgendaArchivo.fromJson(e))
              .toList() ??
          [],
    );
  }
}