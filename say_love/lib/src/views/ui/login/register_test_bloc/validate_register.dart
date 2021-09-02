
class Validate{
  //kiểm tra email
  static bool isValidEmail(String email) {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }
  //Kiểm tra mật khẩu
  static bool isValidPassWord(String password){
    return RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$').hasMatch(password);
  }

//  static bool checkValidEmail(String email){
//    if(email == null || isValidEmail(email)==false)
//      return false;
//    else return true;
//  }
//  static bool checkValidPassword(String password){
//    if(password == null||password.length<8||isValidPassWord(password)==false)
//      return false;
//    else return true;
//  }
//  static bool checkValidConfirmPassword(String confirmPassword, String password){
//    if(confirmPassword!=password)
//      return false;
//    else return true;
//  }


  static int checkValidEmail(String email){
    if(email.isEmpty) {
//      print("Bạn chưa nhập email.");
      return 1;
    }
    else if(isValidEmail(email)==false){
//      print("Email không hợp lệ.");
      return 2;
    }
    else return 0;
  }

  static int checkValidPassword(String password){
    if(password.isEmpty) {
//      print("Bạn chưa nhập password.");
      return 1;
    }
    else if(password.length<8){
//      print("Mật khẩu phải từ 8 kí tự trở lên.");
      return 2;
    }
    else if(isValidPassWord(password)==false){
//      print("Mật khẩu phải gồm chữ hoa, chữ thường và số.");
      return 3;
    }
    else return 0;
  }

  static int checkValidConfirmPassword(String confirmPassword, String password){
    if(confirmPassword!=password) {
//      print("Xác nhận mật khẩu không chính xác.");
      return 1;
    }
    else return 0;
  }
}