import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import '/core/constants/kcache.dart';
import '/core/widgets/_widget_staff_avatar.dart';
import '/modules/staff/presenter/controllers/staff_controller.dart';
import '/utils/progress_bar/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'staff_profile_name_editor.dart';

class StaffProfileEditor extends StatelessWidget {
  StaffController _staffController = Get.put(StaffController());

  final int staffid;
  StaffProfileEditor(this.staffid, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _staffController.selectStaff(staffid);
    return Obx(() => SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height * 0.90,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                      ),
                      child: _image('${_staffController.urlImage}'),
                    ),
                    onTap: () async {},
                  ),
                  Container(
                    height: 35,
                    child: Row(children: [
                      Text('${_staffController.count}',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.background)),
                      const Spacer(),
                      InkWell(
                          child: Padding(
                              padding: EdgeInsets.all(18),
                              child: Icon(Icons.edit)),
                          onTap: () async {
                            await showModalBottomSheet(
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (BuildContext context) {
                                  return StaffProfileNameEditor(staffid);
                                });
                          })
                    ]),
                  ),
                  ListTile(
                    title: Text(
                      'Primeiro nome',
                      style: TextStyle(fontSize: 11),
                    ),
                    subtitle: Text(
                        '${_staffController.selectedStaffModel.firstname}'),
                  ),
                  ListTile(
                    title: Text(
                      'Segundo nome',
                      style: TextStyle(fontSize: 11),
                    ),
                    subtitle:
                        Text('${_staffController.selectedStaffModel.lastname}'),
                  ),
                  ListTile(
                    title: Text(
                      'E-mail',
                      style: TextStyle(fontSize: 11),
                    ),
                    subtitle:
                        Text('${_staffController.selectedStaffModel.email}'),
                  ),
                  ListTile(
                    title: Text(
                      'Skype',
                      style: TextStyle(fontSize: 11),
                    ),
                    subtitle:
                        Text('${_staffController.selectedStaffModel.skype}'),
                  ),
                  ListTile(
                    title: Text(
                      'Facebook',
                      style: TextStyle(fontSize: 11),
                    ),
                    subtitle:
                        Text('${_staffController.selectedStaffModel.facebook}'),
                  ),
                  ListTile(
                    title: Text(
                      'Linkedin',
                      style: TextStyle(fontSize: 11),
                    ),
                    subtitle:
                        Text('${_staffController.selectedStaffModel.linkedin}'),
                  ),
                  const Spacer(),
                  ListTile(
                    title: Text(
                      '',
                      style: TextStyle(fontSize: 11),
                    ),
                    subtitle: Text(
                      '${_staffController.count}',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.background),
                    ),
                  ),
                ],
              )),
        ));
  }

  _image(String _image) {
    return WidgetStaffAvatar(
      urlImage: _image,
      shape: BoxShape.rectangle,
    );
  }
}
