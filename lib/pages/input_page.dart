import 'package:flutter/material.dart';
import 'package:money_management/database/dbHelper.dart';
import 'package:money_management/models/breakdown.dart';
import 'package:money_management/models/breakdowns.dart';
import 'package:provider/provider.dart';

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  String type = 'spending';
  final costController = TextEditingController();
  final categoryController = TextEditingController();
  final focusNode = FocusNode();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Breakdowns breakdowns = Provider.of<Breakdowns>(context);
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Color.fromRGBO(48, 48, 48, 1),
          elevation: 0,
        ),
        body: buildBody(breakdowns),
      ),
    );
  }

  buildBody(Breakdowns breakdowns) {
    int width = MediaQuery.of(context).size.width.toInt();
    int height = MediaQuery.of(context).size.height.toInt();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          radio(),
          inputCost(),
          inputCategory(breakdowns),
          addButton(breakdowns)
        ],
      ),
    );
  }

  radio() {
    return Row(
      children: <Widget>[
        Text('수입'),
        Radio(
          value: 'income',
          groupValue: type,
          onChanged: (String value) {
            setState(() {
              type = value;
            });
          },
        ),
        Text('지출'),
        Radio(
          value: 'spending',
          groupValue: type,
          onChanged: (String value) {
            setState(() {
              type = value;
            });
          },
        )
      ],
    );
  }

  inputCost() {
    return TextField(
      controller: costController,
      autofocus: true,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(hintText: '금액'),
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(focusNode);
      },
    );
  }

  inputCategory(Breakdowns breakdowns) {
    return TextField(
      controller: categoryController,
      maxLength: 10,
      focusNode: focusNode,
      decoration: InputDecoration(
        hintText: '내용',
      ),
      onEditingComplete: () {
        onSubmit(breakdowns);
      },
    );
  }

  addButton(Breakdowns breakdowns) {
    return RaisedButton(
      child: Text("추가"),
      onPressed: () {
        onSubmit(breakdowns);
      },
    );
  }

  onSubmit(Breakdowns breakdowns) {
    if (costController.text == '') {
      final snackBar = SnackBar(
        content: Text('금액을 입력하세요'),
        action: SnackBarAction(
          label: '닫기',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );
      scaffoldKey.currentState.showSnackBar(snackBar);
      return;
    }

    Breakdown newBreakdown = new Breakdown(
        type, int.parse(costController.text), categoryController.text);
    DBHelper.db.insertBreakdownInDB(newBreakdown);
    breakdowns.getFromDB();
    Navigator.pop(context);
  }
}
