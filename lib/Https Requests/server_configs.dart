enum Flavor {DEV, PROD,NEWPROD}


class Config {
  static Flavor? appFlavor;
  static String get baseUrlLogin {
    switch (appFlavor) {
      case Flavor.PROD:
        return '';
      case Flavor.DEV:
        return 'http://35.154.9.155/api/';
      default:
        return 'http://35.154.9.155/api/';
    }
  }
}

String ApibaseUrl = Config.baseUrlLogin;
