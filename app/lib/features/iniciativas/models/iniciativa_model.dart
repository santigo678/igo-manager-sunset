class Iniciativa {
  final String  id;
  final String  userId;
  final String  titulo;
  final String? descripcion;
  final int     importancia;
  final int     gobernabilidad;
  final String  cuadrante;
  final bool    archivada;
  final DateTime createdAt;

  const Iniciativa({
    required this.id,
    required this.userId,
    required this.titulo,
    this.descripcion,
    required this.importancia,
    required this.gobernabilidad,
    required this.cuadrante,
    required this.archivada,
    required this.createdAt,
  });

  factory Iniciativa.fromMap(Map<String, dynamic> map) => Iniciativa(
    id:            map['id'],
    userId:        map['user_id'],
    titulo:        map['titulo'],
    descripcion:   map['descripcion'],
    importancia:   map['importancia'] ?? 5,
    gobernabilidad:map['gobernabilidad'] ?? 5,
    cuadrante:     map['cuadrante'] ?? 'HACER_YA',
    archivada:     map['archivada'] ?? false,
    createdAt:     DateTime.parse(map['created_at']),
  );

  Map<String, dynamic> toMap() => {
    'user_id':       userId,
    'titulo':        titulo,
    'descripcion':   descripcion,
    'importancia':   importancia,
    'gobernabilidad':gobernabilidad,
    'archivada':     archivada,
  };
}
