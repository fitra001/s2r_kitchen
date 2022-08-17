import 'dart:io';

import 'package:s2r_kitchen/helpers/currency_format.dart';
import 'package:s2r_kitchen/page/Admin/transaksi/detail_transaksi/detail_transaksi.dart';
import 'package:s2r_kitchen/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

class PesananSelesai extends StatefulWidget {
  const PesananSelesai({Key? key}) : super(key: key);

  @override
  State<PesananSelesai> createState() => _PesananSelesaiState();
}

class _PesananSelesaiState extends State<PesananSelesai> {
  bool isLoading = true;
  List<dynamic> data = <dynamic>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _fetchListPesanan();
  }

  _fetchListPesanan() async {
    final order = await ApiService().getAllPesananSelesai();
    var pesananOrder = order['data'];

    if (mounted) {
      setState(() {
        data = pesananOrder;
        isLoading = false;
      });
    }
  }

  _printPDF() async {
    final pdf = pw.Document();
    int total = 0;
    List<pw.TableRow> list() {
      List<pw.TableRow> tableRow = [];
      tableRow.add(pw.TableRow(children: [
        pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text('Tanggal Transaksi',
                  style: const pw.TextStyle(fontSize: 6)),
              pw.Divider(thickness: 1)
            ]),
        pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text('Nama', style: const pw.TextStyle(fontSize: 6)),
              pw.Divider(thickness: 1)
            ]),
        pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text('Harga', style: const pw.TextStyle(fontSize: 6)),
              pw.Divider(thickness: 1)
            ])
      ]));

      for (var item in data) {
        total = total + int.parse(item['total']);
        tableRow.add(pw.TableRow(children: [
          pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(item['tgl_transaksi'],
                    style: const pw.TextStyle(fontSize: 6)),
                pw.Divider(thickness: 1)
              ]),
          pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(item['nama'], style: const pw.TextStyle(fontSize: 6)),
                pw.Divider(thickness: 1)
              ]),
          pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(item['total'], style: const pw.TextStyle(fontSize: 6)),
                pw.Divider(thickness: 1)
              ])
        ]));
      }

      tableRow.add(pw.TableRow(children: [
        pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text('Total', style: const pw.TextStyle(fontSize: 6)),
              pw.Divider(thickness: 1)
            ]),
        pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text('', style: const pw.TextStyle(fontSize: 6)),
              pw.Divider(thickness: 1)
            ]),
        pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text(total.toString(), style: const pw.TextStyle(fontSize: 6)),
              pw.Divider(thickness: 1)
            ])
      ]));
      return tableRow;
    }

    ;

    pdf.addPage(pw.MultiPage(
        pageFormat:
            PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        header: (context) {
          return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              child: pw.Text(DateTime.now().toString()));
        },
        footer: (context) {
          return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: pw.Text(
                'Page ${context.pageNumber} of ${context.pagesCount}',
              ));
        },
        build: (context) => [
              pw.Center(
                  child:
                      pw.Header(level: 1, text: 'Laporan Transaksi Penjualan')),
              // pw.Paragraph(
              //       text: 'Laporan '+
              // )
              pw.Padding(padding: const pw.EdgeInsets.all(10)),
              pw.Table(children: list())
            ]
        // build:
        ));

    final file = await File('/storage/emulated/0/Documents/laporan_transaksi_' +
            DateTime.now().toString().split(' ')[0] +
            '.pdf')
        .create(recursive: true);
    final r = await file.writeAsBytes(await pdf.save());
    if (file.path.isNotEmpty) {
      Fluttertoast.showToast(msg: 'PDF Berhasil dibuat di folder Documents');
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () async {
                          DateTimeRange? result = await showDateRangePicker(
                            context: context,
                            firstDate:
                                DateTime(2022, 1, 1), // the earliest allowable
                            lastDate:
                                DateTime(2040, 12, 31), // the latest allowable
                            currentDate: DateTime.now(),
                            saveText: 'Done',
                          );
                          if (result != null) {
                            final res = await ApiService()
                                .filterSelesaiTransaksi(
                                    tglAwal:
                                        result.start.toString().split(' ')[0],
                                    tglAkhir:
                                        result.end.toString().split(' ')[0]);
                            setState(() {
                              data = res['data'];
                            });
                          }
                        },
                        child: const Icon(
                          Icons.filter_list_alt,
                          size: 40,
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          final cekpermision = await Permission.storage.isGranted;
                          if (cekpermision) {
                            _printPDF();
                          }else{
                            await Permission.storage.request();
                          }
                        },
                        child: const Icon(Icons.print, size: 40),
                      ),
                    ],
                  ),
                ),
                data.isEmpty
                    ? const Center(
                        child: Text('Data Kosong'),
                      )
                    : Expanded(child: listPesanan()),
              ],
            ));
  }

  Widget listPesanan() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailTransaksi(
                          idTransaksi: data[index]['id'],
                        ))),
            child: Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            top: BorderSide(color: Colors.grey, width: 0.5))),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      '${data[index]['nama']} (${data[index]['no_telp']})',
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            top: BorderSide(color: Colors.grey, width: 0.5))),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            data[index]['status'] +
                                ' (' +
                                data[index]['petugas']['nama'] +
                                ')',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        Text(
                          data[index]['tgl_transaksi'],
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            top: BorderSide(color: Colors.grey, width: 0.5))),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Text(
                          'Total Pesanan',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                            CurrencyFormat.convertToIdr(
                                int.parse(data[index]['total']), 0),
                            style: const TextStyle(
                                fontFamily: 'Satisfy',
                                fontSize: 24,
                                color: Color(0x99FFC107))),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
