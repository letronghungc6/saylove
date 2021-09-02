
class Profile {
  final String firstName;
  final String lastName;
  final int birthday;
  final String gender;
  final double weight;
  final double height;
  final String hobbies;
  final String school;
  final int schoolID;
  final String media;


//  Map<String, dynamic> toJson() => {
//    "first_name": this.firstName,
//    "last_name": this.lastName,
//    "birthday": this.birthday,
//    "gender": this.gender,
//    "height": this.height,
//    "weight": this.weight,
//    "hobby": this.hobbies,
//    "univer"
//  };

  Profile.fromJson(Map<String, dynamic> json):
        this.firstName = json["first_name"],
        this.lastName = json["last_name"],
        this.birthday = json["birthday"],
        this.gender = json["gender"],
        this.height = json["height"],
        this.weight = json["weight"],
        this.hobbies = json["hobby"],
        this.schoolID = json["university_id"],
        this.school = json["university_name"],
        this.media = json["media"];
}
