import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:poc_maps/app/modules/home/custom_bottomsheet_widget.dart';
import 'package:poc_maps/app/modules/home/marker_generate.dart';

import 'home_controller.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key key, this.title = "Postos"}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ModularState<HomePage, HomeController> {
  //use 'controller' variable to access controller

  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController _mapController;
  Geolocator _geolocator;
  List<Marker> markers = [];
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  Set<Polyline> _polylines = {};
  double offsetY = -100;
  double offsetX = -100;

  @override
  void initState() {
    super.initState();
    _geolocator = Geolocator();
    checkPermission();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setmarkers();
    });

    _geolocator.getPositionStream().listen((event) {
      setLocalizacaoCustomizadaNaGambis(p: event);
    });
  }

  void setLocalizacaoCustomizadaNaGambis({p}) {
    Future.delayed(const Duration(milliseconds: 0)).then(
      (value) async {
        if (p == null) p = await _geolocator.getCurrentPosition();
        ScreenCoordinate res = await _mapController
            .getScreenCoordinate(LatLng(p.latitude, p.longitude));
        setState(() {
          var devicePixelRatio = Platform.isAndroid
              ? MediaQuery.of(context).devicePixelRatio
              : 1.0;
          offsetY = (res?.y?.toDouble() ?? 0) / devicePixelRatio + 8;
          offsetX = (res?.x?.toDouble() ?? 0) / devicePixelRatio - 48;
        });
      },
    );
  }

  void checkPermission() {
    _geolocator.checkGeolocationPermissionStatus().then((status) {
      print('status: $status');
    });
    _geolocator
        .checkGeolocationPermissionStatus(
            locationPermission: GeolocationPermission.locationAlways)
        .then((status) {
      print('always status: $status');
    });
    _geolocator.checkGeolocationPermissionStatus(
        locationPermission: GeolocationPermission.locationWhenInUse)
      ..then((status) {
        print('whenInUse status: $status');
      });
  }

  setmarkers() {
    if (controller.feed.value != null) {
      MarkerGenerator(markerWidgets(), (bitmaps) {
        setState(() {
          markers = mapBitmapsToMarkers(bitmaps);
        });
      }).generate(context);
    }
  }

  List<Marker> mapBitmapsToMarkers(List<Uint8List> bitmaps) {
    List<Marker> markersList = [];
    bitmaps.asMap().forEach((i, bmp) {
      final v = controller.feed.value.vouchers[i];
      markersList.add(Marker(
          markerId: MarkerId(v.nomeVoucher),
          position: LatLng(
            double.parse(v?.latitude),
            double.parse(v?.longitude),
          ),
          consumeTapEvents: true,
          onTap: () async {
            await controller.getLocation();

            controller.showBottom = true;
            controller.setVoucherTap(v);
            print('showBottom ${controller.showBottom}');
          },
          icon: BitmapDescriptor.fromBytes(bmp)));
    });
    return markersList;
  }

  List<dynamic> markerWidgets() {
    return controller.feed.value.vouchers
        .map((c) => _getMarkerWidget(c.nomeVoucher, c.categoria))
        .toList();
  }

  Widget _getMarkerWidget(String name, imgCategoria) {
    return Container(
      child: Stack(
        alignment: Alignment.topCenter,
        overflow: Overflow.visible,
        children: [
          Icon(
            Icons.location_on,
            color: Color(0xFF062A61),
            size: 24,
          ),
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.only(
                  top: 25,
                ),
                width: 130,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Icon(Icons.photo, size: 29),
                    SizedBox(height: 7),
                    Text(
                      name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('24km'),
                        Text('10 min'),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  createPolylines(latIni, lngIni, latFim, lngFim) async {
    polylineCoordinates.clear();
    var result1 = await polylinePoints.getRouteBetweenCoordinates(
        'GOOGLE KEY',
        PointLatLng(latIni, lngIni),
        PointLatLng(latFim, lngFim));
    List<PointLatLng> result = result1.points;
    if (result.isNotEmpty) {
      result.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });

      setState(() {
        _polylines.clear();
        Polyline polyline = Polyline(
            polylineId: PolylineId("poly"),
            color: Color.fromARGB(255, 40, 122, 198),
            points: polylineCoordinates);
        _polylines.add(polyline);
      });
    }
  }

  navegar() async {
    createPolylines(
      controller.position?.latitude,
      controller.position?.longitude,
      double.parse(controller?.voucher?.latitude),
      double.parse(controller?.voucher?.longitude),
    );
    _geolocator.getPositionStream().listen((event) {
      if (_mapController != null) {
        _mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            new CameraPosition(
              target: LatLng(event.latitude, event.longitude),
              zoom: 16,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: 2,
          selectedItemColor: Color(0xFF88AC07),
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home), title: Text('Home')),
            BottomNavigationBarItem(
                icon: Icon(Icons.menu), title: Text('Cadastros')),
            BottomNavigationBarItem(
                icon: Icon(Icons.local_car_wash), title: Text('Postos')),
            BottomNavigationBarItem(
                icon: Icon(Icons.transform), title: Text('Transações')),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline), title: Text('Perfil'))
          ]),
      body: Stack(
        children: [
          Observer(
            builder: (context) {
              if (controller.isProcessingLoad)
                return Center(child: CircularProgressIndicator());
              return Column(
                children: [
                  Container(
                    color: Colors.white,
                    height: 56,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Digite o CEP ou Endereço',
                              hintStyle: TextStyle(
                                height: 3,
                                fontSize: 16,
                                color: Color(0xFF454545),
                              ),
                              border: InputBorder.none,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Icon(
                                  Icons.search,
                                  color: Color(0xFF88AC07),
                                ),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.format_list_bulleted,
                            color: Color(0xFF88AC07),
                          ),
                          onPressed: () {
                            print('algo');
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(-23.3144801, -51.1674387),
                          zoom: 16,
                        ),
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                          controller.setMapStyle(Utils.mapStyles);
                          _mapController = controller;
                        },
                        polylines: _polylines,
                        markers: markers.toSet(),
                        myLocationButtonEnabled: false,
                        myLocationEnabled: false,
                        compassEnabled: true,
                        onCameraMove: (position) =>
                            setLocalizacaoCustomizadaNaGambis()),
                  ),
                ],
              );
            },
          ),
          Observer(
            builder: (ctx) {
              if (controller.showBottom)
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) {
                    CustomBottomSheetWidget.showBottom(
                      title: Container(
                        width: MediaQuery.of(ctx).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.photo,
                              size: 68,
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: Text(
                                'Posto \nSão Martinho',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Avenida São José do Campos, 2500',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Campinas, SP',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Distância: 11.21 km',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'Posto 24 horas',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color(0xFF88AC07)),
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 32),
                            child: Divider(
                              color: Color(0xFFADADAD),
                              thickness: 1,
                            ),
                          ),
                          Text(
                            'Horário de Funcionamento:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '24 horas',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Preços:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: Text('Gasolina',
                                      style: TextStyle(fontSize: 16))),
                              Expanded(
                                  flex: 1,
                                  child: Text('R\$ 0,000',
                                      style: TextStyle(fontSize: 16))),
                              Expanded(
                                  flex: 1,
                                  child: Text('Não Autalizado',
                                      style: TextStyle(fontSize: 12))),
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: Text('Etanol',
                                      style: TextStyle(fontSize: 16))),
                              Expanded(
                                  flex: 1,
                                  child: Text('R\$ 0,000',
                                      style: TextStyle(fontSize: 16))),
                              Expanded(
                                  flex: 1,
                                  child: Text('Não Autalizado',
                                      style: TextStyle(fontSize: 12))),
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: Text('Diesel',
                                      style: TextStyle(fontSize: 16))),
                              Expanded(
                                  flex: 1,
                                  child: Text('R\$ 0,000',
                                      style: TextStyle(fontSize: 16))),
                              Expanded(
                                  flex: 1,
                                  child: Text('Não Autalizado',
                                      style: TextStyle(fontSize: 12))),
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: Text('D. s10',
                                      style: TextStyle(fontSize: 16))),
                              Expanded(
                                  flex: 1,
                                  child: Text('R\$ 0,000',
                                      style: TextStyle(fontSize: 16))),
                              Expanded(
                                  flex: 1,
                                  child: Text('Não Autalizado',
                                      style: TextStyle(fontSize: 12))),
                            ],
                          ),
                          SizedBox(height: 16),
                          Container(
                            height: 120,
                            width: double.infinity,
                            color: Colors.grey[350],
                          ),
                          SizedBox(height: 26),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.call,
                                    size: 20,
                                    color: Color(0xFF88AC07),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Ligar',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF88AC07),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                      icon: Icon(
                                        Icons.near_me,
                                        size: 20,
                                        color: Color(0xFF88AC07),
                                      ),
                                      onPressed: () {
                                        Modular.to.pop();
                                        navegar();
                                      }),
                                  SizedBox(width: 8),
                                  Text(
                                    'Rota',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF88AC07),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 25)
                        ],
                      ),
                    ).then((value) => controller.showBottom = false);
                  },
                );
              return IgnorePointer();
            },
          ),
          Positioned(
            top: offsetY,
            left: offsetX,
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: Color(0xFF88AC07).withOpacity(.12),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Align(
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Color(0xFF88AC07).withOpacity(.25),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Align(
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: Color(0xFF88AC07),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Utils {
  static String mapStyles = '''[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#bdbdbd"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#ffffff"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dadada"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#c9c9c9"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  }
]''';
}
