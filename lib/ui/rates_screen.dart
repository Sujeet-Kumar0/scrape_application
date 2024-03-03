import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrape_application/components/item_card.dart';
import 'package:scrape_application/viewmodels/rates_screen_model.dart';

class RatesScreen extends StatefulWidget {
  RatesScreen({Key? key});

  @override
  State<RatesScreen> createState() => _RatesScreenState();
}

class _RatesScreenState extends State<RatesScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  late FocusNode _searchFocusNode;
  late TextInputAction _searchTextInputAction;
  late RatesScreenViewModel viewModel;

  @override
  void initState() {
    super.initState();
    // Initialize FocusNode and TextInputAction
    _searchFocusNode = FocusNode();
    _searchTextInputAction = TextInputAction.done;

    viewModel = Provider.of<RatesScreenViewModel>(context, listen: false);
    // viewModel.filteredItems = viewModel.readDataFromDB();

    // Listen for changes in the search field text
    viewModel.searchController.addListener(() {
      // Call performSearch function with the updated text
      viewModel.performSearch(viewModel.searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    viewModel = Provider.of<RatesScreenViewModel>(context);
    return GestureDetector(
      onTap: () {
        // Dismiss the keyboard when tapping outside the text field
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        key: scaffoldKey,
        body: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: _formKey,
                  child: TextFormField(
                    // Assign the FocusNode to the TextFormField
                    focusNode: _searchFocusNode,
                    // Remove autofocus
                    autofocus: false,
                    // Set the TextInputAction
                    textInputAction: _searchTextInputAction,
                    controller: viewModel.searchController,
                    decoration: InputDecoration(
                      hintText: 'Search .....',
                      enabledBorder: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Visibility(
                  visible: viewModel.filteredItems.isNotEmpty,
                  replacement: Center(
                    child: Text(
                      viewModel.empty,
                      style: TextStyle(fontSize: 20), // Change as needed
                    ),
                  ),
                  child: Expanded(
                    child: GridView.builder(
                      padding: EdgeInsets.zero,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.70,
                      ),
                      scrollDirection: Axis.vertical,
                      itemCount: viewModel.filteredItems.length,
                      itemBuilder: (context, gridViewIndex) {
                        return RateInfoCard(
                          title:
                              viewModel.filteredItems[gridViewIndex].itemName,
                          subtitle:
                              viewModel.filteredItems[gridViewIndex].price,
                          imageURL:
                              viewModel.filteredItems[gridViewIndex].imageURL,
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
