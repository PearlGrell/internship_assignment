import 'package:hive_ce/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_model.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class Post {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String body;
  @HiveField(3)
  final int userId;

  Post({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
  });

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);
}