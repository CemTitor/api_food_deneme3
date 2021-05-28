import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//liste olan json yani sadece datalar var
// diğer main.dart da map olarak var yani data ,succes ve message

Future<Food> fetchFood() async {
  final response = await http.get(Uri.parse(
      'https://192.168.1.103:44394/api/Products/getall')); //certificate verify failed //büyük ihtimal bu kod calısıcak
  // .get(Uri.parse('https://localhost:44394/api/Products/getall')); //socket
  // .get(Uri.parse('https://10.2.2.2:44394/api/Products/getall')); //response null
  // .get(Uri.parse('https://localhost:5001/api/Products/getall')); //socket exception
  // .get(Uri.parse('https://localhost:44394/swagger/v1/swagger.json')); //socket exception

  print(
      jsonDecode(response.body)[0]['productName']); //büyük ihtimal dogru kod bu
  print(jsonDecode(response.body)[0]);
  print(jsonDecode(response.body));
  print(jsonDecode(response.body));
  print('hello');
  print(response.body);
  print(Food.fromJson(jsonDecode(response.body)[0]['productName']));
  print(Food.fromJson(jsonDecode(response.body)[0]));
  print(Food.fromJson(jsonDecode(response.body)));
  print(Food.fromJson(jsonDecode(response.body)));
  print(foodFromJson(response.body)[0].productName);
  print(foodFromJson(response.body)[0].categoryId);
  print(foodFromJson(response.body)[0].unitsInStock);
  print(foodFromJson(response.body)[0].unitPrice);
  print(foodFromJson(response.body)[0].productId);
  print(foodFromJson(response.body)[0]);
  print(foodFromJson(response.body));

  if (response.statusCode < 300) {
    print('200 kodu');
    return Food.fromJson(jsonDecode(response.body));
  } else {
    print(response.statusCode);
    throw Exception(response);
  }
}

List<Food> foodFromJson(String str) =>
    List<Food>.from(json.decode(str).map((x) => Food.fromJson(x)));

class Food {
  Food({
    required this.productId,
    required this.categoryId,
    required this.productName,
    required this.unitsInStock,
    required this.unitPrice,
  });

  final int productId;
  final int categoryId;
  final String productName;
  final int unitsInStock;
  final double unitPrice;

  factory Food.fromJson(Map<String, dynamic> json) => Food(
        productId: json["productId"],
        categoryId: json["categoryId"],
        productName: json["productName"],
        unitsInStock: json["unitsInStock"],
        unitPrice: json["unitPrice"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "categoryId": categoryId,
        "productName": productName,
        "unitsInStock": unitsInStock,
        "unitPrice": unitPrice,
      };
}

void main() async {
  runApp(MyApp());
  // HttpOverrides.global = new MyHttpOverrides();
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Food> futureFood;

  @override
  void initState() {
    super.initState();
    futureFood = fetchFood();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Datsa Example'),
        ),
        body: Center(
          child: FutureBuilder<Food>(
            future: futureFood,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print('data var');
                return Text(snapshot.data!.productName);
              } else if (snapshot.hasError) {
                return Text('hata1');
              }
              print('hata2');
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
