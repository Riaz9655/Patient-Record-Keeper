import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:patient_record_generator/screens/patient_detail_screen.dart';

class PatientRecordScreen extends StatefulWidget {
  const PatientRecordScreen({super.key});

  @override
  _PatientRecordScreenState createState() => _PatientRecordScreenState();
}

class _PatientRecordScreenState extends State<PatientRecordScreen> {
  void saveData() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_nameController.text.isEmpty ||
          _residentController.text.isEmpty ||
          _genderController.text.isEmpty ||
          _dateController.text.isEmpty ||
          _sedationController.text.isEmpty ||
          _consultantNumberController.text.isEmpty ||
          _registrationNumberController.text.isEmpty ||
          _pcnNumberController.text.isEmpty ||
          _indicationController.text.isEmpty ||
          _procedureController.text.isEmpty) {

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('All fields must be filled out.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        Map<String, String> formData = {
          'Patient Name': _nameController.text,
          'Resident': _residentController.text,
          'Age Gender': _genderController.text,
          'Date': _dateController.text,
          'Sedation': _sedationController.text,
          'Consultant': _consultantNumberController.text,
          'Registrar': _registrationNumberController.text,
          'PCN NO': _pcnNumberController.text,
          'Indication': _indicationController.text,
          'Procedure': _procedureController.text,
        };
        CollectionReference collRef = FirebaseFirestore.instance.collection('Patients');
        collRef.add({
          'Patient Name': _nameController.text,
          'Resident': _residentController.text,
          'Age Gender': _genderController.text,
          'Date': _dateController.text,
          'Sedation': _sedationController.text,
          'Consultant': _consultantNumberController.text,
          'Registrar': _registrationNumberController.text,
          'PCN NO': _pcnNumberController.text,
          'Indication': _indicationController.text,
          'Procedure': _procedureController.text,
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PatientDetailsScreen(formData: formData),
          ),
        );

      }
    }
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _residentController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _sedationController = TextEditingController();
  TextEditingController _consultantNumberController = TextEditingController();
  TextEditingController _registrationNumberController = TextEditingController();
  TextEditingController _pcnNumberController = TextEditingController();
  TextEditingController _indicationController = TextEditingController();

  TextEditingController _procedureController = TextEditingController();

  String _selectedValue = 'Endoscopy';
  List<String> _options = ['Endoscopy', 'Colonoscopy', 'ERCP', 'EUS'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Record'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
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
              const SizedBox(height: 10,),
              _buildRow('Patient Name', 'Consultant(s)', _nameController, _consultantNumberController),
              const SizedBox(height: 10,),
              _buildRow('Age/Gender', 'Date', _genderController, _dateController),
              const SizedBox(height: 10,),
              _buildRow('Sedation', 'Resident', _sedationController, _residentController),
              const SizedBox(height: 10,),
              _buildRow('Registrar', 'PCN NO', _registrationNumberController, _pcnNumberController),
              const SizedBox(height: 15),
              const Divider(
                thickness: 1,
                height: 5,
                color: Colors.black,
              ),
              const SizedBox(height: 15),
              _buildTextField('Indication', _indicationController),
              const SizedBox(height: 10),
              TextFormField(
                controller: _procedureController,
                style: const TextStyle(color: Colors.black, fontSize: 16.0),
                decoration: InputDecoration(
                  labelText: 'Procedure',
                  labelStyle: const TextStyle(color: Colors.blue),
                  suffixIcon: DropdownButton<String>(
                    value: _selectedValue,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedValue = newValue!;
                        _procedureController.text = _selectedValue;
                      });
                    },
                    items: _options.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // Add padding
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  saveData();
                },
                child: const Text('Save Data'),
              ),

            ],
          ),
        ),
      ),
      bottomSheet: Container(
        height: 30,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 69, 95, 83),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
        ),
      ) ,
    );
  }

  Widget _buildRow(String label1, String label2, TextEditingController controller1, TextEditingController controller2) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextFormField(
            controller: controller1,
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
            controller: controller2,
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

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
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

