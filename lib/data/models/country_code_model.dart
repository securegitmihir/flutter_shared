class CountryMobileCodesList {
  int? id;
  String? countryCode;
  String? shortcode;
  int? numberLength;

  CountryMobileCodesList({this.id, this.countryCode, this.shortcode, this.numberLength});

  CountryMobileCodesList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    countryCode = json['country_code'];
    shortcode = json['shortcode'];
    numberLength = json['number_length'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['country_code'] = countryCode;
    data['shortcode'] = shortcode;
    data['number_length'] = numberLength;
    return data;
  }
}

class CountryCodeModel {
  bool? isSuccess;
  Null errMsg;
  String? rI;
  D? d;
  int? code;

  CountryCodeModel({this.isSuccess, this.errMsg, this.rI, this.d, this.code});

  CountryCodeModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    errMsg = json['errMsg'];
    rI = json['RI'];
    d = json['D'] != null ? D.fromJson(json['D']) : null;
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isSuccess'] = isSuccess;
    data['errMsg'] = errMsg;
    data['RI'] = rI;
    if (d != null) {
      data['D'] = d!.toJson();
    }
    data['code'] = code;
    return data;
  }
}

class D {
  int? rId;
  int? tId;
  int? nT;
  Null fD;
  Null tD;
  Null sM;
  RD? rD;

  D({this.rId, this.tId, this.nT, this.fD, this.tD, this.sM, this.rD});

  D.fromJson(Map<String, dynamic> json) {
    rId = json['RId'];
    tId = json['TId'];
    nT = json['NT'];
    fD = json['FD'];
    tD = json['TD'];
    sM = json['SM'];
    rD = json['RD'] != null ? RD.fromJson(json['RD']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['RId'] = rId;
    data['TId'] = tId;
    data['NT'] = nT;
    data['FD'] = fD;
    data['TD'] = tD;
    data['SM'] = sM;
    if (rD != null) {
      data['RD'] = rD!.toJson();
    }
    return data;
  }
}

class RD {
  List<CountryMobileCodesList>? countryMobilecodesList;

  RD({this.countryMobilecodesList});

  RD.fromJson(Map<String, dynamic> json) {
    if (json['country_mobilecodes_list'] != null) {
      countryMobilecodesList = <CountryMobileCodesList>[];
      json['country_mobilecodes_list'].forEach((v) {
        countryMobilecodesList!.add(CountryMobileCodesList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (countryMobilecodesList != null) {
      data['country_mobilecodes_list'] =
          countryMobilecodesList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
