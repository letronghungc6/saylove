
import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:say_love/src/views/ui/login/register_test_bloc/validate_register.dart';

class RegisterBloc{
  StreamController _emailController = new StreamController();
  StreamController _passwordController = new StreamController();
  StreamController _confirmPasswordController = new StreamController();
  //Hàm get stream
  Stream get emailStream => _emailController.stream;
  Stream get passwordStream => _passwordController.stream;
  Stream get confirmPasswordStream => _confirmPasswordController.stream;

  var _dialogController= new BehaviorSubject();

  Stream get dialogStream => _dialogController.stream;

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

  bool checkValidEmail(String email){
    if(email.isEmpty){
      _dialogController.sink.add("Bạn chưa nhập email.");
      _emailController.sink.addError("Sai");
      return false;
    }
    else if(isValidEmail(email)==false){
      _dialogController.sink.add("Email không hợp lệ.");
      _emailController.sink.addError("Sai");
      return false;
    }
    else{
      _emailController.sink.addError("Đúng");
      return true;
    }
  }

  bool checkValidPassword(String password){
    if(password.isEmpty){
      _dialogController.sink.add("Bạn chưa nhập password.");
      _passwordController.sink.addError("Sai");
      return false;
    }
    else if(password.length < 8){
      _dialogController.sink.add("Mật khẩu phải từ 8 kí tự trở lên.");
      _passwordController.sink.addError("Sai");
      return false;
    }
    else if(isValidPassWord(password)==false){
      _dialogController.sink.add("Mật khẩu phải gồm chữ hoa, chữ thường và số.");
      _passwordController.sink.addError("Sai");
      return false;
    }
    else{
      _passwordController.sink.addError("Đúng");
      return true;
    }
  }

  bool checkValidConfirmPassword(String confirmPassword, String password){
    if(confirmPassword != password){
      _dialogController.sink.add("Xác nhận mật khẩu không đúng.");
      _confirmPasswordController.sink.addError("Sai");
      return false;
    }
    else {
      _confirmPasswordController.sink.addError("Đúng");
      return true;
    }
  }



//  bool isValidInfo(String email, String password, String confirmPassword){
//    if(Validate.checkValidEmail(email) == 1) {
//      _dialogController.sink.add("Bạn chưa nhập email.");
//      _emailController.sink.addError("Sai");
//      return false;
//    }
//    else if(Validate.checkValidEmail(email) == 2) {
//      _dialogController.sink.add("Email không hợp lệ.");
//      _emailController.sink.addError("Sai");
//      return false;
//    }
//    else if(Validate.checkValidPassword(password) == 1 ) {
//      _dialogController.sink.add("Bạn chưa nhập password.");
//      return false;
//    }
//    else if(Validate.checkValidPassword(password) == 2 ) {
//      _dialogController.sink.add("Mật khẩu phải từ 8 kí tự trở lên.");
//      return false;
//    }
//    else if(Validate.checkValidPassword(password) == 3 ) {
//      _dialogController.sink.add("Mật khẩu phải gồm chữ hoa, chữ thường và số.");
//      return false;
//    }
//    else if(Validate.checkValidConfirmPassword(confirmPassword, password) == 1) {
//      _dialogController.sink.add("Xác nhận mật khẩu không đúng.");
//      return false;
//    }
//    else if(Validate.checkValidEmail(email) == 0 && Validate.checkValidPassword(password) ==0 && Validate.checkValidConfirmPassword(confirmPassword, password) ==0) {
//      _dialogController.sink.add("Thông tin hợp lệ.");
//      _emailController.sink.addError("Đúng");
//      return true;
//    }
//  }

//  checkValidEmail(String email){
//    if(Validate.checkValidEmail(email) == 0)
//      _emailController.sink.addError("Sai");
//    else _emailController.sink.add("Đúng");
//  }
//  bool checkValidPassword(String password){
//    if(Validate.checkValidPassword(password) == 0) return true;
//    else return false;
//  }
//  bool checkValidConfirmPassword(confirmPassword, password){
//    if(Validate.checkValidConfirmPassword(confirmPassword, password) == 0) return true;
//    else return false;
//  }



  //Huỷ stream
void dispose(){
  _emailController.close();
  _passwordController.close();
  _confirmPasswordController.close();
  _dialogController.close();
}
}