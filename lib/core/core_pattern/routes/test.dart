import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  double _additionalHeight = 1;
  double _horizontalIndex = 0;
  bool showModal = false;
  String modalText = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey,
      body: SizedBox(
        height: height,
        width: width,
        child: GestureDetector(
          onTap: () {
            showModal = false;
            setState(() {});
          },
          onPanUpdate: (details) {
            if (details.localPosition.dx > 0) {
              if (_additionalHeight > 15) {
                if (details.globalPosition.dx < 125) {
                  _horizontalIndex = 1;
                } else if (details.globalPosition.dx < 250) {
                  _horizontalIndex = 2;
                } else {
                  _horizontalIndex = 3;
                }
              }
              if (kDebugMode) {
                print("right");
              }
            } else {
              if (kDebugMode) {
                print("left");
              }
            }
            setState(() {});

            if (details.delta.dy > 0) {
              if (_additionalHeight < 20) {
                _additionalHeight++;
              }
              setState(() {});
            } else {
              if (_additionalHeight > 1 && _horizontalIndex == 0) {
                _additionalHeight--;
                setState(() {});
              }
            }
          },
          onPanEnd: (d) {
            if (_horizontalIndex == 1 || _horizontalIndex == 3) {
              modalText = _horizontalIndex == 1 ? "Search" : "Settings";
              showModal = true;
            } else {
              showModal = false;
            }
            _additionalHeight = 1;
            _horizontalIndex = 0;
            setState(() {});
          },
          behavior: HitTestBehavior.translucent,
          child: Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                color: Colors.white,
                height: 130 + _additionalHeight,
                child: SafeArea(
                  bottom: false,
                  child: _additionalHeight > 1
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            buildColumn(
                              icon: Icons.search_sharp,
                              text: "Search",
                              scale: _additionalHeight / 70,
                              selected: _horizontalIndex == 1,
                            ),
                            buildColumn(
                              icon: Icons.refresh,
                              text: "Refresh",
                              scale: _additionalHeight / 70,
                              selected: _horizontalIndex == 2,
                            ),
                            buildColumn(
                              icon: Icons.settings,
                              text: "Settings",
                              scale: _additionalHeight / 70,
                              selected: _horizontalIndex == 3,
                            ),
                          ],
                        )
                      : TextFormField(
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 2),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                            hintText: "File Name",
                          ),
                        ),
                ),
              ),
              if (showModal)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: DraggableScrollableSheet(
                    maxChildSize: .9,
                    initialChildSize: .13,
                    minChildSize: .12,
                    builder: (BuildContext context,
                        ScrollController scrollController) {
                      return Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                        ),
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            height: height * .6,
                            child: Text(
                              modalText,
                              textAlign: TextAlign.center,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildColumn(
      {required IconData icon,
      required String text,
      required double scale,
      bool? selected}) {
    return AnimatedScale(
      scale: .7 + scale,
      duration: const Duration(milliseconds: 100),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 50),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: selected == true
                    ? Colors.grey.withOpacity(.5)
                    : Colors.transparent,
                shape: BoxShape.circle),
            child: Icon(
              icon,
              size: 25,
            ),
          ),
          const SizedBox(
            height: 3,
          ),
          if (selected == true)
            Text(
              text,
              style: const TextStyle(fontSize: 12),
            ),
        ],
      ),
    );
  }
}
