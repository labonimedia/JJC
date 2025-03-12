import 'dart:async';

import 'package:flutter/material.dart';
class HotelScreen extends StatefulWidget {
  const HotelScreen({super.key});

  @override
  State<HotelScreen> createState() => _WelcomeScreenState();
}
class _WelcomeScreenState extends State<HotelScreen> {
  late PageController _bannerController;
  int _currentBanner = 0;
  Timer? _timer;

  List<String> banners = [
    "https://yourimageurl.com/banner1.jpg",
    "https://yourimageurl.com/banner2.jpg"
  ];

  List<Map<String, String>> categories = [
    {"icon": "assets/pizza.png", "name": "Pizza"},
    {"icon": "assets/burger.png", "name": "Burger"},
    {"icon": "assets/beer.png", "name": "Beer"},
    {"icon": "assets/coffee.png", "name": "Coffee"},
    {"icon": "assets/fish.png", "name": "Fish"},
  ];

  List<Map<String, String>> vendors = [
    {
      "name": "Burger King",
      "cuisine": "American, Fast Food",
      "image": "https://yourimageurl.com/burger.jpg",
      "rating": "5",
      "distance": "6.06 Kms",
      "price": "\$89 for two",
      "time": "20 mins"
    },
  ];

  @override
  void initState() {
    super.initState();
    _bannerController = PageController(viewportFraction: 0.9);

    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_currentBanner < banners.length - 1) {
        _currentBanner++;
      } else {
        _currentBanner = 0;
      }
      _bannerController.animateToPage(
        _currentBanner,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _bannerController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("DELIVERY TO", style: TextStyle(fontSize: 12, color: Colors.grey)),
            Text("6WHR+VR7, Kathodara, Gujarat", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))
          ],
        ),
        actions: [
          Icon(Icons.flash_on, color: Colors.green),
          SizedBox(width: 10),
          Icon(Icons.account_circle, color: Colors.green),
          SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSearchBar(),
            _buildBannerSlider(),
            _buildCategorySection(),
            _buildNearbyVendors(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          hintText: "Search for item",
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildBannerSlider() {
    return SizedBox(
      height: 190,
      child: PageView.builder(
        controller: _bannerController,
        itemCount: banners.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image: NetworkImage(banners[index]),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text("Category", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Image.asset(categories[index]["icon"]!, width: 50),
                  ),
                  SizedBox(height: 5),
                  Text(categories[index]["name"]!),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNearbyVendors() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text("Nearby top vendors", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: vendors.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                    child: Image.network(vendors[index]["image"]!, height: 150, width: double.infinity, fit: BoxFit.cover),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(vendors[index]["name"]!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(vendors[index]["cuisine"]!, style: TextStyle(color: Colors.grey)),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.orange, size: 16),
                            Text(vendors[index]["rating"]!),
                            SizedBox(width: 10),
                            Icon(Icons.timer, color: Colors.grey, size: 16),
                            Text(vendors[index]["time"]!),
                            SizedBox(width: 10),
                            Text(vendors[index]["price"]!, style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}