class StopwatchHistory {
  String? id;
  DateTime? startTime;
  DateTime? endTime;
  Duration? duration;

  StopwatchHistory({
    this.startTime,
    this.endTime,
    this.duration,
    this.id,
  });

  factory StopwatchHistory.fromJson(Map<dynamic, dynamic> json) {
    return StopwatchHistory(
      id: (json.containsKey('id')) ? json['id'] : null,
      startTime: (json.containsKey('startTime'))
          ? DateTime.parse(json['startTime'])
          : null,
      endTime: (json.containsKey('endTime'))
          ? DateTime.parse(json['endTime'])
          : null,
      duration: (json.containsKey('endTime'))
          ? Duration(milliseconds: json['duration'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (startTime != null) 'startTime': startTime!.toIso8601String(),
      if (endTime != null) 'endTime': endTime!.toIso8601String(),
      if (duration != null) 'duration': duration!.inMilliseconds,
    };
  }
}
