import 'package:flutter/material.dart';

class GoodsCarousel extends StatefulWidget {
  const GoodsCarousel({Key? key, required List<String> images}) : super(key: key);

  @override
  _GoodsCarouselState createState() => _GoodsCarouselState();
}

class _GoodsCarouselState extends State<GoodsCarousel> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  // ignore: unused_field
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        controller: _pageController,
        itemCount: 10,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: _pageController,
            builder: (context, child) {
              double value = 1.0;
              if (_pageController.position.haveDimensions) {
                value = _pageController.page! - index;
                value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
              }

              return Center(
                child: SizedBox(
                  height: Curves.easeOut.transform(value) * 200.0,
                  width: Curves.easeOut.transform(value) * 300.0,
                  child: child,
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0.0, 2.0),
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Product Name',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  const Text(
                    'Product Description',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  const Text(
                    '\$10.00',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  ElevatedButton(
                    child: const Text('Add to cart'),
                    onPressed: () {
                      // Handle add to cart button press
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
