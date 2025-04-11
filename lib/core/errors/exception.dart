class CustomExeption implements Exception {
  final String message;

  CustomExeption(
    this.message,
  );
  @override
  String toString() {
    return message;
  }
}
