import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Task {
  final int? id;
  final String title;
  final String note;
  final int isCompleted;
  final String date;
  final String startTime;
  final String endTime;
  final int color;
  final int remind;
  final String repeat;

  Task(
      {this.id,
      required this.title,
      required this.note,
      required this.isCompleted,
      required this.date,
      required this.startTime,
      required this.endTime,
      required this.color,
      required this.remind,
      required this.repeat});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      note: json['note'],
      isCompleted: json['isCompleted'] ?? 0,
      date: json['date'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      color: json['color'],
      remind: json['remind'],
      repeat: json['repeat'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'note': note,
      'isCompleted': isCompleted,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'color': color,
      'remind': remind,
      'repeat': repeat,
    };
  }
}
