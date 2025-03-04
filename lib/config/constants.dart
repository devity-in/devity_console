class Constants {
  static String? get _appFlavor =>
      const String.fromEnvironment('FLUTTER_APP_FLAVOR') != ''
          ? const String.fromEnvironment('FLUTTER_APP_FLAVOR')
          : null;
  static String get appName {
    switch (Constants._appFlavor) {
      case 'development':
        return 'Mobile App Dev';
      case 'production':
        return 'Mobile App Prod';
      case 'staging':
        return 'Mobile App UAT';
      default:
        return 'Mobile App Dev';
    }
  }

  static String get baseUrl {
    switch (Constants._appFlavor) {
      case 'development':
        return 'https://api.devity.in';
      case 'production':
        return 'https://api.devity.in';
      case 'staging':
        return 'https://uat.devity.in';
      default:
        return 'https://dev.devity.in';
    }
  }
}
