import 'package:flutter/material.dart';
import 'package:patient_record_generator/screens/search_result_screen.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PatientDetailsScreen extends StatelessWidget {
  final Map<String, String> formData;

  const PatientDetailsScreen({super.key, required this.formData});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Details'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            padding: const EdgeInsets.all(5),
            children: <Widget>[
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
              _buildRow('Patient Name', 'Consultant(s)', formData['Patient Name'] ?? '', formData['Consultant'] ?? ''),
              const SizedBox(height: 15),
              _buildRow('Age/Gender', 'Date', formData['Age Gender'] ?? '', formData['Date'] ?? ''),
              const SizedBox(height: 15),
              _buildRow('Sedation', 'Resident', formData['Sedation'] ?? '', formData['Resident'] ?? ''),
              const SizedBox(height: 15),
              _buildRow('Registrar', 'PCN NO', formData['Registrar'] ?? '', formData['PCN NO'] ?? ''),
              const SizedBox(height: 20),
              const Divider(
                thickness: 2,
                color: Colors.black,
              ),
              const SizedBox(height: 20),
              _buildTextField('Indication', formData['Indication'] ?? ''),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: formData['Procedure'] ?? '',
                style: const TextStyle(color: Colors.black, fontSize: 16.0),
                decoration: const InputDecoration(
                  labelText: 'Procedure',
                  labelStyle: TextStyle(color: Colors.blue),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // Add padding
                ),
              ),
              const SizedBox(height: 30,),
              ElevatedButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return SearchResults();
                      },
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        const begin = Offset(1.0, 0.0);
                        const end = Offset.zero;
                        const curve = Curves.easeInOut;
                        var tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));
                        var offsetAnimation = animation.drive(tween);
                        return SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        );
                      },
                    ),
                  );
                },
                  child: Text('Go to Patient List',style: TextStyle(),),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label1, String label2, String value1, String value2) {
    return Row(
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
              contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // Add padding
            ),
          ),
        ),
        const SizedBox(width: 16),
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
              contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // Add padding
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, String value) {
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
        contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // Add padding
      ),
    );
  }
}
