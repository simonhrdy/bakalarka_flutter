import 'package:json_annotation/json_annotation.dart';

part 'stadium_model.g.dart';

@JsonSerializable()
class StadiumModel {
  final int id;
  final String name;
  final int? capacity;

  StadiumModel({
    required this.id,
    required this.name,
    this.capacity
  });

  factory StadiumModel.fromJson(Map<String, dynamic> json) =>
      _$StadiumModelFromJson(json);

  Map<String, dynamic> toJson() => _$StadiumModelToJson(this);
}
