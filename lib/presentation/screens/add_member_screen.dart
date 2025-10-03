// import 'package:assisted_living/responsive/responsive.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// import '../../services/app_colors.dart';
// import '../../services/strings.dart';
// import '../widgets/custom_appbar.dart';
// import '../widgets/custom_text_field.dart';
// import '../widgets/custom_text_widget.dart';
//
// class AddMemberScreen extends StatefulWidget {
//   const AddMemberScreen({super.key});
//
//   @override
//   State<AddMemberScreen> createState() => _AddMemberScreenState();
// }
//
// class _AddMemberScreenState extends State<AddMemberScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final r = context.responsive;
//
//     return Scaffold(
//       appBar: CustomAppBar(
//         title: CustomTextWidget(
//           Strings.addMember,
//           style: Theme.of(
//             context,
//           ).textTheme.rTitleMedium(context)!.copyWith(color: Colors.white),
//         ),
//         foregroundColor: AppColors.btnTextColor,
//         gradient: const LinearGradient(
//           colors: [AppColors.appBarColor, AppColors.appBarDarkColor],
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//         ),
//         centerTitle: false,
//       ),
//       body: Column(
//         children: [
//           CustomTextField(
//             key: const Key('NameField'),
//             padding: 0,
//             enabled: true,
//             labelText: Strings.fullName,
//             // height: 43.h,
//             height: r.px(43),
//             // errorText: state.fullNameError,
//             hintText: Strings.fullNameLabel,
//             maxLines: 1,
//             numericKeyboard: false,
//             textInputAction: TextInputAction.next,
//             textInputType: TextInputType.name,
//             isRequired: true,
//             inputFormatter: [LengthLimitingTextInputFormatter(50)],
//             textCapitalization: TextCapitalization.words,
//             onChanged: (userName) {},
//             // initialValue: state.fullName,
//           ),
//           CustomTextField(
//             key: const Key('relationField'),
//             padding: 0,
//             enabled: true,
//             labelText: Strings.fullName,
//             // height: 43.h,
//             height: r.px(43),
//             // errorText: state.fullNameError,
//             hintText: Strings.fullNameLabel,
//             maxLines: 1,
//             numericKeyboard: false,
//             textInputAction: TextInputAction.next,
//             textInputType: TextInputType.name,
//             isRequired: true,
//             inputFormatter: [LengthLimitingTextInputFormatter(50)],
//             textCapitalization: TextCapitalization.words,
//             onChanged: (userName) {},
//             // initialValue: state.fullName,
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:io';

import 'package:assisted_living/responsive/responsive.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/app_colors.dart';
import '../widgets/avatar_picker.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_dropdown_widget.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_text_widget.dart';
import '../widgets/custom_button.dart';
import '../widgets/image_picker_helper.dart';

class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen({super.key});

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  final _nameCtrl = TextEditingController();
  final _otherRelationCtrl = TextEditingController();
  String? _relation;
  bool _saving = false;
  final _picker = ImagePicker();
  File? _avatarFile;

  final _relations = const <String>[
    'Father',
    'Mother',
    'Husband',
    'Wife',
    'Son',
    'Daughter',
    'Others',
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _otherRelationCtrl.dispose();
    super.dispose();
  }

  bool get _isValid => _nameCtrl.text.trim().isNotEmpty && _relation != null;

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;

    return Scaffold(
      appBar: CustomAppBar(
        title: CustomTextWidget(
          "addMember.addMember".tr(),
          style: Theme.of(context).textTheme
              .rTitleMedium(context)!
              .copyWith(color: AppColors.btnTextColor),
        ),
        foregroundColor: AppColors.btnTextColor,
        gradient: const LinearGradient(
          colors: [AppColors.appBarColor, AppColors.appBarDarkColor],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        centerTitle: false,
      ),

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, c) {
            // child:
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: r.space(16)),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: c.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: r.px(24)),

                      // Avatar + camera badge
                      Center(
                        child: Column(
                          children: [
                            AvatarPicker(
                              radius: r.px(55),
                              file: _avatarFile,
                              badgeColor: AppColors.appBarColor,
                              onTap: () async {
                                final f =
                                    await ImagePickerHelper.pickImageWithSheet(
                                      context,
                                    );
                                if (!mounted) return;
                                if (f != null) setState(() => _avatarFile = f);
                              },
                            ),
                            SizedBox(height: r.px(20)),
                            CustomTextWidget(
                              'Add profile picture',
                              style: Theme.of(
                                context,
                              ).textTheme.rDisplayMedium(context)!,
                            ),
                          ],
                        ),
                        // child: Stack(
                        //   clipBehavior: Clip.none,
                        //   children: [
                        //     CircleAvatar(
                        //       radius: r.px(44),
                        //       backgroundColor: const Color(0xFFE6ECE9),
                        //       backgroundImage:
                        //       _avatarFile != null ? FileImage(_avatarFile!) : null,
                        //       child: _avatarFile == null
                        //           ? Icon(Icons.person,
                        //           size: r.px(52),
                        //           color: const Color(0xFF9BB0A8))
                        //           : null,
                        //       // child: Icon(
                        //       //   Icons.person,
                        //       //   size: r.px(52),
                        //       //   color: const Color(0xFF9BB0A8),
                        //       // ),
                        //     ),
                        //     Positioned(
                        //       right: -2,
                        //       bottom: -2,
                        //       child: InkWell(
                        //         onTap: _pickImage,
                        //         // Implement with image_picker if you want
                        //         borderRadius: BorderRadius.circular(r.px(16)),
                        //         child: Container(
                        //           padding: EdgeInsets.all(r.px(6)),
                        //           decoration: BoxDecoration(
                        //             color: AppColors.appBarDarkColor,
                        //             shape: BoxShape.circle,
                        //             border: Border.all(
                        //               color: Colors.white,
                        //               width: 2,
                        //             ),
                        //           ),
                        //           child: Icon(
                        //             Icons.camera_alt,
                        //             size: r.px(16),
                        //             color: Colors.white,
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ),

                      SizedBox(height: r.px(28)),

                      // Full name
                      CustomTextField(
                        key: const Key('NameField'),
                        padding: 0,
                        enabled: true,
                        labelText: "addMember.fullName".tr(),
                        height: r.px(43),
                        hintText: "addMember.hintFullNameText".tr(),
                        maxLines: 1,
                        numericKeyboard: false,
                        textInputAction: TextInputAction.next,
                        textInputType: TextInputType.name,
                        isRequired: true,
                        // shows the asterisk like your mock
                        inputFormatter: [LengthLimitingTextInputFormatter(50)],
                        textCapitalization: TextCapitalization.words,
                        onChanged: (_) => setState(() {}),
                      ),

                      SizedBox(height: r.px(18)),

                      // Relation dropdown
                      // Text(
                      //   'Relation*',
                      //   style: Theme.of(context).textTheme.rLabelMedium(context),
                      // ),
                      // SizedBox(height: r.px(6)),
                      // DropdownButtonFormField<String>(
                      //   key: const Key('RelationDropdown'),
                      //   value: _relation,
                      //   isExpanded: true,
                      //   icon: const Icon(Icons.keyboard_arrow_down),
                      //   decoration: InputDecoration(
                      //     hintText: 'Select',
                      //     contentPadding: EdgeInsets.symmetric(
                      //       horizontal: r.space(12),
                      //       vertical: r.px(12),
                      //     ),
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(r.px(8)),
                      //     ),
                      //     enabledBorder: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(r.px(8)),
                      //       borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                      //     ),
                      //   ),
                      //   items: _relations
                      //       .map((rel) => DropdownMenuItem<String>(
                      //     value: rel,
                      //     child: Text(
                      //       rel,
                      //       style: Theme.of(context)
                      //           .textTheme
                      //           .rBodyMedium(context)!
                      //           .copyWith(fontSize: r.font(14)),
                      //     ),
                      //   ))
                      //       .toList(),
                      //   onChanged: (val) => setState(() => _relation = val),
                      // ),
                      CustomDropdownWidget(
                        key: const Key('relationDropdown'),
                        // initialItem: state.birthYear,
                        // isRequired: true,
                        showError: false,
                        error: null,
                        dataList: _relations,
                        enabled: true,
                        hintText: "addMember.hintRelationText".tr(),
                        labelText: "addMember.hintLabelText".tr(),
                        onChange: (val) {
                          setState(() {
                            _relation = val;
                            if (_relation != 'Others') {
                              _otherRelationCtrl
                                  .clear(); // clear when switching away
                            }
                          });
                          // FocusScope.of(context).unfocus();
                          // bloc.add(BirthYearChanged(selectedYear ?? ''));
                        },
                      ),

                      // Show extra field when "Others" is chosen
                      if (_relation == 'Others') ...[
                        SizedBox(height: r.px(18)),
                        CustomTextField(
                          key: const Key('otherRelationField'),
                          padding: 0,
                          enabled: true,
                          labelText: 'Specify relation',
                          height: r.px(43),
                          hintText: 'Enter relation',
                          maxLines: 1,
                          numericKeyboard: false,
                          textInputAction: TextInputAction.done,
                          textInputType: TextInputType.text,
                          isRequired: true,
                          inputFormatter: [
                            LengthLimitingTextInputFormatter(30),
                          ],
                          onChanged: (_) => setState(() {}),
                        ),
                      ],

                      SizedBox(height: r.px(24)),
                      const Spacer(),

                      CustomButton(
                        key: const Key('saveContinueBtn'),
                        buttonText: "addMember.save".tr(),
                        isValid: false,
                        onClick: () {
                          FocusScope.of(context).unfocus();
                          Navigator.pop(context);
                          // bloc.add(ValidateStep());
                          // final ok = bloc.state.isStepValid;
                          // if (ok) {
                          //   Navigator.pushNamed(context, AppRoutes.dashboard);
                          // }
                        },
                        isLoading: false,
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    // TODO: call your bloc/repo to save member
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    setState(() => _saving = false);

    // Close and return data if you want:
    Navigator.pop(context, {
      'name': _nameCtrl.text.trim(),
      'relation': _relation,
      'avatarPath': _avatarFile?.path,
    });
  }
}
