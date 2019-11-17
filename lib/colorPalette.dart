import 'dart:ui';

Color headerColor = Color.fromRGBO(42, 71, 71, 1);
Color primaryColor = Color.fromRGBO(67, 151, 117, 1);
Color secondaryColor = Color.fromRGBO(72, 191, 132, 1);
Color errorColor = Color.fromRGBO(255, 69, 58, 1);
class ColorPalette{
  Color getHeaderColor(){
    return headerColor;
  }
  Color getPrimaryColor(){
    return primaryColor;
  }
  Color getSecondaryColor(){
    return secondaryColor;
  }
  Color getErrorColor(){
    return errorColor;
  }
}