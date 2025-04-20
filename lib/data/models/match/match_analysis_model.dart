import 'package:json_annotation/json_annotation.dart';

part 'match_analysis_model.g.dart';

@JsonSerializable()
class MatchAnalysisModel {

  final String content;

  MatchAnalysisModel({
    required this.content,
  });

  factory MatchAnalysisModel.fromJson(Map<String, dynamic> json) =>
      _$MatchAnalysisModelFromJson(json);

  Map<String, dynamic> toJson() => _$MatchAnalysisModelToJson(this);
}
