// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: (json['id'] as num).toInt(),
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  maidenName: json['maidenName'] as String,
  address: Address.fromJson(json['address'] as Map<String, dynamic>),
  email: json['email'] as String,
  phone: json['phone'] as String,
  username: json['username'] as String,
  birthDate: json['birthDate'] as String,
  image: json['image'] as String,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'maidenName': instance.maidenName,
  'email': instance.email,
  'phone': instance.phone,
  'username': instance.username,
  'birthDate': instance.birthDate,
  'image': instance.image,
  'address': instance.address,
};

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
  address: json['address'] as String,
  city: json['city'] as String,
  state: json['state'] as String,
  country: json['country'] as String,
);

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
  'address': instance.address,
  'city': instance.city,
  'state': instance.state,
  'country': instance.country,
};
