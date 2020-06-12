import 'package:dio/dio.dart';
import 'package:poc_maps/app/modules/home/home_repository.dart';
import 'package:poc_maps/app/modules/home/home_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:poc_maps/app/modules/home/home_page.dart';
import 'package:poc_maps/app/modules/home/locator_service.dart';

class HomeModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => LocationService()),
        Bind((i) => HomeRepository(Dio())),
        Bind((i) => HomeController(i.get(), i.get())),
      ];

  @override
  List<Router> get routers => [
        Router(Modular.initialRoute, child: (_, args) => HomePage()),
      ];

  static Inject get to => Inject<HomeModule>.of();
}
