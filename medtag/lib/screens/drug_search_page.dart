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
        title: const Text(
          'MedTag',
          style: TextStyle(
            fontFamily: "Brand-Regular",
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF67b8de),
      ),
      body: Stack(
        children: [
          Container(
            color:
                const Color(0xFFE8F8FF), // Arka plan rengini burada belirleyin
          ),
          Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Material(
                  elevation: 3.0,
                  borderRadius: BorderRadius.circular(30.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: TextField(
                      controller: _controller,
                      onChanged: _filterDrugs,
                      decoration: InputDecoration(
                        labelText: 'İlaç adını girin',
                        labelStyle:
                            const TextStyle(fontFamily: "Brand-Regular"),
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
                ),
              ),
              const SizedBox(height: 15),
              if (_error != null)
                Text(
                  'Hata: $_error',
                  style: const TextStyle(color: Colors.red),
                ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _filteredDrugList.isNotEmpty
                      ? ListView.builder(
                          itemCount: _filteredDrugList.length,
                          itemBuilder: (context, index) {
                            final drug = _filteredDrugList[index];
                            final drugName =
                                drug['Medicine Name'] ?? 'Bilinmiyor';
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DrugDetailPage(drug: drug),
                                  ),
                                );
                              },
                              child: Card(
                                color: const Color(0xFFb4dced),
                                elevation: 2,
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(
                                    drugName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Brand-Regular",
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : const Center(child: Text('İlaç bilgisi bulunamadı.')),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
