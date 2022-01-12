import 'package:examen/MesDots.dart';
import 'package:examen/Pharmacies.dart';
import 'package:flutter/material.dart';

import 'Certificats.dart';

class Acceuil extends StatefulWidget {
  static String path = "/acceuil";
  const Acceuil({Key? key}) : super(key: key);

  @override
  _AcceuilState createState() => _AcceuilState();
}

class _AcceuilState extends State<Acceuil> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Evax"),
          centerTitle: true,
          bottom: const TabBar(tabs: [
            Tab(
              icon: Icon(Icons.health_and_safety),
              text: "Mes Doses",
            ),
            Tab(
              icon: Icon(Icons.local_pharmacy),
              text: "Pharmacies",
            ),
            Tab(
              icon: Icon(Icons.qr_code),
              text: "Certificats",
            )
          ]),
        ),
        drawer: Drawer(
          child: Column(
            children: [
              AppBar(
                automaticallyImplyLeading: true,
              ),
              ListTile(
                title: const Text("Historique"),
                leading: const Icon(Icons.history),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  //
                  //
                },
              ),
              ListTile(
                title: const Text("Se deconnecter "),
                leading: const Icon(Icons.power_settings_new),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  //
                  //
                },
              ),
            ],
          ),
        ),
        body: TabBarView(children: [MesDots(), Pharmacies(), Certificats()]),
      ),
    );
  }
}
