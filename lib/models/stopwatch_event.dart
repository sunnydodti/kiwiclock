import '../data/constants.dart';

class StopwatchEvent {
  String? id;
  DateTime? startTime;
  DateTime? endTime;
  Duration duration;
  String? author;
  String? name;
  String? description;
  int views;
  bool isPaused;
  Duration pauseDuration;

  StopwatchEvent({
    this.id,
    this.startTime,
    this.endTime,
    this.duration = const Duration(milliseconds: 0),
    this.author,
    this.name,
    this.description,
    this.views = 0,
    this.isPaused = false,
    this.pauseDuration = const Duration(milliseconds: 0),
  });

  factory StopwatchEvent.fromJson(Map<dynamic, dynamic> json) {
    return StopwatchEvent(
      id: json['id'],
      startTime:
          json['startTime'] != null ? DateTime.parse(json['startTime']) : null,
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      duration: Duration(milliseconds: json['duration']),
      author: json['createdBy'],
      name: json['name'],
      description: json['description'],
      views: json['views'],
      isPaused: json['isPaused'],
      pauseDuration: Duration(milliseconds: json['pauseDuration']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (startTime != null) 'startTime': startTime?.toIso8601String(),
      if (endTime != null) 'endTime': endTime?.toIso8601String(),
      if (author != null) 'createdBy': author,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      'duration': duration.inMilliseconds,
      'views': views,
      'isPaused': isPaused,
      'pauseDuration': pauseDuration.inMilliseconds,
    };
  }

  String get sharableLink => '${Constants.baseUrl}/stopwatch/$id';
  String get link => '${Constants.url}/stopwatch/$id';

  String get elapsedText {
    Duration d = duration;
    if (d.inMilliseconds < 1) return 'N/A';
    String text = '';

    if (d.inDays > 0) text += '${d.inDays}d ';
    if (d.inHours % 24 > 0) text += '${d.inHours % 24}h ';
    if (d.inMinutes % 60 > 0) text += '${d.inMinutes % 60}m ';
    if (d.inSeconds % 60 > 0) text += '${d.inSeconds % 60}s ';
    if (d.inMilliseconds % 1000 > 0) text += '${d.inMilliseconds % 1000}ms ';
    return text;
  }

  int get milliSecondsFromStart {
    if (startTime == null) return 0;
    final now = DateTime.now().toUtc();
    final a = now.millisecondsSinceEpoch; 
    final b = startTime!.millisecondsSinceEpoch;
    final c = pauseDuration.inMilliseconds;
    final d = a - b;
    final e = d - c;
    return e;
  }
}
