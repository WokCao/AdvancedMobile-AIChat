enum Flavor { dev, prod }

class FlavorConfig {
  static late Flavor appFlavor;

  static String get baseUrl {
    switch (appFlavor) {
      case Flavor.prod:
        return '';
      case Flavor.dev:
        return '.dev';
    }
  }

  static String get name => appFlavor.name;
}
