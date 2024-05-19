import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:medtag/screens/drug_detail_page.dart';

import 'package:csv/csv.dart';

class DrugSearchPage extends StatefulWidget {
  const DrugSearchPage({super.key});

  @override
  _DrugSearchPageState createState() => _DrugSearchPageState();
}

class _DrugSearchPageState extends State<DrugSearchPage> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _drugList = [];
  List<Map<String, dynamic>> _filteredDrugList = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCSV();
  }

  Future<void> _loadCSV() async {
    try {
      final data = await rootBundle.loadString('assets/Medicine_Details.csv');
      List<List<dynamic>> csvTable = const CsvToListConverter().convert(data);

      // CSV başlıklarını alalım
      List<String> headers = List<String>.from(csvTable.first);

      // CSV içeriğini haritaya dönüştürelim
      List<Map<String, dynamic>> drugs = csvTable
          .sublist(1)
          .map((row) => Map<String, dynamic>.fromIterables(headers, row))
          .toList();

      setState(() {
        _drugList = drugs;
        _filteredDrugList = drugs;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  void _filterDrugs(String query) {
    List<Map<String, dynamic>> filteredDrugs = _drugList.where((drug) {
      final brandName = drug['Medicine Name']?.toLowerCase() ?? '';
      return brandName.contains(query.toLowerCase());
    }).toList();

    setState(() {
      _filteredDrugList = filteredDrugs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('İlaç Bilgi Uygulaması'),
        backgroundColor: const Color(0xFFAFF2F2),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: TextField(
                controller: _controller,
                onChanged: _filterDrugs,
                decoration: InputDecoration(
                  labelText: 'İlaç adını girin',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear();
                      FocusScope.of(context).unfocus();
                      _filterDrugs('');
                    },
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_error != null)
              Text(
                'Hata: $_error',
                style: const TextStyle(color: Colors.red),
              ),
            Expanded(
              child: _filteredDrugList.isNotEmpty
                  ? ListView.builder(
                      itemCount: _filteredDrugList.length,
                      itemBuilder: (context, index) {
                        final drug = _filteredDrugList[index];
                        final drugName = drug['Medicine Name'] ?? 'Bilinmiyor';
                        return ListTile(
                          title: Text(drugName),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DrugDetailPage(drug: drug),
                              ),
                            );
                          },
                        );
                      },
                    )
                  : const Center(child: Text('İlaç bilgisi bulunamadı.')),
            ),
          ],
        ),
      ),
    );
  }
}
