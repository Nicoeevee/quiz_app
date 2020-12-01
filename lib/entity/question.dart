// To parse this JSON data, do
//
//     final question = questionFromJson(jsonString);

import 'dart:convert';

List<Question> questionFromJson(String str) => List<Question>.from(json.decode(str).map((x) => Question.fromJson(x)));

String questionToJson(List<Question> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Question {
  Question({
    this.answer,
    this.difficulty,
    this.exercise,
    this.gmtCreate,
    this.gmtModified,
    this.id,
    this.image,
    this.type,
    this.work,
  });

  String answer;
  Difficulty difficulty;
  String exercise;
  int gmtCreate;
  int gmtModified;
  int id;
  Image image;
  Type type;
  Work work;

  Question copyWith({
    String answer,
    Difficulty difficulty,
    String exercise,
    int gmtCreate,
    int gmtModified,
    int id,
    Image image,
    Type type,
    Work work,
  }) =>
      Question(
        answer: answer ?? this.answer,
        difficulty: difficulty ?? this.difficulty,
        exercise: exercise ?? this.exercise,
        gmtCreate: gmtCreate ?? this.gmtCreate,
        gmtModified: gmtModified ?? this.gmtModified,
        id: id ?? this.id,
        image: image ?? this.image,
        type: type ?? this.type,
        work: work ?? this.work,
      );

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        answer: json["answer"] == null ? null : json["answer"],
        difficulty: json["difficulty"] == null ? null : difficultyValues.map[json["difficulty"]],
        exercise: json["exercise"] == null ? null : json["exercise"],
        gmtCreate: json["gmtCreate"] == null ? null : json["gmtCreate"],
        gmtModified: json["gmtModified"] == null ? null : json["gmtModified"],
        id: json["id"] == null ? null : json["id"],
        image: json["image"] == null ? null : imageValues.map[json["image"]],
        type: json["type"] == null ? null : typeValues.map[json["type"]],
        work: json["work"] == null ? null : workValues.map[json["work"]],
      );

  Map<String, dynamic> toJson() => {
        "answer": answer == null ? null : answer,
        "difficulty": difficulty == null ? null : difficultyValues.reverse[difficulty],
        "exercise": exercise == null ? null : exercise,
        "gmtCreate": gmtCreate == null ? null : gmtCreate,
        "gmtModified": gmtModified == null ? null : gmtModified,
        "id": id == null ? null : id,
        "image": image == null ? null : imageValues.reverse[image],
        "type": type == null ? null : typeValues.reverse[type],
        "work": work == null ? null : workValues.reverse[work],
      };
}

enum Difficulty { PRIMARY, INTERMEDIATE, ADVANCED }

final difficultyValues = EnumValues({
  "初级": Difficulty.PRIMARY,
  "中级": Difficulty.INTERMEDIATE,
  "高级": Difficulty.ADVANCED,
});

enum Image { EMPTY }

final imageValues = EnumValues({
  "题目的图片": Image.EMPTY,
});

enum Type { FITB, TOF }

final typeValues = EnumValues({
  "填空题": Type.FITB,
  "判断题": Type.TOF,
});

enum Work { EMPTY }

final workValues = EnumValues({
  "化验员": Work.EMPTY,
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
