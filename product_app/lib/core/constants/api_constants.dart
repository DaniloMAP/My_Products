class ApiConstants {
  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://localhost:5064',
  );

  static const String apiKey = String.fromEnvironment(
    'API_KEY',
    defaultValue: 'MINHA_CHAVE_SECRETA',
  );

  static const Duration requestTimeout = Duration(seconds: 10);
  static const int defaultPageSize = 10;
  static const Duration debounceDelay = Duration(milliseconds: 800);
}
