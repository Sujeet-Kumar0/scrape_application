import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:scrape_application/components/headers.dart';
import 'package:scrape_application/components/side_bar.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  IconData editIcon = Icons.edit;
  bool isEditing = false;
  TextEditingController scrapController = TextEditingController();
  int scrap = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    scrapController.text = scrap.toString();
  }

  @override
  void dispose() {
    _controller.dispose();
    scrapController.dispose();
    super.dispose();
  }

  void updateScrap() {
    setState(() {
      scrap = int.tryParse(scrapController.text) ?? 0;
      isEditing = false;
      editIcon = Icons.edit;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (kIsWeb)
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(),
              ),
            // Dashboard
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      //Heading
                      Header(),
                      SizedBox(height: 24),
                      // Scrap Sold update
                      Stack(
                        children: [
                          Container(
                            height: 250,
                            decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 12,
                                  color: Color(0x33000000),
                                  offset: Offset(0, 5),
                                )
                              ],
                              gradient: LinearGradient(
                                colors: [
                                  Theme.of(context).colorScheme.primary,
                                  Theme.of(context).colorScheme.secondary
                                ],
                                stops: const [0, 1],
                                begin: const AlignmentDirectional(1, 1),
                                end: const AlignmentDirectional(1, -1.31),
                              ),
                              borderRadius: BorderRadius.circular(6),
                              // shape: BoxShape.rectangle,
                            ),
                            alignment: const AlignmentDirectional(0, 0),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: '${scrap} Has been sold',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(color: Colors.white))
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isEditing = !isEditing;
                                  editIcon =
                                      isEditing ? Icons.check : Icons.edit;
                                  if (!isEditing) {
                                    updateScrap();
                                  }
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                child: Icon(
                                  editIcon,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          if (isEditing)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              left: 0,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                color: Colors.black.withOpacity(0.5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: scrapController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          hintText: 'Enter new value',
                                          hintStyle: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        style: TextStyle(color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: updateScrap,
                                      icon: Icon(
                                        Icons.done,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text("New Orders"),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "some Orders Numbers",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text("New Users"),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "some Numbers Users",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
