class EnvConfig {
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://sijunjung-go-production.up.railway.app',
  );

  static const String envName = String.fromEnvironment(
    'ENV_NAME',
    defaultValue: 'production',
  );

  static bool get isProduction => envName == 'production';
  static bool get isDevelopment => envName == 'development';
}
