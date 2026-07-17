// entrega_detalle_profesor.dart

class ArchivoEntrega {
  final int id;
  final String nombreOriginal;
  final String url;

  ArchivoEntrega({
    required this.id,
    required this.nombreOriginal,
    required this.url,
  });

  factory ArchivoEntrega.fromJson(Map<String, dynamic> json) {
    return ArchivoEntrega(
      id: json['id'],
      nombreOriginal: json['nombre_original'] ?? '',
      url: json['url'] ?? '',
    );
  }
}

class EntregaDetalleProfesor {
  final int id;
  final int estudianteId;
  final String nombreEstudiante;
  final String? codigoEstudiante;
  final String? comentario;
  final String estado;
  final String? fechaEntrega;
  final List<ArchivoEntrega> archivos;

  EntregaDetalleProfesor({
    required this.id,
    required this.estudianteId,
    required this.nombreEstudiante,
    this.codigoEstudiante,
    this.comentario,
    required this.estado,
    this.fechaEntrega,
    required this.archivos,
  });

  factory EntregaDetalleProfesor.fromJson(Map<String, dynamic> json) {
    final estudiante = json['estudiante'] as Map<String, dynamic>;

    return EntregaDetalleProfesor(
      id: json['id'],
      estudianteId: estudiante['id'],
      nombreEstudiante: estudiante['nombre'] ?? '',
      codigoEstudiante: estudiante['codigo'],
      comentario: json['comentario'],
      estado: json['estado'] ?? 'pendiente',
      fechaEntrega: json['fecha_entrega'],
      archivos: (json['archivos'] as List<dynamic>? ?? [])
          .map((e) => ArchivoEntrega.fromJson(e))
          .toList(),
    );
  }
}