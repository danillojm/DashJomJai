 
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';


class CurrencyPtBrInputFormatter extends TextInputFormatter {

  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if(newValue.selection.baseOffset == 0){
      return newValue;
    }

    double value = double.parse(newValue.text);
    final formatter = new NumberFormat("#,##0.00", "pt_BR");
    String newText = "R\$ " + formatter.format(value/100);

    return newValue.copyWith(
      text: newText,
      selection: new TextSelection.collapsed(offset: newText.length));
  }
} 