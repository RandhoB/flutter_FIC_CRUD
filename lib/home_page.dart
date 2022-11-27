import 'package:flutter/material.dart';
import 'package:flutter_crud/core.dart';
import 'package:flutter_crud/models/medical_model.dart';
import 'package:flutter_crud/utils/network_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final nameController = TextEditingController();
  final stokController = TextEditingController();
  final hargaController = TextEditingController();
  final deskripsiController = TextEditingController();

  List<Medical> medicals = [];
  bool isLoading = false;

  Future<void> refreshData() async {
    setState(() {
      isLoading = true;
    });
    final result = await NetworkManager().getAll();
    medicals = result.data;
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: const [],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Card(
              child: ListView.builder(
                itemCount: medicals.length,
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      formData(medicals[index]);
                    },
                    child: Card(
                      child: ListTile(
                        title: Text(medicals[index].attributes.name),
                        subtitle: Text(medicals[index].attributes.description),
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          formData(null);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void formData(Medical? data) async {
    if (data != null) {
      nameController.text = data.attributes.name;
      stokController.text = data.attributes.stock.toString();
      hargaController.text = data.attributes.price.toString();
      deskripsiController.text = data.attributes.description;
    }
    bool confirm = false;
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(data == null ? 'Add' : 'Update'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                TextFormField(
                  controller: nameController,
                  // initialValue: '',
                  maxLength: 20,
                  decoration: const InputDecoration(
                    labelText: 'Nama Obat',
                    labelStyle: TextStyle(
                      color: Colors.blueGrey,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blueGrey,
                      ),
                    ),
                    helperText: "Apa nama obat",
                  ),
                  onChanged: (value) {},
                ),
                TextFormField(
                  controller: stokController,
                  // initialValue: '0',
                  maxLength: 20,
                  decoration: const InputDecoration(
                    labelText: 'Stok',
                    labelStyle: TextStyle(
                      color: Colors.blueGrey,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blueGrey,
                      ),
                    ),
                    helperText: "Stok?",
                  ),
                  onChanged: (value) {},
                ),
                TextFormField(
                  controller: hargaController,
                  // initialValue: '10000',
                  maxLength: 20,
                  decoration: const InputDecoration(
                    labelText: 'Harga',
                    labelStyle: TextStyle(
                      color: Colors.blueGrey,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blueGrey,
                      ),
                    ),
                    helperText: "Harga?",
                  ),
                  onChanged: (value) {},
                ),
                TextFormField(
                  controller: deskripsiController,
                  // initialValue: '',
                  maxLength: 20,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi',
                    labelStyle: TextStyle(
                      color: Colors.blueGrey,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blueGrey,
                      ),
                    ),
                    helperText: "Deskripsi obat?",
                  ),
                  onChanged: (value) {},
                ),
              ],
            ),
          ),
          actions: <Widget>[
            if (data != null)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[600],
                ),
                onPressed: () async {
                  await NetworkManager().deleteData(data.id);
                  await refreshData();
                  Navigator.pop(context);
                },
                child: const Text("Delete"),
              ),
            const SizedBox(
              width: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[600],
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Tidak"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
              ),
              onPressed: () {
                confirm = true;
                Navigator.pop(context);
              },
              child: const Text("Ya"),
            ),
          ],
        );
      },
    );

    if (confirm) {
      print("Confirmed!");
      RequestMedical request = RequestMedical(
        nameController.text,
        int.parse(stokController.text),
        int.parse(hargaController.text),
        deskripsiController.text,
      );
      if (data == null) {
        await NetworkManager().addData(request);
      } else {
        await NetworkManager().updateData(
          data.id,
          request,
        );
      }

      nameController.clear();
      stokController.clear();
      hargaController.clear();
      deskripsiController.clear();
      await refreshData();
    }
  }
}
