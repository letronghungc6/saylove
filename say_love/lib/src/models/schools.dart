
class Schools{
  int id;
  String name;
  String code;
  Schools.fromJson(Map<String, dynamic> json):
        this.id = json["id"],
        this.name = json["name"],
        this.code = json["code"];
}
