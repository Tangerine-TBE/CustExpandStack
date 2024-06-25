import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:untitled1/cus_extend_container.dart';
import 'package:untitled1/date_utils.dart' as date;
import 'package:untitled1/product_view_model.dart';

void main() {
  initializeDateFormatting();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  CusExtendStackController stackController = CusExtendStackController();
  var controllerList = <CusExtendController>[];
  late Timer timerForDate;
  late Timer timerForData;
  late Timer timerForExpanded;

  @override
  void initState() {
    setState(() {
      _loadDate();
      _loadDataWithDate();
      if (controllerList.isNotEmpty) {
        controllerList.first.isExpanded = true;
      }
    });
    super.initState();
  }

  _loadDate() {
      List.generate(7, (index) {
        var date = DateTime.now().add(Duration(days: 2 + index));
        controllerList.add(
          CusExtendController(date: date, index: index),
        );
      });
  }

  _loadDataWithDate() {

        for (var i in controllerList) {
          List<Map<String, dynamic>> jsonList = [];
          List.generate(
            2000,
            (index) {
              Map<String, dynamic> jsonProductModel = {
                'id': index,
                'productCode': index.toString(),
                'productName': 'ProductName',
                'supplierName': 'supplierName',
                'supplierId': index,
                'supplierShortName': '',
                'qualityInfo': 'Per/Per',
                'count': 999,
                'price': 20,
                'selectedCount': 0,
                'dateTime': date.DateUtils.convertDateFormatString(
                    i.date, date.DateUtils.formattedDateSimple)
              };
              jsonList.add(jsonProductModel);
            },
          );
          for (var j in jsonList) {
            i.allProducts.add(ProductViewModel.fromJson(j));
          }
        }
        stackController.canExpand = true;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: CusExtendContainer(
          controller: stackController,
          controllers: controllerList,
          onItemTap: (int index) {
            setState(() {
              bool currentItemStatus = controllerList[index].isExpanded;
              for (var i in controllerList) {
                i.isExpanded = false;
              }
              controllerList[index].isExpanded = !currentItemStatus;
            });
          },
          onIncrease: (int index, int itemIndex) {},
          onDecrease: (int index, int itemIndex) {},
        ),
      ),
    );
  }
}
