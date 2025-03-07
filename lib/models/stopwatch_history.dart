import '../data/constants.dart';

class StopwatchHistory {
  String? id;
  DateTime? startTime;
  DateTime? endTime;
  Duration? duration;
  String? createdBy;
  String? name;
  String? description;
  int? views;

  StopwatchHistory({
    this.startTime,
    this.endTime,
    this.duration,
    this.id,
    this.createdBy,
    this.name,
    this.description,
    this.views,
  });

  factory StopwatchHistory.fromJson(Map<dynamic, dynamic> json) {
    return StopwatchHistory(
      id: json['id'],
      startTime:
          json['startTime'] != null ? DateTime.parse(json['startTime']) : null,
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      duration: json['duration'] != null
          ? Duration(milliseconds: json['duration'])
          : null,
      createdBy: json['createdBy'],
      name: json['name'],
      description: json['description'],
      views: json['views'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (startTime != null) 'startTime': startTime?.toIso8601String(),
      if (endTime != null) 'endTime': endTime?.toIso8601String(),
      if (duration != null) 'duration': duration?.inMilliseconds,
      if (createdBy != null) 'createdBy': createdBy,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (views != null) 'views': views,
    };
  }

  String get sharableLink => '${Constants.baseUrl}/stopwatch/$id';
}
