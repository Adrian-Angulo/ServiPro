class TimeFormatter {
  TimeFormatter._();

  static String timeAgo(DateTime dateCreated) {
    final now = DateTime.now();
    final difference = now.difference(dateCreated);

    if (difference.inSeconds < 60) return 'Hace un momento';
    if (difference.inMinutes < 60) {
      return 'Hace ${difference.inMinutes} ${difference.inMinutes == 1 ? "minuto" : "minutos"}';
    }
    if (difference.inHours < 24) {
      return 'Hace ${difference.inHours} ${difference.inHours == 1 ? "hora" : "horas"}';
    }
    if (difference.inDays < 7) {
      return 'Hace ${difference.inDays} ${difference.inDays == 1 ? "día" : "días"}';
    }
    if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'Hace $weeks ${weeks == 1 ? "semana" : "semanas"}';
    }
    final months = (difference.inDays / 30).floor();
    return 'Hace $months ${months == 1 ? "mes" : "meses"}';
  }

  static String fullDate(DateTime date) {
    const months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '${date.day} de ${months[date.month - 1]} de ${date.year} a las $hour:$minute';
  }

  static String shortDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString().substring(2);
    return '$day/$month/$year';
  }
}
