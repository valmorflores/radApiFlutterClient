import 'dart:io';

import '/modules/staff/presenter/controllers/staff_controller.dart';
import '/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StaffProfileNameEditor extends StatelessWidget {
  StaffController _staffController = Get.put(StaffController());

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();

  final int staffid;
  StaffProfileNameEditor(this.staffid, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _staffController.selectStaff(staffid);

    _firstNameController.text =
        _staffController.selectedStaffModel.firstname.toString();
    _lastNameController.text =
        _staffController.selectedStaffModel.lastname.toString();

    return Container(
        height: MediaQuery.of(context).size.height * 0.60,
        decoration:
            BoxDecoration(color: Theme.of(context).colorScheme.background),
        child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                  child: Container(
                      height: 200,
                      child: ListView(
                        children: [
                          SizedBox(
                            height: 12,
                          ),
                          ListTile(
                            title: Text(
                              'Dados pessoais em ${app_selected_workspace_name}',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(
                              'As informações a seguir aparecerão específicamente neste ambiente. Para cada workspace você pode se identificar como preferir.',
                              style: TextStyle(fontSize: 11),
                            ),
                          ),
                          ListTile(
                            title: Text(
                              'Primeiro nome',
                              style: TextStyle(fontSize: 11),
                            ),
                            subtitle: TextField(
                              controller: _firstNameController,
                              decoration: InputDecoration(
                                suffixIcon: Icon(
                                  Icons.search,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  size: 20.0,
                                ),
                                border: InputBorder.none,
                                hintText: 'Filtro',
                              ),
                            ),
                          ),
                          ListTile(
                            title: Text(
                              'Segundo nome',
                              style: TextStyle(fontSize: 11),
                            ),
                            subtitle: TextField(
                              controller: _lastNameController,
                              decoration: InputDecoration(
                                suffixIcon: Icon(
                                  Icons.search,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  size: 20.0,
                                ),
                                border: InputBorder.none,
                                hintText: 'Filtro',
                              ),
                            ),
                          ),
                        ],
                      ))),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(children: [
                  const Spacer(),
                  FloatingActionButton(
                    onPressed: () {
                      _staffController.postChangeName(
                        firstname: _firstNameController.text,
                        lastname: _lastNameController.text,
                      );
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.check),
                  )
                ]),
              )
            ])));
  }
}
