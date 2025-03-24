abstract class AppFailures {
  final String message;

  AppFailures({required this.message});
}

class DBFailure extends AppFailures {
  DBFailure({required super.message});
}

class ServerFailure extends AppFailures {
  ServerFailure({required super.message});
}
