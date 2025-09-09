import 'package:json_annotation/json_annotation.dart';

part 'people_model.g.dart';

/// Deserialize and Serialize functions for People List Model
PeopleListModel deserializePeopleListModel(Map<String, dynamic> json) =>
    PeopleListModel.fromJson(json);

Map<String, dynamic> serializePeopleListModel(PeopleListModel data) =>
    data.toJson();

/// Main Model for People list response
@JsonSerializable(explicitToJson: true)
class PeopleListModel {
  final List<PeopleModel> users;

  PeopleListModel({required this.users});

  factory PeopleListModel.fromJson(Map<String, dynamic> json) =>
      _$PeopleListModelFromJson(json);

  Map<String, dynamic> toJson() => _$PeopleListModelToJson(this);
}

/// Individual People model
@JsonSerializable(explicitToJson: true)
class PeopleModel {
  final int id;
  final String firstName;
  final String lastName;
  final String maidenName;
  final int age;
  final String gender;
  final String email;
  final String phone;
  final String username;
  final String password;
  final String birthDate;
  final String image;
  final String bloodGroup;
  final double height;
  final double weight;
  final String eyeColor;
  final Hair hair;
  final String ip;
  final Address address;
  final String macAddress;
  final String university;
  final Bank bank;
  final Company company;
  final String ein;
  final String ssn;
  final String userAgent;
  final Crypto crypto;
  final String role;

  PeopleModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.maidenName,
    required this.age,
    required this.gender,
    required this.email,
    required this.phone,
    required this.username,
    required this.password,
    required this.birthDate,
    required this.image,
    required this.bloodGroup,
    required this.height,
    required this.weight,
    required this.eyeColor,
    required this.hair,
    required this.ip,
    required this.address,
    required this.macAddress,
    required this.university,
    required this.bank,
    required this.company,
    required this.ein,
    required this.ssn,
    required this.userAgent,
    required this.crypto,
    required this.role,
  });

  factory PeopleModel.fromJson(Map<String, dynamic> json) =>
      _$PeopleModelFromJson(json);

  Map<String, dynamic> toJson() => _$PeopleModelToJson(this);
}

@JsonSerializable()
class Hair {
  final String color;
  final String type;

  Hair({required this.color, required this.type});

  factory Hair.fromJson(Map<String, dynamic> json) => _$HairFromJson(json);
  Map<String, dynamic> toJson() => _$HairToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Address {
  final String address;
  final String city;
  final String state;
  final String stateCode;
  final String postalCode;
  final Coordinates coordinates;
  final String country;

  Address({
    required this.address,
    required this.city,
    required this.state,
    required this.stateCode,
    required this.postalCode,
    required this.coordinates,
    required this.country,
  });

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
  Map<String, dynamic> toJson() => _$AddressToJson(this);
}

@JsonSerializable()
class Coordinates {
  final double lat;
  final double lng;

  Coordinates({required this.lat, required this.lng});

  factory Coordinates.fromJson(Map<String, dynamic> json) =>
      _$CoordinatesFromJson(json);
  Map<String, dynamic> toJson() => _$CoordinatesToJson(this);
}

@JsonSerializable()
class Bank {
  final String cardExpire;
  final String cardNumber;
  final String cardType;
  final String currency;
  final String iban;

  Bank({
    required this.cardExpire,
    required this.cardNumber,
    required this.cardType,
    required this.currency,
    required this.iban,
  });

  factory Bank.fromJson(Map<String, dynamic> json) => _$BankFromJson(json);
  Map<String, dynamic> toJson() => _$BankToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Company {
  final String department;
  final String name;
  final String title;
  final Address address;

  Company({
    required this.department,
    required this.name,
    required this.title,
    required this.address,
  });

  factory Company.fromJson(Map<String, dynamic> json) =>
      _$CompanyFromJson(json);
  Map<String, dynamic> toJson() => _$CompanyToJson(this);
}

@JsonSerializable()
class Crypto {
  final String coin;
  final String wallet;
  final String network;

  Crypto({required this.coin, required this.wallet, required this.network});

  factory Crypto.fromJson(Map<String, dynamic> json) => _$CryptoFromJson(json);
  Map<String, dynamic> toJson() => _$CryptoToJson(this);
}
