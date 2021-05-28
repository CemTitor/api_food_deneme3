import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Food> fetchFood() async {
  final response = await http
      // .get(Uri.parse('https://192.168.1.103:44394/api/Products/getall'));
      // .get(Uri.parse('https://localhost:44394/api/Products/getall'));
      // .get(Uri.parse('https://10.2.2.2:44394/api/Products/getall'));
      .get(Uri.parse('https://localhost:5001/api/Products/getall'));
  print(jsonDecode(response.body)['data'][0]['productName']);
  print(jsonDecode(response.body)['data'][0]);
  print(jsonDecode(response.body)['data']);
  print(jsonDecode(response.body));
  print(Food.fromJson(jsonDecode(response.body)['data'][0]['productName']));
  print(Food.fromJson(jsonDecode(response.body)['data'][0]));
  print(Food.fromJson(jsonDecode(response.body)['data']));
  print(Food.fromJson(jsonDecode(response.body)));
  print(foodFromJson(response.body).data[0].productName);
  print(foodFromJson(response.body).data[0].categoryId);
  print(foodFromJson(response.body).data[0].unitsInStock);
  print(foodFromJson(response.body).data[0].unitPrice);
  print(foodFromJson(response.body).data[0].productId);
  print(foodFromJson(response.body).data[0]);
  print(foodFromJson(response.body).data);
  print(foodFromJson(response.body));

  if (response.statusCode == 200) {
    print('200 kodu');
    return Food.fromJson(jsonDecode(response.body)['data'][0]['productName']);
  } else {
    print(response.statusCode);
    throw Exception(response);
  }
}

class Food {
  final List<Datum> data;
  final bool success;
  final String message;

  Food({
    required this.data,
    required this.success,
    required this.message,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      success: json["success"],
      message: json["message"],
    );
  }
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
                return Text(snapshot.data!.message);
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

class Datum {
  Datum({
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

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        productId: json["productId"],
        categoryId: json["categoryId"],
        productName: json["productName"],
        unitsInStock: json["unitsInStock"],
        unitPrice: json["unitPrice"].toDouble(),
      );
}

Food foodFromJson(String str) => Food.fromJson(json.decode(str));
