import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:asra_app_new/api.dart';
import 'package:asra_app_new/pages/home.dart';
import 'package:intl/intl.dart';

class FinancePage extends StatefulWidget {
  final LoginData login;
  final String authToken;
  const FinancePage(this.login, this.authToken, {Key? key}) : super(key: key);
  @override
  State<FinancePage> createState() => FinancePageState();
}

class _Payment {
  final String quotationId;
  final DateTime datePaid;
  final double amountPaid;
  final String paymentCode;
  _Payment(this.quotationId, this.datePaid, this.amountPaid, this.paymentCode);
}

class FinancePageState extends State<FinancePage> {
  static final DateFormat df = DateFormat.yMMMd();
  final Map<String, List<_Payment>> _payments = {};
  final Map<String, double> _totalPayments = {};
  double _totalPaid = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _getPayments();
  }

  void _getPayments() async {
    final response = await Api.json.get('/driver/payments', {
      'Authorization': 'Bearer ${widget.authToken}',
    });
    if (!response['success']) {
      Fluttertoast.showToast(msg: '[Error]: ${response['message']}');
    } else {
      setState(() {
        for (final payment in response['payments']) {
          final quotationId = payment['quotation_id'];
          final amountPaid = payment['amount_paid'].toDouble();
          if (!_payments.containsKey(quotationId)) {
            _payments[quotationId] = [];
          }
          _payments[quotationId]!.add(
            _Payment(
              quotationId,
              DateTime.parse(payment['date_paid']),
              amountPaid,
              payment['payment_code'],
            ),
          );
          _totalPayments[quotationId] = double.parse(payment['total_payment']);
          _totalPaid += amountPaid;
        }
        _loading = false;
      });
    }
  }

  Iterable<TableRow> _generate() sync* {
    int idx = 1;
    for (final key in _payments.keys) {
      yield TableRow(
        children: [
          Text('${idx++}'),
          Text(
            key,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          Text(
            'Aug 12, 2030',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          Text(
            _totalPayments[key]!.toStringAsFixed(2),
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          const Text(''),
        ]
            .map((e) => Padding(padding: const EdgeInsets.all(2), child: e))
            .toList(),
      );
      for (final payment in _payments[key]!) {
        yield TableRow(
          children: [
            Text(
              '${idx++}',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Text(
              payment.paymentCode,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Text(
              df.format(payment.datePaid),
              style: Theme.of(context).textTheme.bodyText2,
            ),
            const Text(''),
            Text(
              payment.amountPaid.toStringAsFixed(2),
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ]
              .map((e) => Padding(padding: const EdgeInsets.all(2), child: e))
              .toList(),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_totalPayments.isEmpty) {
      return Center(
        child: Text(
          'No item!',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      );
    }
    final totalPayment =
        _totalPayments.values.reduce((value, element) => value + element);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: [
        Card(
          elevation: 4,
          shadowColor: Colors.grey,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Text(
                  'Payment Statement',
                  style: Theme.of(context).textTheme.headline4,
                ),
                const SizedBox(height: 10),
                Table(
                  border: TableBorder.all(color: Colors.grey),
                  columnWidths: const {
                    0: FixedColumnWidth(30),
                    2: FixedColumnWidth(70),
                    3: FixedColumnWidth(50),
                    4: FixedColumnWidth(50),
                  },
                  children: [
                    TableRow(
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                      ),
                      children: [
                        Text(
                          '#',
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyText2!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Text(
                          'Item ID',
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyText2!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Text(
                          'Date',
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyText2!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Text(
                          'Total',
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyText2!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Text(
                          'Paid',
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyText2!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                    ..._generate(),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Card(
          elevation: 4,
          shadowColor: Colors.grey,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total: RM${totalPayment.toStringAsFixed(2)}'),
                Text('Total paid: RM${_totalPaid.toStringAsFixed(2)}'),
                Text(
                  'Balance: RM${(totalPayment - _totalPaid).toStringAsFixed(2)}',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
