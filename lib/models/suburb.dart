class Suburb {
  String? cityId;
  String? cityName;
  String? cityFlg;
  String? cityParent;

  Suburb({this.cityId, this.cityName, this.cityFlg, this.cityParent});

  Suburb.fromJson(Map<String, dynamic> json) {
    cityId = json['city_id'];
    cityName = json['city_name'];
    cityFlg = json['city_flg'];
    cityParent = json['city_parent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['city_id'] = cityId;
    data['city_name'] = cityName;
    data['city_flg'] = cityFlg;
    data['city_parent'] = cityParent;
    return data;
  }
}
