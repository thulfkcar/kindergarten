import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../di/Modules.dart';
import '../../../../them/DentalThem.dart';
import '../../../utile/language_constrants.dart';
import '../../Home/HomeUI.dart';
import '../../dialogs/ActionDialog.dart';
import 'adminProfile/AdminProfileScreen.dart';

class AdminScreen extends ConsumerStatefulWidget {
  const AdminScreen({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  ConsumerState<AdminScreen> createState() => _NavigationScreen();
}
class _NavigationScreen extends ConsumerState<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                elevation: MaterialStateProperty.all(0)),
            onPressed: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => const AdminProfileScreen()));
            },
            child: const Icon(
              Icons.person_outline_outlined,
              size: 25,
            )),

        actions: [ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent),
                  elevation: MaterialStateProperty.all(0)),
              onPressed: () async {
                var user = ref.watch(hiveProvider).value!.getUser();
                showAlertDialog(
                    context: context,
                    messageDialog: ActionDialog(
                        type: DialogType.qr,
                        qr: user!.id,
                        title: getTranslated("self_identity", context),
                        message: getTranslated("scan_for_Operation", context)));
              },
              child: const Icon(Icons.qr_code))],
        automaticallyImplyLeading: true,
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          widget.title,
          style: const TextStyle(color: KidThem.textTitleColor),
        ),
      ),
      body: const Home(),

    );
  }
}
