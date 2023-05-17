import 'package:canandies/cart.dart';
import 'package:canandies/util/user_shared_preferences.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await UserSharedPreferences.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "CANANDIES",
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(
        title: 'CANANDIES',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /*@override
  void initState(){
    super.initState();

    cart = UserSharedPreferences.addToCart(itemName) ?? ""
    valor default por si no existe;

  }*/

  @override
  Widget build(BuildContext context) {
    Widget candyPhotos = StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("candies").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Error al conseguir imágenes: ${snapshot.error}");
        }

        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text("Sin conexión");

          case ConnectionState.waiting:
            return const SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator()),
            );

          case ConnectionState.active:
            var totalCandies = 0;
            List<DocumentSnapshot> candyPhotos;

            if (snapshot.hasData) {
              candyPhotos = snapshot.data!.docs;
              totalCandies = candyPhotos.length;

              if (totalCandies > 0) {
                return Expanded(
                    child: GridView.builder(
                        padding: const EdgeInsets.only(bottom: 50.0),
                        itemCount: totalCandies,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        primary: false,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 4.0,
                                mainAxisSpacing: 10.0),
                        itemBuilder: (BuildContext contex, int index) {
                          return Center(
                            child: Column(children: [
                              GestureDetector(
                                onTap: () {},
                                child: SizedBox(
                                  width: 340,
                                  height: 200,
                                  child: Card(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    elevation: 6,
                                    margin: EdgeInsets.all(8),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          width: 335,
                                          height: 135,
                                          child: Image.network(
                                            candyPhotos[index].get("image_url"),
                                            fit: BoxFit.cover,
                                          ),
                                        ),

                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(candyPhotos[index]
                                                    .get("name")),
                                                Text(
                                                  "${candyPhotos[index].get("price")} MXN",
                                                  style: const TextStyle(
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                            TextButton(
                                                //child: Text (candyPhotos[index].get("price") + 'MXN'),
                                                child: const Text('Comprar',
                                                    style: TextStyle(fontSize: 12),
                                                  softWrap: false,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis
                                                ),
                                                onPressed: () {
                                                  final name =
                                                      candyPhotos[index]
                                                          .get("name");
                                                  final price =
                                                      candyPhotos[index]
                                                          .get("price");
                                                  final image =
                                                      candyPhotos[index]
                                                          .get("image_url");

                                                  final snackbar = SnackBar(
                                                    content: Text(name +
                                                        " agregado al carrito"),
                                                    action: SnackBarAction(
                                                      label: "Ver carrito",
                                                      onPressed: () {
                                                        Navigator.push(context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) {
                                                          return const CartScreen();
                                                        }));
                                                      },
                                                    ),
                                                  );
                                                  ScaffoldMessenger.of(context)
                                                    ..hideCurrentSnackBar()
                                                    ..showSnackBar(snackbar);

                                                  UserSharedPreferences
                                                      .addToCart(
                                                          name, price, image);
                                                })
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                          );
                        }
                        )
                );
              }
            }

            return Center(
              child: Column(
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(top: 50.0)),
                  Text(
                    "No se encontraron dulces",
                    style: Theme.of(context).textTheme.titleMedium,
                  )
                ],
              ),
            );

          case ConnectionState.done:
            return Text("Carga completada");
        }

        return Container(
          child: Text("No se encontraron dulces"),
        );
      },
    );

    return ScaffoldMessenger(
        //Permite no mostrar la snackbar en la siguinete pantalla
        child: Builder(
      builder: (context) => Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              widget.title,
            ),
            actions: <Widget>[
              IconButton(
                  onPressed: () {
                    //UserSharedPreferences.clearCart();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const CartScreen();
                    }));
                  },
                  icon: const Icon(Icons.shopping_cart))
            ],
          ),
          body: Container(
            child: Column(
              children: <Widget>[
                candyPhotos,
              ],
            ),
          )),
    ));
  }
}
