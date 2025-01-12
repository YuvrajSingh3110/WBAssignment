// if we want we can add more details to the exception (like status code, etc) with this

class ServerException implements Exception{
  final String message;
  const ServerException(this.message);
}