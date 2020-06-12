// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$HomeController on _HomeControllerBase, Store {
  Computed<bool> _$isProcessingLoadComputed;

  @override
  bool get isProcessingLoad => (_$isProcessingLoadComputed ??= Computed<bool>(
          () => super.isProcessingLoad,
          name: '_HomeControllerBase.isProcessingLoad'))
      .value;

  final _$feedAtom = Atom(name: '_HomeControllerBase.feed');

  @override
  ObservableFuture<dynamic> get feed {
    _$feedAtom.reportRead();
    return super.feed;
  }

  @override
  set feed(ObservableFuture<dynamic> value) {
    _$feedAtom.reportWrite(value, super.feed, () {
      super.feed = value;
    });
  }

  final _$markersAtom = Atom(name: '_HomeControllerBase.markers');

  @override
  Set<Marker> get markers {
    _$markersAtom.reportRead();
    return super.markers;
  }

  @override
  set markers(Set<Marker> value) {
    _$markersAtom.reportWrite(value, super.markers, () {
      super.markers = value;
    });
  }

  final _$positionAtom = Atom(name: '_HomeControllerBase.position');

  @override
  Position get position {
    _$positionAtom.reportRead();
    return super.position;
  }

  @override
  set position(Position value) {
    _$positionAtom.reportWrite(value, super.position, () {
      super.position = value;
    });
  }

  final _$showBottomAtom = Atom(name: '_HomeControllerBase.showBottom');

  @override
  bool get showBottom {
    _$showBottomAtom.reportRead();
    return super.showBottom;
  }

  @override
  set showBottom(bool value) {
    _$showBottomAtom.reportWrite(value, super.showBottom, () {
      super.showBottom = value;
    });
  }

  final _$voucherAtom = Atom(name: '_HomeControllerBase.voucher');

  @override
  Vouchers get voucher {
    _$voucherAtom.reportRead();
    return super.voucher;
  }

  @override
  set voucher(Vouchers value) {
    _$voucherAtom.reportWrite(value, super.voucher, () {
      super.voucher = value;
    });
  }

  final _$_HomeControllerBaseActionController =
      ActionController(name: '_HomeControllerBase');

  @override
  void setVoucherTap(Vouchers val) {
    final _$actionInfo = _$_HomeControllerBaseActionController.startAction(
        name: '_HomeControllerBase.setVoucherTap');
    try {
      return super.setVoucherTap(val);
    } finally {
      _$_HomeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
feed: ${feed},
markers: ${markers},
position: ${position},
showBottom: ${showBottom},
voucher: ${voucher},
isProcessingLoad: ${isProcessingLoad}
    ''';
  }
}
