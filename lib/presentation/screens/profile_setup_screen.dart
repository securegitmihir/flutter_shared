import 'package:assisted_living/app/routes/app_routes.dart';
import 'package:assisted_living/presentation/widgets/custom_button.dart';
import 'package:assisted_living/presentation/widgets/custom_text_field.dart';
import 'package:assisted_living/presentation/widgets/custom_text_widget.dart';
import 'package:assisted_living/responsive/responsive.dart';
import 'package:assisted_living/services/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/initial_profile_setup/initial_profile_setup_bloc.dart';
import '../widgets/custom_radio_button.dart';

class ProfileSetup extends StatefulWidget {
  const ProfileSetup({super.key});

  @override
  State<ProfileSetup> createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup> {
  // final List<String> yearList = [
  //   for (int year = 1900; year <= DateTime.now().year; year++) year.toString(),
  // ];
  late final TextEditingController _fullNameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _birthYearCtrl;

  @override
  void initState() {
    super.initState();
    final initState = context.read<InitialProfileSetupBloc>().state;
    _fullNameCtrl = TextEditingController(text: initState.fullName);
    _emailCtrl = TextEditingController(text: initState.email);
    _birthYearCtrl = TextEditingController(text: initState.birthYear);
  }

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _emailCtrl.dispose();
    _birthYearCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        title: CustomTextWidget(
          "profileSetup.profileSetup".tr(),
          style: Theme.of(context).textTheme
              .rTitleMedium(context)!
          // kohinoorMedium.copyWith(
          //   // fontSize: 24.sp,
          //   fontSize: r.font(24),
          //   fontWeight: FontWeight.w500,
          //   color: AppColors.highlightedTextColor,
          // ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<InitialProfileSetupBloc, InitialProfileSetupState>(
        builder: (context, state) {
          final bloc = context.read<InitialProfileSetupBloc>();
          if (_fullNameCtrl.text != state.fullName) {
            _fullNameCtrl.text = state.fullName;
          }
          if (_emailCtrl.text != state.email) {
            _emailCtrl.text = state.email;
          }
          if (_birthYearCtrl.text != state.birthYear) _birthYearCtrl.text = state.birthYear;
          return Padding(
            // padding: EdgeInsets.all(16.0.w),
            padding: EdgeInsets.all(r.space(16)),
            child: LayoutBuilder(
              builder: (context, c) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: c.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        // mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // SizedBox(height: 10.h),
                          SizedBox(height: r.px(10)),
                          CustomTextField(
                            key: const Key('fullNameField'),
                            controller: _fullNameCtrl,
                            padding: 0,
                            enabled: true,
                            labelText: "profileSetup.fullName".tr(),
                            // height: 43.h,
                            height: r.px(43),
                            errorText: state.fullNameError,
                            hintText: "profileSetup.fullNameHint".tr(),
                            maxLines: 1,
                            numericKeyboard: false,
                            textInputAction: TextInputAction.next,
                            textInputType: TextInputType.name,
                            isRequired: true,
                            inputFormatter: [LengthLimitingTextInputFormatter(50)],
                            textCapitalization: TextCapitalization.words,
                            onChanged: (userName) => bloc.add(FullNameChanged(userName!)),
                            // initialValue: state.fullName,
                          ),
                          // SizedBox(height: 22.h),
                          SizedBox(height: r.px(22)),
                          // CustomDropdownWidget(
                          //   key: const Key('birthYearDropdown'),
                          //   initialItem: state.birthYear,
                          //   isRequired: true,
                          //   showError: state.birthYearError?.isNotEmpty == true,
                          //   error: state.birthYearError,
                          //   dataList: yearList,
                          //   enabled: true,
                          //   hintText: Strings.birthYearLabel,
                          //   labelText: Strings.birthYear,
                          //   onChange: (selectedYear) {
                          //     FocusScope.of(context).unfocus();
                          //     bloc.add(BirthYearChanged(selectedYear ?? ''));
                          //   },
                          // ),
                          GestureDetector(
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              final current = int.tryParse(state.birthYear);
                              final yr = await _showYearPicker(context, initialYear: current);
                              if(!context.mounted) return;
                              if (yr != null) {
                                context.read<InitialProfileSetupBloc>().add(BirthYearChanged(yr.toString()));
                              }
                            },
                            child: AbsorbPointer(
                              child: CustomTextField(
                                key: const Key('birthYearField'),
                                controller: _birthYearCtrl,
                                padding: 0,
                                enabled: true,
                                labelText: "profileSetup.birthYear".tr(),
                                height: r.px(43),
                                hintText: "profileSetup.birthYearHint".tr(),
                                maxLines: 1,
                                numericKeyboard: false,
                                textInputAction: TextInputAction.none,
                                textInputType: TextInputType.datetime,
                                isRequired: true,
                                errorText: state.birthYearError,      // keeps your existing error display
                                onChanged: (_) {},                    // no-op (read-only via AbsorbPointer)
                              ),
                            ),
                          ),
                          // YearAutocompleteField(
                          //   key: const Key('birthYearDropdown'),
                          //   controller: _birthYearCtrl,
                          //   label: Strings.birthYear,
                          //   minYear: 1950,
                          //   maxYear: DateTime.now().year,
                          //   errorText: state.birthYearError,
                          //   onSelected: (year) {
                          //     context.read<InitialProfileSetupBloc>().add(BirthYearChanged(year));
                          //   },
                          // ),
                          SizedBox(height: r.px(18)),
                          // SizedBox(height: 18.h),
                          CustomRadioGroup<String>(
                            key: const Key('genderGroup'),
                            padding: 0,
                            labelText: "profileSetup.gender".tr(),
                            isRequired: true,
                            options: [
                              RadioOption(value: 'Male', label: "profileSetup.male".tr()),
                              RadioOption(value: 'Female', label: "profileSetup.female".tr()),
                            ],
                            groupValue: state.gender.isEmpty ? null : state.gender,
                            onChanged: (gender) => bloc.add(GenderChanged(gender!)),
                            errorText: state.genderError,
                            direction: Axis.horizontal,
                            enabled: true,
                          ),
                          // SizedBox(height: 15.h),
                          SizedBox(height: r.px(15)),
                          CustomTextField(
                            key: const Key('emailField'),
                            controller: _emailCtrl,
                            padding: 0,
                            enabled: true,
                            labelText: "profileSetup.email".tr(),
                            // height: 43.h,
                            height: r.px(43),
                            errorText: state.emailError,
                            hintText: "profileSetup.emailHint".tr(),
                            maxLines: 1,
                            numericKeyboard: false,
                            textInputAction: TextInputAction.next,
                            textInputType: TextInputType.emailAddress,
                            isRequired: false,
                            inputFormatter: [LengthLimitingTextInputFormatter(50)],
                            onChanged: (email) => bloc.add(EmailChanged(email!)),
                            // initialValue: state.email,
                          ),
                          const Spacer(),
                          // SizedBox(height: 10.h,),
                          SizedBox(height: r.px(10)),
                          // kbOpen ? SizedBox(height: 0.h) : const Spacer(),
                          CustomButton(
                            key: const Key('saveContinueBtn'),
                            buttonText: "profileSetup.save".tr(),
                            isValid: state.isStepValid,
                            onClick: () {
                              FocusScope.of(context).unfocus();
                              bloc.add(ValidateStep());
                              final ok = bloc.state.isStepValid;
                              if (ok) {
                                Navigator.pushNamed(context, AppRoutes.dashboard, arguments: {
                                  'username': _fullNameCtrl.text.trim(),
                                  'gender': state.gender
                                },);
                              }
                            },
                            isLoading: false,
                          ),
                          // SizedBox(height: 15.h),
                          SizedBox(height: r.px(15)),
                        ],
                      ),
                    ),
                  ),
                );
              },
              // child: SingleChildScrollView(
              //   child: IntrinsicHeight(
              //     child: Column(
              //       // mainAxisSize: MainAxisSize.min,
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         SizedBox(height: 10.h),
              //         CustomTextField(
              //           key: const Key('fullNameField'),
              //           padding: 0,
              //           enabled: true,
              //           labelText: Strings.fullName,
              //           height: 43.h,
              //           errorText: state.fullNameError,
              //           hintText: Strings.fullNameLabel,
              //           maxLines: 1,
              //           numericKeyboard: false,
              //           textInputAction: TextInputAction.next,
              //           textInputType: TextInputType.name,
              //           isRequired: true,
              //           inputFormatter: [LengthLimitingTextInputFormatter(50)],
              //           textCapitalization: TextCapitalization.words,
              //           onChanged: (userName) => bloc.add(FullNameChanged(userName!)),
              //           initialValue: state.fullName,
              //         ),
              //         SizedBox(height: 22.h),
              //         CustomDropdownWidget(
              //           key: const Key('birthYearDropdown'),
              //           initialItem: state.birthYear,
              //           isRequired: true,
              //           showError: state.birthYearError?.isNotEmpty == true,
              //           error: state.birthYearError,
              //           dataList: yearList,
              //           enabled: true,
              //           hintText: Strings.birthYearLabel,
              //           labelText: Strings.birthYear,
              //           onChange: (selectedYear) {
              //             FocusScope.of(context).unfocus();
              //             bloc.add(BirthYearChanged(selectedYear ?? ''));
              //           },
              //         ),
              //         SizedBox(height: 18.h),
              //         CustomRadioGroup<String>(
              //           key: const Key('genderGroup'),
              //           padding: 0,
              //           labelText: 'Gender',
              //           isRequired: true,
              //           options: const [
              //             RadioOption(value: 'Male', label: 'Male'),
              //             RadioOption(value: 'Female', label: 'Female'),
              //           ],
              //           groupValue: state.gender.isEmpty ? null : state.gender,
              //           onChanged: (gender) => bloc.add(GenderChanged(gender!)),
              //           errorText: state.genderError,
              //           direction: Axis.horizontal,
              //           enabled: true,
              //         ),
              //         SizedBox(height: 15.h),
              //         CustomTextField(
              //           key: const Key('emailField'),
              //           padding: 0,
              //           enabled: true,
              //           labelText: Strings.email,
              //           height: 43.h,
              //           errorText: state.emailError,
              //           hintText: Strings.emailLabel,
              //           maxLines: 1,
              //           numericKeyboard: false,
              //           textInputAction: TextInputAction.next,
              //           textInputType: TextInputType.emailAddress,
              //           isRequired: false,
              //           inputFormatter: [LengthLimitingTextInputFormatter(50)],
              //           onChanged: (email) => bloc.add(EmailChanged(email!)),
              //           initialValue: state.email,
              //         ),
              //         const Spacer(),
              //         // kbOpen ? SizedBox(height: 0.h) : const Spacer(),
              //         CustomButton(
              //           key: const Key('saveContinueBtn'),
              //           buttonText: Strings.saveAndContinue,
              //           isValid: state.isStepValid,
              //           onClick: () {
              //             FocusScope.of(context).unfocus();
              //             bloc.add(ValidateStep());
              //             final ok = bloc.state.isStepValid;
              //             if (ok) {
              //               Navigator.pushNamed(context, AppRoutes.dashboard);
              //             }
              //           },
              //           isLoading: false,
              //         ),
              //         SizedBox(height: 20.h),
              //       ],
              //     ),
              //   ),
              // ),
            ),
          );
        },
      ),
    );
  }

  Future<int?> _showYearPicker(BuildContext context, {int? initialYear}) async {
    final now = DateTime.now();
    final first = DateTime(1950);
    final last  = DateTime(now.year);
    final selected = DateTime(initialYear ?? now.year);

    int? picked;
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Select birth year'),
        content: SizedBox(
          width: 320,
          height: 320,
          child: YearPicker(
            firstDate: first,
            lastDate: last,
            selectedDate: selected,
            onChanged: (date) {
              picked = date.year;
              Navigator.pop(ctx); // close on pick
            },
          ),
        ),
      ),
    );
    return picked;
  }

  // Future<int?> _pickYearWithCalendar(BuildContext context, {int? initialYear}) async {
  //   final now = DateTime.now();
  //   final first = DateTime(1950, 1, 1);
  //   final last  = DateTime(now.year, 12, 31);
  //   DateTime init = DateTime(initialYear ?? now.year, 1, 1);
  //   if (init.isBefore(first)) init = first;
  //   if (init.isAfter(last))  init = last;
  //
  //   final date = await showDatePicker(
  //     context: context,
  //     initialDate: init,
  //     firstDate: first,
  //     lastDate: last,
  //     helpText: 'Select birth year',
  //     initialEntryMode: DatePickerEntryMode.calendarOnly,
  //     initialDatePickerMode: DatePickerMode.year, // ← starts in year grid
  //     builder: (context, child) {
  //       final theme = Theme.of(context);
  //       return Theme(
  //         data: theme.copyWith(
  //           textButtonTheme: TextButtonThemeData(
  //             style: TextButton.styleFrom(foregroundColor: AppColors.appBarColor),
  //           ),
  //           colorScheme: theme.colorScheme.copyWith(
  //             primary: AppColors.appBarColor,   // header / selection accents
  //             onPrimary: Colors.white,
  //             surface: Colors.white,
  //             onSurface: Colors.black87,
  //           ),
  //           datePickerTheme: DatePickerThemeData(
  //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //             headerBackgroundColor: AppColors.appBarColor,
  //             headerForegroundColor: Colors.white,
  //             yearBackgroundColor: MaterialStateProperty.resolveWith((states) {
  //               if (states.contains(MaterialState.selected)) return AppColors.appBarDarkColor;
  //               return null;
  //             }),
  //             yearForegroundColor: MaterialStateProperty.resolveWith((states) {
  //               if (states.contains(MaterialState.selected)) return Colors.white;
  //               return null;
  //             }),
  //           ),
  //         ),
  //         child: child!,
  //       );
  //     },
  //   );
  //
  //   return date?.year;
  // }

}
