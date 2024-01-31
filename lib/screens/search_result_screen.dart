import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class SearchResults extends StatefulWidget {
  const SearchResults({Key? key}) : super(key: key);

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  List _allResults = [];
  List _resultList = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    _searchController.addListener(_onSearchChanged);
    super.initState();
  }

  _onSearchChanged() {
    print(_searchController.text);
    searchResultList();
  }

  searchResultList() {
    var showResults = [];
    if (_searchController.text != '') {
      for (var clientSnapshot in _allResults) {
        var name = clientSnapshot['Patient Name'].toString().toLowerCase();
        var pg = clientSnapshot['PCN NO'].toString().toLowerCase();

        if (name.contains(_searchController.text.toLowerCase()) ||
            pg.contains(_searchController.text.toLowerCase())) {
          showResults.add(clientSnapshot);
        }
      }
    } else {
      showResults = List.from(_allResults);
    }
    setState(() {
      _resultList = showResults;
    });
  }

  getClientStream() async {
    var data =
    await FirebaseFirestore.instance.collection('Patients').orderBy('Patient Name').get();
    setState(() {
      _allResults = data.docs;
    });
    searchResultList();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    getClientStream();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: CupertinoSearchTextField(
            backgroundColor: Colors.white,
            controller: _searchController,
          ),
          elevation: 2.0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {},
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {},
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: _resultList.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Container(
                  height: 100,
                  width: double.infinity,
                  child: Image.asset('assets/images/pims.jpg'),
                ),
                const Center(child: Text('Pakistan Institute of Medical Sciences',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
                ),
                const SizedBox(height: 15),
                Card(
                  elevation: 2.0,
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [

                        _buildRow('Patient Name', 'Consultant(s)', _resultList[index]['Patient Name'],
                            _resultList[index]['Consultant']),
                        const SizedBox(height: 10),
                        _buildRow('Age/Gender', 'Date', _resultList[index]['Age Gender'], _resultList[index]['Date']),
                        const SizedBox(height: 10),
                        _buildRow('Sedation', 'Resident', _resultList[index]['Sedation'], _resultList[index]['Resident']),
                        const SizedBox(height: 10),
                        _buildRow('Registrar', 'PCN NO', _resultList[index]['Registrar'], _resultList[index]['PCN NO']),
                        const SizedBox(height: 10),
                        _buildTextField('Indication', _resultList[index]['Indication']),
                        const SizedBox(height: 10),
                        _buildTextField('Procedure', _resultList[index]['Procedure']),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                await _generateAndDisplayPdf(context, _resultList[index]);
                              },
                              child: const Icon(Icons.print,size: 30,color: Color.fromARGB(255, 69, 95, 83),),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _deleteData(index);
                              },
                              child: const Icon(Icons.delete,size: 30,color: Color.fromARGB(255, 69, 95, 83),),
                            ),

                          ],
                        )

                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _generateAndDisplayPdf(BuildContext context, QueryDocumentSnapshot data) async {
    final pdf = pw.Document();
    final Map<String, dynamic> patientData = data.data() as Map<String, dynamic>;

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Center(child: pw.Text('Pakistan Institute of Medical Sciences',
              style: pw.TextStyle(
                fontSize: 20,
                fontWeight: pw.FontWeight.bold,
                decoration: pw.TextDecoration.underline,
              ),
            ),
            ),
            pw.SizedBox(height: 15),
            pw.Text('Patient Report', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            _buildField('Patient Name', patientData['Patient Name'],'Consultant(s)', patientData['Consultant']),
            _buildField('Age/Gender', patientData['Age Gender'],'Date', patientData['Date']),
            _buildField('Sedation', patientData['Sedation'],'Resident', patientData['Resident']),
            _buildField('Registrar', patientData['Registrar'],'PCN NO', patientData['PCN NO']),
            pw.SizedBox(height: 20),
            pw.Divider(height: 2,thickness: 2),
            pw.SizedBox(height: 20),
            _buildField2('Indication', patientData['Indication']),
            _buildField2('Procedure', patientData['Procedure']),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save(), name: 'Patient_Record');

    // Optionally, you can show a SnackBar after printing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Color.fromARGB(255, 69, 95, 83),
        content: const Text('PDF Generated Successfully'),
      ),
    );
  }

  pw.Widget _buildField(String label, String value,String label2, String value2) {
    return pw.Column(
      children: [
    pw.Container(
    margin: pw.EdgeInsets.only(bottom: 10),
    padding: pw.EdgeInsets.all(10),
    decoration: pw.BoxDecoration(
    borderRadius: pw.BorderRadius.circular(10),
    border: pw.Border.all(color: PdfColor.fromHex("#000000"), width: 1),
    ),
    child: pw.Row(
    crossAxisAlignment: pw.CrossAxisAlignment.center,
    mainAxisAlignment: pw.MainAxisAlignment.center,
    children: [
    pw.Text('$label:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
    pw.SizedBox(width: 12),
    pw.Text(value),
    pw.Expanded(child: pw.Container()),
    pw.SizedBox(width: 12),
    pw.Text('$label2: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
    pw.Text(value2),

    ],
    ),
    ),
      ]
    );
  }
  pw.Widget _buildField2(String label, String value) {
    return pw.Container(
      margin: pw.EdgeInsets.only(bottom: 10),
      padding: pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        borderRadius: pw.BorderRadius.circular(10),
        border: pw.Border.all(color: PdfColor.fromHex("#000000"), width: 1),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Text('$label:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(width: 12),
          pw.Text(value),
          pw.Expanded(child: pw.Container()),

        ],
      ),
    );
  }

  static Widget _buildTextField(String label, String value) {
    return TextFormField(
      initialValue: value,
      readOnly: true,
      style: const TextStyle(color: Colors.black, fontSize: 16.0),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.blue),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      ),
    );
  }

  static Widget _buildRow(String label1, String label2, String value1, String value2) {
    return Container(
      height: 40,
      width: 400,
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextFormField(
              initialValue: value1,
              readOnly: true,
              style: const TextStyle(color: Colors.black, fontSize: 16.0),
              decoration: InputDecoration(
                labelText: label1,
                labelStyle: const TextStyle(color: Colors.blue),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: TextFormField(
              initialValue: value2,
              readOnly: true,
              style: const TextStyle(color: Colors.black, fontSize: 16.0),
              decoration: InputDecoration(
                labelText: label2,
                labelStyle: const TextStyle(color: Colors.blue),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
  void _deleteData(int index) async {

    String documentId = _resultList[index].id;
    await FirebaseFirestore.instance.collection('Patients').doc(documentId).delete();

    setState(() {
      _resultList.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Color.fromARGB(255, 69, 95, 83),
        content: const Text('Data Deleted Successfully'),
      ),
    );
  }

}
