import 'package:json_annotation/json_annotation.dart';

part 'sport_model.g.dart';

@JsonSerializable()
class SportModel {
  final int id;
  final String name;
  final String img_src;
  final String url;

  SportModel({
    required this.id,
    required this.name,
    required this.img_src,
    required this.url,
  });

  factory SportModel.fromJson(Map<String, dynamic> json) =>
      _$SportModelFromJson(json);

  Map<String, dynamic> toJson() => _$SportModelToJson(this);
}
