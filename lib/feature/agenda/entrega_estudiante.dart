class EntregaEstudiante {
  final int estudianteId;
  final String nombre;
  final String? codigo;
  final String estado; // 'entregado' | 'pendiente'
  final int? entregaId;
  final String? fechaEntrega;

  EntregaEstudiante({
    required this.estudianteId,
    required this.nombre,
    this.codigo,
    required this.estado,
    this.entregaId,
    this.fechaEntrega,
  });

  bool get entregado => estado == 'entregado';

  factory EntregaEstudiante.fromJson(Map<String, dynamic> json) {
    return EntregaEstudiante(
      estudianteId: json['estudiante_id'],
      nombre: json['nombre'] ?? '',
      codigo: json['codigo'],
      estado: json['estado'] ?? 'pendiente',
      entregaId: json['entrega_id'],
      fechaEntrega: json['fecha_entrega'],
    );
  }
}

class EntregasResponse {
  final String tipo;
  final String titulo;
  final List<EntregaEstudiante> entregas;

  EntregasResponse({
    required this.tipo,
    required this.titulo,
    required this.entregas,
  });

  factory EntregasResponse.fromJson(Map<String, dynamic> json) {
    return EntregasResponse(
      tipo: json['tipo'] ?? '',
      titulo: json['titulo'] ?? '',
      entregas: (json['entregas'] as List<dynamic>? ?? [])
          .map((e) => EntregaEstudiante.fromJson(e))
          .toList(),
    );
  }
}