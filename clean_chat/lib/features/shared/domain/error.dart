class DomainError {
  DomainError({required this.reason});

  final String reason;
}

class NotFound extends DomainError {
  NotFound({required String reason}) : super(reason: reason);
}

class LengthError extends DomainError {
  LengthError({required String reason}) : super(reason: reason);
}

class NameAlreadyTaken extends DomainError {
  NameAlreadyTaken({required String reason}) : super(reason: reason);
}
