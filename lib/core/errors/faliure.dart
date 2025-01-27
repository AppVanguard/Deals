abstract class Failure {
  final String message;

  Failure({required this.message});
}
class ServerFaliure extends Failure {
  ServerFaliure({required super.message});
  
}
