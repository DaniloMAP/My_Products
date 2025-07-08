import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../exceptions/api_exception.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  final http.Client _client = http.Client();

  Map<String, String> get _headers => {
    'X-Api-Key': dotenv.env['API_KEY']!,
    'Content-Type': 'application/json',
  };

  String get _baseUrl => dotenv.env['API_URL']!;

  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? queryParams,
    Duration? timeout,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint')
          .replace(queryParameters: queryParams);

      final response = await _client
          .get(uri, headers: _headers)
          .timeout(timeout ?? const Duration(seconds: 10));

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      throw const ApiException('Chave de API inválida');
    } else {
      throw ApiException(
        'Erro ${response.statusCode}: Falha ao buscar dados',
      );
    }
  }

  ApiException _handleError(dynamic e) {
    if (e is ApiException) {
      return e;
    } else if (e.toString().contains('TimeoutException')) {
      return const ApiException('Tempo limite excedido. Verifique sua conexão.');
    } else {
      return const ApiException('Falha de conexão. Verifique sua internet.');
    }
  }

  void dispose() {
    _client.close();
  }
}