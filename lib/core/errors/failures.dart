abstract class Failure {
  final String message;
  final String? code;

  const Failure({required this.message, this.code});

  @override
  String toString() => message;
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message =
        'Sin conexión a internet. Verifica tu red e intenta de nuevo.',
    super.code = 'network_error',
  });
}

class ServerFailure extends Failure {
  const ServerFailure({
    super.message = 'Error del servidor. Intenta de nuevo más tarde.',
    super.code = 'server_error',
  });
}

class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code = 'validation_error',
  });
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    super.message = 'Ocurrió un error inesperado. Intenta de nuevo.',
    super.code = 'unexpected_error',
  });
}

class FirebaseFailure extends Failure {
  const FirebaseFailure({
    required super.message,
    super.code = 'firebase_error',
  });
}
