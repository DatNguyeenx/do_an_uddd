class MapsConfig {
  static const apiKey = String.fromEnvironment(
    'GOOGLE_MAPS_API_KEY',
    defaultValue: 'AIzaSyALKM5Q89C-0nUrkkXG-5xQbB5QcE2I6Tg',
  );
}
