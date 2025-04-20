import 'package:json_annotation/json_annotation.dart';

part 'sport_params.g.dart';

@JsonSerializable()
class SportParams {
  SportParams({
    required this.name,
    required this.url,
    required this.img,
  });

  factory SportParams.fromJson(Map<String, dynamic> json) =>
      _$SportParamsFromJson(json);

  final String name;
  final String url;

  @JsonKey(name: 'img_src')
  final String img;

  Map<String, dynamic> toJson() => _$SportParamsToJson(this);
}
