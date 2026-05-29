class Plan {
  final String  id;
  final String  iniciativaId;
  final String  userId;
  final DateTime? fechaLimite;
  final double?  presupuesto;
  final String?  aliados;
  final String   estado;
  final DateTime createdAt;

  const Plan({
    required this.id,
    required this.iniciativaId,
    required this.userId,
    this.fechaLimite,
    this.presupuesto,
    this.aliados,
    required this.estado,
    required this.createdAt,
  });

  factory Plan.fromMap(Map<String, dynamic> m) => Plan(
    id:           m['id'],
    iniciativaId: m['iniciativa_id'],
    userId:       m['user_id'],
    fechaLimite:  m['fecha_limite'] != null ? DateTime.parse(m['fecha_limite']) : null,
    presupuesto:  m['presupuesto_estimado']?.toDouble(),
    aliados:      m['aliados'],
    estado:       m['estado'] ?? 'Pendiente',
    createdAt:    DateTime.parse(m['created_at']),
  );

  Map<String, dynamic> toMap() => {
    'iniciativa_id':      iniciativaId,
    'user_id':            userId,
    'fecha_limite':       fechaLimite?.toIso8601String().split('T').first,
    'presupuesto_estimado': presupuesto,
    'aliados':            aliados,
    'estado':             estado,
  };
}
