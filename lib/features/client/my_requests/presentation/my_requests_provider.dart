import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/features/client/my_requests/data/models/solicitud.dart';

// ── Datos de ejemplo (mock) ───────────────────────────────────────────────────
// Más adelante esto se reemplaza con datos reales de Firebase
final _solicitudesMock = [
  Solicitud(
    id: '1',
    titulo: 'Fuga de agua en tubería principal',
    descripcion:
        'Necesito un plomero urgente para reparar una filtración fuerte en el baño principal. Parece que la tubería que alimenta el lavamanos se rompió. He cerrado la llave de paso general, pero necesito repararlo hoy mismo para poder usar el agua. Por favor traer herramientas propias.',
    categoria: 'Plomería',
    zona: 'Centro',
    barrio: 'Barrio La Cocha',
    estado: EstadoSolicitud.finalizada,
    fechaCreacion: DateTime.now().subtract(const Duration(minutes: 5)),
    postulaciones: [
      Postulacion(
        id: 'p1',
        nombreTrabajador: 'Carlos Burbano',
        especialidad: 'PLOMERO EXPERTO',
        calificacion: 4.9,
        trabajosRealizados: 42,
        telefonoWhatsapp: '3001234567',
      ),
      Postulacion(
        id: 'p2',
        nombreTrabajador: 'Carlos Burbano',
        especialidad: 'PLOMERO EXPERTO',
        calificacion: 4.9,
        trabajosRealizados: 42,
        telefonoWhatsapp: '3009876543',
      ),
    ],
  ),
  Solicitud(
    id: '2',
    titulo: 'Instalación de lavadora nueva',
    descripcion:
        'Busco técnico para instalar lavadora Samsung. Requiere conexión a toma de agua y desagüe.',
    categoria: 'Electricidad',
    zona: 'Norte',
    barrio: 'Barrio El Rosario',
    estado: EstadoSolicitud.enCurso,
    fechaCreacion: DateTime.now().subtract(const Duration(hours: 2)),
  ),
  Solicitud(
    id: '3',
    titulo: 'Mantenimiento preventivo calefón',
    descripcion:
        'Limpieza general y revisión de válvulas para calefón a gas. Se requiere para el fin de semana.',
    categoria: 'Otros',
    zona: 'Sur',
    barrio: 'Barrio Lorenzo',
    estado: EstadoSolicitud.pendiente,
    fechaCreacion: DateTime.now().subtract(const Duration(hours: 4)),
  ),
];

// ── Provider del filtro seleccionado ─────────────────────────────────────────
// null = "Todos", cualquier otro valor filtra por ese estado
final filtroSolicitudProvider = StateProvider<EstadoSolicitud?>((ref) => null);

// ── Provider de la lista filtrada ─────────────────────────────────────────────
final solicitudesFiltradas = Provider<List<Solicitud>>((ref) {
  final filtro = ref.watch(filtroSolicitudProvider);

  // Si no hay filtro, devuelve todas
  if (filtro == null) return _solicitudesMock;

  // Si hay filtro, devuelve solo las que coinciden
  return _solicitudesMock.where((s) => s.estado == filtro).toList();
});
