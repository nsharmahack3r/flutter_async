import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:front_end/model/product.dart';
import 'package:http/http.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {

  bool isLoading = true;
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    loadData().then((value){
        setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: isLoading ? const Center(child: CircularProgressIndicator(),) : 
      ListView.builder(
        itemCount: products.length,
        itemBuilder :(context, index){
          return ListTile(
            leading: SizedBox(
              width: 100,
              child: Image.network(
                products[index].images[0],
              ),
            ),
            title: Text(products[index].title),
          );
        },
      ),
    );
  }

  Future<void> loadData() async {
    final url = Uri.parse('https://dummyjson.com/products');
    final result = await get(url);
    log(result.body);
    final data = jsonDecode(result.body);
    for(dynamic productJson in data['products']){
      products.add(Product.fromJson(productJson));
    }
  }
}