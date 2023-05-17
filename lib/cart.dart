import 'dart:convert';
//import 'dart:ui' as ui;
import 'package:canandies/util/user_shared_preferences.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  List<String> cart =[];

  @override
  void initState(){

    super.initState();
    cart = UserSharedPreferences.getCart() ;

  }

  @override
  Widget build(BuildContext context) {
    //var length;
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Carrito'),
        centerTitle: true,
      ),
      body:  Center(
        child: cart.length == 0? const Text("Todavía no has agregado nada a tu carrito") : Column(
          children: [
            Expanded(
                child: ListView.separated(
                  padding:  EdgeInsets.all(8),
                  itemCount: cart.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      //margin: const EdgeInsets.all(2),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: Image.network(jsonDecode(cart[index])["img"] ),
                            title: Text( jsonDecode(cart[index])["name"] + ' [ x' + jsonDecode(cart[index])["rep"] + " ]"),
                            subtitle: Text( "Precio: \$" + ( double.parse(jsonDecode(cart[index])["price"]) *  double.parse(jsonDecode(cart[index])["rep"])).toString() + " MXN"),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) => const Divider(),
                )
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                textStyle: const TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
                padding: const EdgeInsets.all(12.0),
              ),
              child: Text("SOLICITAR PRODUCTOS [ \$${UserSharedPreferences.getPrice()} MXN ]"),
              onPressed: () {

                Navigator.pop(context);
                UserSharedPreferences.launchWhatsAppString();
              },
            )
          ],
        )
      ),
    );
  }
}
