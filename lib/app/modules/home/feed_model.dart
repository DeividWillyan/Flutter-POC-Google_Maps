class Feed {
  List<Categorias> categorias;
  List<Vouchers> vouchers;

  Feed({this.categorias, this.vouchers});

  Feed.fromJson(Map<String, dynamic> json) {
    if (json['categorias'] != null) {
      categorias = new List<Categorias>();
      json['categorias'].forEach((v) {
        categorias.add(new Categorias.fromJson(v));
      });
    }
    if (json['vouchers'] != null) {
      vouchers = new List<Vouchers>();
      json['vouchers'].forEach((v) {
        vouchers.add(new Vouchers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.categorias != null) {
      data['categorias'] = this.categorias.map((v) => v.toJson()).toList();
    }
    if (this.vouchers != null) {
      data['vouchers'] = this.vouchers.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categorias {
  String idCategoria;
  String imgCategoria;
  String nomeCategoria;

  Categorias({this.idCategoria, this.imgCategoria, this.nomeCategoria});

  Categorias.fromJson(Map<String, dynamic> json) {
    idCategoria = json['idCategoria'];
    imgCategoria = json['imgCategoria'];
    nomeCategoria = json['nomeCategoria'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idCategoria'] = this.idCategoria;
    data['imgCategoria'] = this.imgCategoria;
    data['nomeCategoria'] = this.nomeCategoria;
    return data;
  }
}

class Vouchers {
  int idEC;
  String nomeEC;
  int destaque;
  String latitude;
  String longitude;
  int idVoucher;
  String nomeVoucher;
  String hrInicial;
  String hrFinal;
  String preco;
  int idCategoria;
  String categoria;
  dynamic avaliacao;
  String imgEC;
  String imgVoucher;
  int isAtivo;
  String descricaoEC;
  int qtdVouchers;

  Vouchers(
      {this.idEC,
      this.nomeEC,
      this.destaque,
      this.latitude,
      this.longitude,
      this.idVoucher,
      this.nomeVoucher,
      this.hrInicial,
      this.hrFinal,
      this.preco,
      this.idCategoria,
      this.categoria,
      this.avaliacao,
      this.imgEC,
      this.imgVoucher,
      this.isAtivo,
      this.descricaoEC,
      this.qtdVouchers});

  Vouchers.fromJson(Map<String, dynamic> json) {
    idEC = json['idEC'];
    nomeEC = json['nomeEC'];
    destaque = json['destaque'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    idVoucher = json['idVoucher'];
    nomeVoucher = json['nomeVoucher'];
    hrInicial = json['hrInicial'];
    hrFinal = json['hrFinal'];
    preco = json['preco'];
    idCategoria = json['idCategoria'];
    categoria = json['categoria'];
    avaliacao = json['avaliacao'];
    imgEC = json['imgEC'];
    imgVoucher = json['imgVoucher'];
    isAtivo = json['isAtivo'];
    descricaoEC = json['descricaoEC'];
    qtdVouchers = json['qtdVouchers'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idEC'] = this.idEC;
    data['nomeEC'] = this.nomeEC;
    data['destaque'] = this.destaque;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['idVoucher'] = this.idVoucher;
    data['nomeVoucher'] = this.nomeVoucher;
    data['hrInicial'] = this.hrInicial;
    data['hrFinal'] = this.hrFinal;
    data['preco'] = this.preco;
    data['idCategoria'] = this.idCategoria;
    data['categoria'] = this.categoria;
    data['avaliacao'] = this.avaliacao;
    data['imgEC'] = this.imgEC;
    data['imgVoucher'] = this.imgVoucher;
    data['isAtivo'] = this.isAtivo;
    data['descricaoEC'] = this.descricaoEC;
    data['qtdVouchers'] = this.qtdVouchers;
    return data;
  }
}
