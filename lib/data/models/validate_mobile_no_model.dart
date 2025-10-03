class ValidationResponse {
  bool? isValid;
  bool? alreadyRegistered;

  ValidationResponse({this.isValid, this.alreadyRegistered});

  ValidationResponse.fromJson(Map<String, dynamic> json) {
    isValid = json['isvalid'];
    alreadyRegistered = json['already_registered'];
  }

  Map<String, dynamic> toJson()  {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isvalid'] = isValid;
    data['already_registered'] = alreadyRegistered;
    return data;
  }
}

class ValidateVarMobileModel {
  bool? isSuccess;
  Null errMsg;
  String? rI;
  D? d;
  int? code;

  ValidateVarMobileModel(
      {this.isSuccess, this.errMsg, this.rI, this.d, this.code});

  ValidateVarMobileModel.fromJson(Map<String, dynamic> json) {
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
  ValidationResponse? response;

  RD({this.response});

  RD.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null
        ? ValidationResponse.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (response != null) {
      data['response'] = response!.toJson();
    }
    return data;
  }
}