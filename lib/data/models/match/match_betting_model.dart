import 'package:json_annotation/json_annotation.dart';

part 'match_betting_model.g.dart';

@JsonSerializable()
class MatchBettingModel {

  final String content;

  MatchBettingModel({
    required this.content,
  });

  factory MatchBettingModel.fromJson(Map<String, dynamic> json) =>
      _$MatchBettingModelFromJson(json);

  Map<String, dynamic> toJson() => _$MatchBettingModelToJson(this);
}
