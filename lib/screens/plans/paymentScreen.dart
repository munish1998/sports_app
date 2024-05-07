import 'package:flutter/material.dart';
import 'package:touchmaster/utils/color.dart';
import 'package:touchmaster/utils/commonMethod.dart';
import 'package:touchmaster/utils/size_extension.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.menu,
              color: Colors.black,
            ),
          )
        ],
        title: const Text(
          "PAYMENT METHOD",
          style: TextStyle(
            letterSpacing: 2,
            fontFamily: "BankGothic",
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            navPop(context: context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/card.png'),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "CARD DETAILS",
                  style: TextStyle(
                    letterSpacing: 2,
                    fontFamily: "BankGothic",
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Card(
                  elevation: 1,
                  child: Container(
                    width: 320,
                    height: 304,
                    color: const Color.fromRGBO(196, 196, 196, 0.2),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name on card',
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'Enter card name',
                            ),
                          ),
                          Text(
                            'Card number',
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                          TextField(
                            controller: _cardNumberController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Enter card number',
                            ),
                            onChanged: (value) {
                              setState(() {
                                // Limit card number to 12 digits
                                if (value.length > 16) {
                                  value = value.substring(0, 12);
                                  _cardNumberController.value =
                                      TextEditingValue(
                                    text: value,
                                    selection: TextSelection.collapsed(
                                        offset: value.length),
                                  );
                                }
                              });
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Expiry date',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10),
                                  ),
                                  Container(
                                    width: 120,
                                    child: TextField(
                                      controller: _expiryDateController,
                                      keyboardType: TextInputType.datetime,
                                      decoration: InputDecoration(
                                        hintText: 'MM/YY',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'CVV',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10),
                                  ),
                                  Container(
                                    width: 80,
                                    child: TextField(
                                      controller: _cvvController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: 'CVV',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
