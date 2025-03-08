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
  String get link => '${Constants.url}/stopwatch/$id';

  String get elapsedText {
    if (duration == null) return 'N/A';
    Duration d = duration!;
    if (d.inMilliseconds < 1) return 'N/A';
    String text = '';

    if (d.inDays > 0) text += '${d.inDays}d ';
    if (d.inHours % 24 > 0) text += '${d.inHours % 24}h ';
    if (d.inMinutes % 60 > 0) text += '${d.inMinutes % 60}m ';
    if (d.inSeconds % 60 > 0) text += '${d.inSeconds % 60}s ';
    if (d.inMilliseconds % 1000 > 0) text += '${d.inMilliseconds % 1000}ms ';
    return text;
  }
}
