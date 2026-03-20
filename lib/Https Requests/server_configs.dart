enum Flavor {DEV, PROD,NEWPROD}


class Config {
  static Flavor? appFlavor;
  static String get baseUrlLogin {
    switch (appFlavor) {
      case Flavor.PROD:
        return '';
      case Flavor.DEV:
        return 'https://devdeliveryapi.samarpanconsultech.com/api/v1/';
      default:
        return 'https://devdeliveryapi.samarpanconsultech.com/api/v1/';
    }
  }
}

String ApibaseUrl = Config.baseUrlLogin;
