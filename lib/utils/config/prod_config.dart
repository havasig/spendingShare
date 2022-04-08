import 'base_config.dart';

class ProdConfig implements BaseConfig {
  @override
  String get currencyConverterApiKey => '33027ce7013f5ba479e63fe09ca189ba3d9f50c2';

  @override
  String get currencyConverterbaseUrl => 'https://api.getgeoapi.com/v2';
}
