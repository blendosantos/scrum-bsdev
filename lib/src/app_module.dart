import 'package:flutter_modular/flutter_modular.dart';

import 'modules/modules.dart';

class AppModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        // Bind.singleton((i) => DadosService()),
      ];

  @override
  List<ModularRoute> get routes => [
        ModuleRoute('/', module: AuthModule()),
        ModuleRoute('/home', module: HomeModule()),
      ];
}
