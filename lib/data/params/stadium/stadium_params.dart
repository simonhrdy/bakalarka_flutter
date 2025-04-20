import 'package:json_annotation/json_annotation.dart';

part 'stadium_params.g.dart';

@JsonSerializable()
class StadiumParams {
  StadiumParams({
    required this.name,
    this.capacity,
  });

  factory StadiumParams.fromJson(Map<String, dynamic> json) =>
      _$StadiumParamsFromJson(json);

  final String name;
  final int? capacity;

  Map<String, dynamic> toJson() => _$StadiumParamsToJson(this);
}
