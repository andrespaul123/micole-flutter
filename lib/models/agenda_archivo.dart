class AgendaArchivo {
  final int? id;
  final String nombreOriginal;
  final String url;

  AgendaArchivo({
    this.id,
    required this.nombreOriginal,
    required this.url,
  });

  factory AgendaArchivo.fromJson(
    Map<String, dynamic> json,
  ) {
    return AgendaArchivo(
      id: json['id'],
      nombreOriginal:
          json['nombre_original'] ?? '',
      url: json['url'] ?? '',
    );
  }
}