import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:say_love/src/models/slide_page.dart';
import 'package:say_love/src/views/ui/login/login_screen.dart';
import 'package:say_love/src/views/ui/welcome_page/slide_dot.dart';
import 'package:say_love/src/views/ui/welcome_page/slide_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

//@required this.textEmail, this.textPassword
class WelcomePage extends StatefulWidget {
//  MyAppOne({});
  @override
  _WelcomePage createState() => _WelcomePage();
}

class _WelcomePage extends State<WelcomePage> {
  int _currentPage = 0;
  PageController _pageController = PageController();
  int count;

  @override
  void initState(){
    super.initState();
    _pageController = PageController(
      initialPage: 0,
    );
  }

  @override
  void dispose(){
    _pageController.dispose();
    super.dispose();
  }

  _onPageChanged(int index){
    setState(() {
      _currentPage = index;
    });
  }

  Future<Null> inLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.setState(() {
        count = 1;
        prefs.setInt('number_check', count);
    });
    print(count);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
            child: Stack(
              children:<Widget> [
                PageView.builder(
                  scrollDirection: Axis.horizontal,
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: slideList.length,
                  itemBuilder: (context, i)=>SlideItem(i),
                ),
                Positioned(
                    top: 750,
                    left: 20,
                    right: 0,
                    bottom: 0,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:<Widget> [
                      for(int i=0; i < slideList.length; i++)
                        if(i==_currentPage)
                          SlideDots(true)
                        else
                          SlideDots(false)
                    ],
                  ),
                ),
                Positioned(
                  top: 750,
                  left: 300,
                  right: 20,
                  bottom: 0,
                  child: Stack(
                    children:<Widget> [
                      if(_currentPage ==2)
                      Container(
                        height: 30,
                        width: 85,
                        child: RaisedButton(
                          color:  Colors.red,
                          child: Text(
                            "START",
                            style: TextStyle(
                              color:Colors.white, fontSize: 13,
                              fontWeight: FontWeight.bold
                            ),
                            textAlign: TextAlign.center,
                            ),
                            shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            ),
                            onPressed: (){
                              inLogin();
                              },
                        )
                      )
                      else Container(
                          height: 30,
                          width: 75,
                          child: RaisedButton(
                            color:  Colors.white,
                            child: Text(
                              "NEXT",
                              style: TextStyle(
                                  color:Colors.red, fontSize: 13,
                                  fontWeight: FontWeight.bold
                              ),
                              textAlign: TextAlign.center,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            onPressed: (){
                              _pageController.nextPage(duration: Duration(milliseconds: 400), curve: Curves.easeIn);
                            },
                          )
                      )
                    ],
                  ),
                )
              ],
            ),
      ),
    );
  }

}

