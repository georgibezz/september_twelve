import 'package:get/get.dart';

class WelcomeAnimationsController extends GetxController {
  RxDouble closeButtonOpacity = 0.0.obs;
  RxDouble textFieldOpacity = 0.0.obs;
  RxDouble box1Opacity = 0.0.obs;
  RxDouble box2Opacity = 0.0.obs;
  RxDouble addButtonOpacity = 0.0.obs;
  RxDouble welcomeTextOpacity = 0.0.obs; // Add this line

  void updateAnimations({
    double? newCloseButtonOpacity,
    double? newTextFieldOpacity,
    double? newBox1Opacity,
    double? newBox2Opacity,
    double? newAddButtonOpacity,
    double? newWelcomeTextOpacity, // Add this line
  }) {
    closeButtonOpacity.value =
        newCloseButtonOpacity ?? closeButtonOpacity.value;
    textFieldOpacity.value =
        newTextFieldOpacity ?? textFieldOpacity.value;
    box1Opacity.value = newBox1Opacity ?? box1Opacity.value;
    box2Opacity.value = newBox2Opacity ?? box2Opacity.value;
    addButtonOpacity.value =
        newAddButtonOpacity ?? addButtonOpacity.value;
    welcomeTextOpacity.value = newWelcomeTextOpacity ?? welcomeTextOpacity.value; // Add this line
  }
}
