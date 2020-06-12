import 'package:flutter_modular/flutter_modular.dart';
import 'package:dio/dio.dart';
import 'package:poc_maps/app/modules/home/feed_model.dart';

class HomeRepository extends Disposable {
  final Dio dio;
  HomeRepository(this.dio);

  Future fetchPost() async {
    var json = {
      "categorias": [],
      "vouchers": [
        {
          "latitude": "-23.7272692",
          "longitude": "-51.0939353",
          "nomeVoucher": "ECOMUNICADO – COVID-19",
        },
        {
          "latitude": "-23.3455153",
          "longitude": "-51.1923023",
          "nomeVoucher": "Fatia de Torta",
        },
        {
          "latitude": "-23.2971959",
          "longitude": "-51.173034",
          "nomeVoucher": "Padaria Manhã",
        },
        {
          "latitude": "-23.3036756",
          "longitude": "-51.1452306",
          "nomeVoucher": "COMBO BOLO SECO + REFRIGERANTE  ",
        },
        {
          "latitude": "-23.3036756",
          "longitude": "-51.1452306",
          "nomeVoucher": "Marmita Mini",
        },
        {
          "latitude": "-23.3036756",
          "longitude": "-51.1452306",
          "nomeVoucher": "Salgado + Doce",
        },
        {
          "latitude": "-23.3135067",
          "longitude": "-51.1607657",
          "nomeVoucher": "Prato do Dia",
        },
        {
          "latitude": "-23.3052891",
          "longitude": "-51.1991661",
          "nomeVoucher": "Marmita M",
        },
        {
          "latitude": "-23.3239754",
          "longitude": "-51.1577663",
          "nomeVoucher": "Marmita Vegetariana",
        },
        {
          "latitude": "-23.3239754",
          "longitude": "-51.1577663",
          "nomeVoucher": "Marmita M",
        },
        {
          "latitude": "-23.3013121",
          "longitude": "-51.1863056",
          "nomeVoucher": "Hot Roll 20 unidades ",
        },
        {
          "latitude": "-23.3096929",
          "longitude": "-51.1700913",
          "nomeVoucher": "Marmita M",
        },
        {
          "latitude": "-23.3119795",
          "longitude": "-51.1559414",
          "nomeVoucher": "Marmita M",
        },
        {
          "latitude": "-23.3099083",
          "longitude": "-51.1664496",
          "nomeVoucher": "Marmita Vegetariana",
        },
        {
          "latitude": "-23.314577",
          "longitude": "-51.166899",
          "nomeVoucher": "Marmitex Mini",
        },
        {
          "latitude": "-23.314577",
          "longitude": "-51.166899",
          "nomeVoucher": "Marmitex Media",
        },
        {
          "latitude": "-23.3178144",
          "longitude": "-51.1586827",
          "nomeVoucher": "Bolo Caseiro Médio",
        },
        {
          "latitude": "-23.300199",
          "longitude": "-51.175733",
          "nomeVoucher": "Marmitex Pequena",
        },
        {
          "latitude": "-23.3340425",
          "longitude": "-51.175124",
          "nomeVoucher": "Almoço Buffet",
        },
        {
          "latitude": "-23.3340425",
          "longitude": "-51.175124",
          "nomeVoucher": "Buffet (Vegetariano)",
        },
        {
          "latitude": "-23.3130818",
          "longitude": "-51.1616184",
          "nomeVoucher": "Marmitex Self Service - Almoço",
        },
        {
          "latitude": "-23.3130818",
          "longitude": "-51.1616184",
          "nomeVoucher": "Marmitex Saladas",
        },
        {
          "latitude": "-23.2584543",
          "longitude": "-51.150416",
          "nomeVoucher": "Marmita P",
        },
        {
          "latitude": "-23.3171407",
          "longitude": "-51.1463859",
          "nomeVoucher":
              "02 Tortas Individuais Salgadas (Pode Conter Opções Vegetarias e Vegana)",
        },
        {
          "latitude": "-23.3455153",
          "longitude": "-51.1923023",
          "nomeVoucher": "Fatia de Torta",
        },
        {
          "latitude": "-23.327447",
          "longitude": "-51.1775946",
          "nomeVoucher": "Box Doce e Salgado",
        },
        {
          "latitude": "-23.3425116",
          "longitude": "-51.1887908",
          "nomeVoucher": "Voucher Doces e Salgados",
        },
        {
          "latitude": "-23.3051231",
          "longitude": "-51.1988876",
          "nomeVoucher": "Nhoque Frango Misto",
        },
        {
          "latitude": "-23.3051231",
          "longitude": "-51.1988876",
          "nomeVoucher": "Nhoque Frango Sugo, Frango e Molho  Vermelho ",
        },
        {
          "latitude": "-23.3051231",
          "longitude": "-51.1988876",
          "nomeVoucher": "Nhoque Misto Ao Molho Branco e Vermelho",
        },
        {
          "latitude": "-23.2971959",
          "longitude": "-51.173034",
          "nomeVoucher": "Padaria Noite",
        },
        {
          "latitude": "-23.3200865",
          "longitude": "-51.148742",
          "nomeVoucher":
              "Canja Especial (Não Acompanha Torrada e Queijo Ralado)",
        },
        {
          "latitude": "-23.3156221",
          "longitude": "-51.168291",
          "nomeVoucher": "Sushi Classico 16 Unidades",
        },
        {
          "latitude": "-23.33229",
          "longitude": "-51.1674032",
          "nomeVoucher": "Combo de Sushi",
        },
        {
          "latitude": "-23.3001871",
          "longitude": "-51.175682",
          "nomeVoucher": "Cesta de Frutas",
        },
        {
          "latitude": "-23.3001871",
          "longitude": "-51.175682",
          "nomeVoucher": "Kit Frutas e Legumes",
        }
      ]
    };
    return Feed.fromJson(json);
  }

  //dispose will be called automatically
  @override
  void dispose() {}
}
