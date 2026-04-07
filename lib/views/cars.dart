import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Cars extends StatefulWidget {
  const Cars({super.key});

  @override
  State<Cars> createState() => _CarsState();
}

class _CarsState extends State<Cars> {
  List<dynamic> myCars = [];

  @override
  void initState() {
    super.initState();
    fetchCars();
  }

  fetchCars() async {
    var response = await http.get(
      Uri.parse("http://10.0.2.2/carsales/readcars.php"),
    );

    if (response.statusCode == 200) {
      var serverData = jsonDecode(response.body);

      setState(() {
        myCars = serverData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cars")),
      body: ListView.builder(
        itemCount: myCars.length,
        itemBuilder: (context, index) {
          var car = myCars[index];

          return Row(
            children: [
              Image.network(
                car["image"] ?? "https://via.placeholder.com/100",
                width: 100,
                height: 100,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(car["name"] ?? "No Name"),
                  Text(car["price"] ?? "No Price"),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}