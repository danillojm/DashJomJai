import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show FilteringTextInputFormatter, TextInputFormatter, rootBundle;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:responsive_admin_dashboard/constants/constants.dart';
import 'package:responsive_admin_dashboard/screens/components/drawer_menu.dart';
import 'package:responsive_admin_dashboard/screens/productbudget/currency_pt_br_input_formatter.dart';

class Orcamento {
  String? produto;
  int? quantidade;
  String? precoUnitario;
  double? valorTotal;

  calcularValorTotal() {
    double precoUnitarioReplace = parsePreco(precoUnitario!);

    valorTotal = precoUnitarioReplace * quantidade!;

    return valorTotal;
  }

  double parsePreco(String texto) {
    return double.tryParse(texto
            .replaceAll("R\$", "")
            .replaceAll(".", "")
            .replaceAll(",", ".")
            .trim()) ??
        0.0;
  }

  currencyFormatter(double value) {
    final formatter = new NumberFormat("#,##0.00", "pt_BR");
    String formatterText = "R\$ " + formatter.format(value);

    return formatterText;
  }
}

class ProductBugetContent extends StatefulWidget {
  const ProductBugetContent({Key? key}) : super(key: key);

  @override
  State<ProductBugetContent> createState() => _ProductBugetContentState();
}

class _ProductBugetContentState extends State<ProductBugetContent> {
  final TextEditingController _controladorProduto = TextEditingController();
  final TextEditingController _controladorQuantidade = TextEditingController();
  final TextEditingController _controladorValorUnitario =
      TextEditingController();
  final TextEditingController _controladorObs = TextEditingController();
  List<Orcamento> orcamentoList = [];

  _addOrcamento() {
    Orcamento orcamento = new Orcamento();

    orcamento.produto = _controladorProduto.text;
    orcamento.quantidade = int.parse(_controladorQuantidade.text);
    orcamento.precoUnitario = _controladorValorUnitario.text;

    orcamento.calcularValorTotal();
    orcamentoList.add(orcamento);

    _controladorProduto.text = "";
    _controladorQuantidade.text = "";
    _controladorValorUnitario.text = "";
  }

  _overallTotalValue() {
    double overallTotalValue = 0.0;

    for (var element in orcamentoList) {
      overallTotalValue = overallTotalValue += element.valorTotal!;
    }

    return overallTotalValue;
  }

  _currencyFormatter(double value) {
    final formatter = new NumberFormat("#,##0.00", "pt_BR");
    String formatterText = "R\$ " + formatter.format(value);

    return formatterText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color.fromRGBO(82, 170, 94, 1.0),
        onPressed: () {
          gerarRelatorioPDF();
        },
        label: const Text(
          'Gerar arquivo do orçamento',
          style: TextStyle(color: Colors.white),
        ),
        icon: const Icon(Icons.add, color: Colors.white, size: 25),
      ),
      drawer: DrawerMenu(),
      appBar: AppBar(),
      body: SafeArea(
          child: SingleChildScrollView(
        padding: EdgeInsets.all(appPadding),
        child: Column(children: [
          Image.asset(
            'assets/images/logotiago.png',
            width: 300,
          ),
          SizedBox(
            height: appPadding,
          ),
          Text(
            "Orçamento".toUpperCase(),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(
            height: appPadding,
          ),
          TextField(
            controller: _controladorProduto,
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: "Produto"),
          ),
          SizedBox(
            height: appPadding,
          ),
          TextField(
            keyboardType: TextInputType.number,
            controller: _controladorQuantidade,
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: "Quantidade"),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              FilteringTextInputFormatter.digitsOnly
            ],
          ),
          SizedBox(
            height: appPadding,
          ),
          TextField(
            controller: _controladorValorUnitario,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: "Preço Unitário"),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CurrencyPtBrInputFormatter()
            ],
          ),
          SizedBox(
            height: appPadding,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FilledButton.icon(
                icon: Icon(Icons.add),
                label: Text("Adicionar na tabela"),
                onPressed: () {
                  setState(() {
                    _addOrcamento();
                  });
                },
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.green)),
              ),
            ],
          ),
          SizedBox(
            height: appPadding,
          ),

          //Tabela
          Table(
            border: TableBorder.all(color: Colors.black),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                  decoration: BoxDecoration(color: Colors.black),
                  children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Produto",
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      verticalAlignment: TableCellVerticalAlignment.middle,
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Quantidade",
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      verticalAlignment: TableCellVerticalAlignment.middle,
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Preço Unitário",
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      verticalAlignment: TableCellVerticalAlignment.middle,
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Total",
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      verticalAlignment: TableCellVerticalAlignment.middle,
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "",
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      verticalAlignment: TableCellVerticalAlignment.middle,
                    ),
                  ]),
              for (var item in orcamentoList)
                TableRow(
                    decoration: BoxDecoration(color: Colors.white),
                    children: [
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(item.produto.toString()),
                        ),
                        verticalAlignment: TableCellVerticalAlignment.middle,
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(item.quantidade.toString()),
                        ),
                        verticalAlignment: TableCellVerticalAlignment.middle,
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(item.precoUnitario.toString()),
                        ),
                        verticalAlignment: TableCellVerticalAlignment.middle,
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                              _currencyFormatter(item.calcularValorTotal())
                                  .toString()),
                        ),
                        verticalAlignment: TableCellVerticalAlignment.middle,
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                orcamentoList.remove(item);
                              });
                            },
                            child: Icon(
                              Icons.delete,
                            ),
                          ),
                        ),
                        verticalAlignment: TableCellVerticalAlignment.middle,
                      ),
                    ]),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Total Geral: ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                _currencyFormatter(_overallTotalValue()).toString(),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            maxLines: 5,
            controller: _controladorObs,
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: "Observação"),
          ),
          SizedBox(
            height: 100,
          ),
        ]),
      )),
    );
  }

  Future<void> gerarRelatorioPDF() async {
    final pdf = pw.Document();

    // Carrega imagem do logotipo
    final imageLogo = pw.MemoryImage(
      (await rootBundle.load('assets/images/logotiago.png'))
          .buffer
          .asUint8List(),
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Logotipo
              pw.Center(child: pw.Image(imageLogo, width: 200)),

              pw.SizedBox(height: 20),

              // Título
              pw.Center(
                child: pw.Text(
                  'Orçamento',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold),
                ),
              ),

              pw.SizedBox(height: 30),

              // Tabela
              pw.TableHelper.fromTextArray(
                headers: ['Produto', 'Quantidade', 'Preço Unitário', 'Total'],
                data: orcamentoList.map((toElement) {
                  return [
                    toElement.produto,
                    toElement.quantidade,
                    toElement.precoUnitario,
                    toElement.currencyFormatter(toElement.valorTotal!)
                  ];
                }).toList(),
                headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                ),
                cellAlignment: pw.Alignment.centerLeft,
                border: pw.TableBorder.all(),
              ),

              pw.SizedBox(height: 20),

              // Rodapé
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
                pw.Text(
                  'Total Geral: ',
                  style: pw.TextStyle(
                      fontSize: 14, fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(
                  _currencyFormatter(_overallTotalValue()).toString(),
                  style: pw.TextStyle(
                      fontSize: 14, fontWeight: pw.FontWeight.bold),
                ),
              ]),
              pw.SizedBox(height: 30),

              pw.TextField(
                  name: "Observação", height: 20, value:  "Observação: "+ _controladorObs.text,),
              pw.SizedBox(height: 30),

              pw.Divider(),

              pw.Align(
                  alignment: pw.Alignment.centerLeft,
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text("@tiagoiphonesoficial"),
                            pw.Text("(81) 98822-8066"),
                          ]),
                      pw.SizedBox(width: 50),
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                                "Galeria Millenio - Av. Murilo Silva, 114 - Loja 02 Terreo - Centro,\nCarpina - PE, 55813-190."),
                          ]),
                    ],
                  )),
            ],
          );
        },
      ),
    );

    // Visualiza e exporta
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
