class EntregaTareaArchivo {
  final int id;
  final String nombreOriginal;
  final String url;

  EntregaTareaArchivo({
    required this.id,
    required this.nombreOriginal,
    required this.url,
  });

  factory EntregaTareaArchivo.fromJson(Map<String, dynamic> json) {
    const baseUrl = 'http://192.168.100.206:8000';
    final rawUrl = json['url'] ?? '';
    final fullUrl = rawUrl.startsWith('http') ? rawUrl : '$baseUrl$rawUrl';

    return EntregaTareaArchivo(
      id: json['id'],
      nombreOriginal: json['nombre_original'] ?? '',
      url: fullUrl,
    );
  }
}

class EntregaTarea {
  final int id;
  final String? comentario;
  final String? fechaEntrega;
  final String estado;
  final List<EntregaTareaArchivo> archivos;

  EntregaTarea({
    required this.id,
    this.comentario,
    this.fechaEntrega,
    required this.estado,
    required this.archivos,
  });

  factory EntregaTarea.fromJson(Map<String, dynamic> json) {
    return EntregaTarea(
      id: json['id'],
      comentario: json['comentario'],
      fechaEntrega: json['fecha_entrega'],
      estado: json['estado'] ?? '',
      archivos: (json['archivos'] as List<dynamic>?)
              ?.map((e) => EntregaTareaArchivo.fromJson(e))
              .toList() ??
          [],
    );
  }
}