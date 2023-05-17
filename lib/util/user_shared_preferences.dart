


import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPreferences {
  static SharedPreferences? _preferences;

  static Future init() async =>
    _preferences = await SharedPreferences.getInstance();


  static Future addToCart(String itemName, String itemPrice, String itemImg) async {

  List<String>? controlCart = _preferences?.getStringList("cart") ?? [];
  List<String>? cart = [...controlCart];
  String candyJson = "{}";

  if(cart.isNotEmpty){

    bool isInCart = false;
    controlCart.asMap().forEach((i, item) {

      var candy = jsonDecode(item) ;

      if(candy['name'] == itemName){
        isInCart = true;

        int rep = int.parse( jsonDecode((cart)[i])["rep"] );
        rep ++;
        cart.removeAt(i);

        candyJson = '{"name":"$itemName", "price":"$itemPrice", "img":"$itemImg", "rep":"$rep"}';

      }

    });

    if(!isInCart){
       candyJson = '{"name":"$itemName", "price":"$itemPrice", "img":"$itemImg", "rep":"1"}';
    }

  }else{
    candyJson = '{"name":"$itemName", "price":"$itemPrice", "img":"$itemImg", "rep":"1"}';
  }

  cart.add( candyJson );



  await _preferences?.setStringList("cart", cart);
    //print(_preferences?.get("cart").toString());
  }

  static  getCart()  {
    List<String>? cart = _preferences?.getStringList("cart") ?? [];
    return cart;
  }

  static getPrice()  {
    double totalPrice = 0.00;
    List<String>? cart = _preferences?.getStringList("cart") ?? [];

    if(cart.isNotEmpty){

      cart.asMap().forEach((i, item) {
         totalPrice += double.parse( jsonDecode((cart)[i])["price"] ) * double.parse( jsonDecode((cart)[i])["rep"] );
        });

    }
    //print(totalPrice);
    return totalPrice;
  }

  static clearCart() async{
    await _preferences?.remove("cart");
  }

  static launchWhatsAppString() async {
    //String number = "525579559747";
    String number = "525510825614";
    String message = "Hola, quisiera solicitar los siguientes productos:\n\n";
    List<String> cart = UserSharedPreferences.getCart();
   // List<String> requests = [];
    double finalPrice = 0.00;

    cart.asMap().forEach((i, item) {
      var jsonItem = jsonDecode(item);
      var productPrice = double.parse(jsonItem['price']) *
          double.parse(jsonItem['rep']);
      finalPrice += productPrice;

      /*requests.add(
          "${jsonItem['name']} [ x${jsonItem['name']} ] => $productPrice\n");*/
      message += "${jsonItem['name']} [ x${jsonItem['rep']} ] => $productPrice MXN.\n";
    });

    message += "\nCon un precio final de $finalPrice MXN.\n";

    UserSharedPreferences.clearCart();
    launch("https://wa.me/$number?text=$message");

  }
  }



