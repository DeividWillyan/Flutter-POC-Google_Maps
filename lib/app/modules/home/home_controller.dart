import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:poc_maps/app/modules/home/feed_model.dart';
import 'package:poc_maps/app/modules/home/home_repository.dart';
import 'package:poc_maps/app/modules/home/locator_service.dart';

part 'home_controller.g.dart';

class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  final HomeRepository _repository;
  final ILocationService _location;
  _HomeControllerBase(this._repository, this._location) {
    fetch();
  }

  @observable
  ObservableFuture<dynamic> feed;

  @observable
  Set<Marker> markers = {};

  @observable
  Position position;

  @observable
  bool showBottom = false;

  @observable
  Vouchers voucher;

  @action
  void setVoucherTap(Vouchers val) => voucher = val;

  @computed
  bool get isProcessingLoad => feed.status == FutureStatus.pending;

  fetch() async {
    feed = _repository.fetchPost().asObservable();
  }

  getLocation() async {
    position = await _location.getPosition();
  }

  generateMarkers(v) {
    v.vouchers.forEach(
      (v) {
        markers.add(
          Marker(
            markerId: MarkerId(
              v.idVoucher.toString(),
            ),
            infoWindow: InfoWindow(
              title: v.nomeVoucher,
              snippet: v.preco,
            ),
            position: LatLng(
              double.parse(v?.latitude),
              double.parse(v?.longitude),
            ),
          ),
        );
      },
    );
  }
}
