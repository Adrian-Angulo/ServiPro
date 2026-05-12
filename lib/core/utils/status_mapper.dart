class StatusMapper {
  StatusMapper._();

  static String toUI(String status) {
    switch (status.toLowerCase()) {
      case 'todos':
        return 'Todos';
      case 'pending':
        return 'Pendiente';
      case 'inprogress':
        return 'En progreso';
      case 'completed':
        return 'Completado';
      case 'cancelled':
        return 'Cancelado';
      default:
        return 'Pendiente';
    }
  }

  static String toDb(String uiStatus) {
    switch (uiStatus.toLowerCase()) {
      case 'pendiente':
        return 'pending';
      case 'en progreso':
        return 'in_progress';
      case 'completado':
        return 'completed';
      case 'cancelado':
        return 'cancelled';
      default:
        return 'pending';
    }
  }
}
