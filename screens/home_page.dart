import 'package:flutter/material.dart';
import 'package:ortalamatik/models/todo.dart';

class OrtalaMatik extends StatefulWidget {
  const OrtalaMatik({Key? key}) : super(key: key);

  @override
  State<OrtalaMatik> createState() => _OrtalaMatikState();
}

List<String> items = [
  '1 Kredi',
  '2 Kredi',
  '3 Kredi',
];

class _OrtalaMatikState extends State<OrtalaMatik> {
  List<Ders> dersler = [];
  late String dersAdi = "";

  final dersController = TextEditingController();
  final notController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String dropdownvalue = items.first;
  int _kredi = 0;
  double ortalama = 0;
  void ortalamaHesapla() {
    setState(() {
      int dersOrtalamasi = 0;
      int tumDerslerinOrtalamasi = 0;
      int toplamKredi = 0;
      if (dersler.isNotEmpty) {
        for (var item in dersler) {
          dersOrtalamasi = item.not * item.kredi;
          tumDerslerinOrtalamasi = tumDerslerinOrtalamasi + dersOrtalamasi;
          toplamKredi = toplamKredi + item.kredi;
        }
        ortalama = tumDerslerinOrtalamasi / toplamKredi;
      } else {
        ortalama = 0;
      }
    });
  }

  void addLesson() {
    setState(() {
      dersler.add(Ders(
          id: dersler.isNotEmpty ? dersler.last.id + 1 : 1,
          title: dersController.text,
          kredi: _kredi,
          not: int.parse(notController.text)));
    });
  }

  void krediDeger() {
    setState(() {
      if (dropdownvalue == items[0]) {
        _kredi = 1;
      } else if (dropdownvalue == items[1]) {
        _kredi = 2;
      } else if (dropdownvalue == items[2]) {
        _kredi = 3;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Ortalamatik"),
          backgroundColor: Colors.amber,
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              setState(() {
                krediDeger();
                addLesson();
                ortalamaHesapla();
                dersController.clear();
                notController.clear();
              });
            }
          },
        ),
        body: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        onSaved: (newValue) {
                          dersAdi = newValue!;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lütfen bir ders adı girin';
                          }
                          return null;
                        },
                        controller: dersController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Ders Adı",
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 240,
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(width: 3, color: Colors.amber),
                      ),
                    ),
                    value: dropdownvalue,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownvalue = newValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Lütfen bir ders notu girin';
                  }
                  return null;
                },
                controller: notController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Ders Notu",
                ),
              ),
            ),
             Padding(
            padding: const EdgeInsets.fromLTRB(0, 25, 0, 10),
            child: Container(
              decoration: const BoxDecoration(
                  border: Border(
                bottom: BorderSide(color: Colors.orange),
              )),
            ),
          ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Text(
                "Ortalamanız :  $ortalama",
                style: const TextStyle(
                  fontSize: 36,
                  color: Colors.black,
                ),
              ),
            ),
             Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 25),
            child: Container(
              decoration: const BoxDecoration(
                  border: Border(
                bottom: BorderSide(color: Colors.orange),
              )),
            ),
          ),
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.topCenter,
                child: ListView.separated(
                  separatorBuilder: (context, index) => const Divider(
                    height: 5,
                    color: Colors.transparent,
                  ),
                  itemCount: dersler.length,
                  itemBuilder: (BuildContext context, int index) {
                    Ders item = dersler[index];
                    return ListTile(
                      tileColor: Colors.yellow,
                      title: InkWell(
                        onLongPress: () {
                          setState(() {
                            dersler.remove(item);
                          });
                        },
                        child: Text(
                          item.title,
                        ),
                      ),
                      subtitle: InkWell(
                        child: Text("Kredi: ${item.kredi}\tNotu :${item.not}"),
                        onLongPress: () {
                          setState(() {
                            dersler.remove(item);
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
