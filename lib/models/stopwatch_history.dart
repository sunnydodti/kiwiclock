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

  factory StopwatchHistory.fromJson(Map<String, dynamic> json) {
    return StopwatchHistory(
      id: json['id'],
      startTime: json['startTime'] != null
          ? DateTime.parse(json['startTime'])
          : null,
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
      'id': id,
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'duration': duration?.inMilliseconds,
      'createdBy': createdBy,
      'name': name,
      'description': description,
      'views': views,
    };
  }
}
