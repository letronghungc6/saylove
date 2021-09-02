class Hobby{
  int id;
  String value;

  Hobby.fromJson(Map<String, dynamic> json):
        this.id = json["id"],
        this.value = json["value_hobby"];
}

