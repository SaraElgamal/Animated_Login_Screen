


import 'package:animation_test/animation_enum.dart';
import 'package:animation_test/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rive/rive.dart';


class LoginScreen extends StatefulWidget {


  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Artboard? riveArtBoard;
  late RiveAnimationController controllerIdle;
  late RiveAnimationController controllerHandsUp;
  late RiveAnimationController controllerHandsDown;
  late RiveAnimationController controllerFail;
  late RiveAnimationController controllerSuccess;
  late RiveAnimationController controllerLookDownRight;
  late RiveAnimationController controllerLookDownLeft;
bool isLookingLeft = false;
bool isLookingRight = false;
final passwordFocusNode = FocusNode();
  var testEmail = "saraabdelkader@gmail.com";
  var testPassword = "123456";

  var formKey = GlobalKey<FormState>();
  bool  isPassword = true;

  void removeAllControllers()
  {
    riveArtBoard?.artboard.removeController(controllerIdle);
    riveArtBoard?.artboard.removeController(controllerHandsUp);
    riveArtBoard?.artboard.removeController(controllerHandsDown);
    riveArtBoard?.artboard.removeController(controllerFail);
    riveArtBoard?.artboard.removeController(controllerSuccess);
    riveArtBoard?.artboard.removeController(controllerLookDownRight);
    riveArtBoard?.artboard.removeController(controllerLookDownLeft);
    isLookingLeft = false;
    isLookingRight = false;
  }
  void addIdleController()
  {
    removeAllControllers();
    riveArtBoard?.artboard.addController(controllerIdle);
    debugPrint("idlee");
  }
  void addHandUpController()
  {
    removeAllControllers();
    riveArtBoard?.artboard.addController(controllerHandsUp);
    debugPrint("Hand up");
  }
  void addHandDownController()
  {
    removeAllControllers();
    riveArtBoard?.artboard.addController(controllerHandsDown);
    debugPrint("Hand down");
  }
  void addFailController()
  {
    removeAllControllers();
    riveArtBoard?.artboard.addController(controllerFail);
    debugPrint("faiillll");
  }
  void addSuccessController()
  {
    removeAllControllers();
    riveArtBoard?.artboard.addController(controllerSuccess);
    debugPrint("Success");
  }
  void addLookDownRightController()
  {
    removeAllControllers();
    isLookingRight= true;
    riveArtBoard?.artboard.addController(controllerLookDownRight);
    debugPrint("look right");
  }
  void addLookDownLeftController()
  {
    removeAllControllers();
    isLookingLeft = true;
    riveArtBoard?.artboard.addController(controllerLookDownLeft);
    debugPrint("look left");
  }
  void checkForPasswordFocusNodeToChangeAnimationState()
  {
   passwordFocusNode.addListener(()
   {
    if (passwordFocusNode.hasFocus)
    {
      addHandUpController();
    }
    else if (!passwordFocusNode.hasFocus)
    {
      addHandDownController();
    }

   });
  }


  @override
  void initState() {
    super.initState();
    controllerIdle = SimpleAnimation(AnimationEnum.idle.name);
    controllerHandsUp = SimpleAnimation(AnimationEnum.hands_up.name);
    controllerHandsDown = SimpleAnimation(AnimationEnum.hands_down.name);
    controllerFail = SimpleAnimation(AnimationEnum.fail.name);
    controllerSuccess = SimpleAnimation(AnimationEnum.success.name);
    controllerLookDownRight = SimpleAnimation(AnimationEnum.Look_down_right.name);
    controllerLookDownLeft = SimpleAnimation(AnimationEnum.Look_down_left.name);

    //عشان اعمل اكسس على ال assets
    rootBundle.load('assets/bear.riv').then((data)
    {
      //كده بمسك الفايل على بعضه
   final file = RiveFile.import(data);
   //بيخليني أأكسس على ال status اللي جوا
   final artboard = file.mainArtboard;
   //بيعرفني ال default controller اللي هبدأ بيها
   artboard.addController(controllerIdle);
   setState(() {
     riveArtBoard = artboard;
   });
    });
    checkForPasswordFocusNodeToChangeAnimationState();
  }
 void validateEmailAndPassword()
 {
   Future.delayed(const Duration(seconds: 1), (){

   if(formKey.currentState!.validate())
   {
     addSuccessController();
   } else
   {
     addFailController();
   }
   });
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: HexColor('#d5e4ec'),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 SizedBox(
                     height: 250,
                     width: double.infinity,
                     child:
                     riveArtBoard == null ? SizedBox.shrink() :
                     Rive(artboard: riveArtBoard!)),

                  Container(

                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 5.0), //(x,y)
                          blurRadius: 6.0,
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                         TextFormField(
                           decoration: InputDecoration(
                             labelText: 'Email',
                             border: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(25.0),
                             ),
                           ),


                            validator: (value) => value != testEmail ? "wrong Email" : null,
                            onChanged: (value)
                            {
                              if (value.isNotEmpty && value.length < 16 && !isLookingLeft )
                              {
                                addLookDownLeftController();
                              }else if (value.isNotEmpty && value.length > 16 && !isLookingRight)
                              {
                                addLookDownRightController();
                              }
                            },
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),
                            focusNode: passwordFocusNode,


                            validator: (value) => value != testPassword ? "wrong password" : null,


                          ),



                          SizedBox(
                            height: 10.0,
                          ),
                          defaultButton(
                            text: 'login' ,

                            function: (){
                              passwordFocusNode.unfocus();
                              validateEmailAndPassword();

                              },
                          ),
                        ],
                      ),
                    ),
                  ),




                ],
              ),
            ),
          ),
        ),

      ),

    );
  }
}
