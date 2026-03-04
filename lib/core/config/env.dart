class Env {
  static const String secretKey = String.fromEnvironment(
    'SECRET_KEY',
    defaultValue: 'default_secret_key',
  );
  static const String apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://api.default.com',
  );
}
