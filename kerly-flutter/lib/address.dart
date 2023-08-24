import 'dart:convert';

List<Address> addressFromJson(String str) => List<Address>.from(json.decode(str).map((x) => Address.fromJson(x)));

String addressToJson(List<Address> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Address {

  static String tableName = "address";
  int? id;
  String postCode;
  String address;
  String detailInfo;

  Address({
    this.id,
    required this.postCode,
    required this.address,
    required this.detailInfo,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json["id"],
    postCode: json["postCode"],
    address: json["address"],
    detailInfo: json["detailInfo"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "postCode": postCode,
    "address": address,
    "detailInfo": detailInfo,
  };


  Address updateAddress({
    int? id,
    String? postCode,
    String? address,
    String? detailInfo
  }) {
    return Address(
      id: id ?? this.id,
      postCode: postCode ?? this.postCode,
      address: address ?? this.address,
      detailInfo: detailInfo ?? this.detailInfo
    );
  }
}

