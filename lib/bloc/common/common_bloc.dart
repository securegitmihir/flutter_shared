import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../data/models/country_code_model.dart';
import '../../data/repository/common_repo.dart';
import '../../utilities/app_exception.dart';
import '../../app/configuration/validation_mssg.dart';

part 'common_event.dart';
part 'common_state.dart';

class CommonBloc extends HydratedBloc<CommonEvent, CommonState> {
  final CommonRepository commonRepository;

  CommonBloc(this.commonRepository) : super(CommonInitial()) {
    on<GetMobileCode>(_getMobileCode);
  }

  // void _getMobileCode(GetMobileCode event, Emitter<CommonState> emit) async {
  //   emit(MobileCodeLoading());
  //
  //   final String jsonData = await GetStorageUtils.getString(kMobileCodeList, '');
  //   List<CountryMobileCodesList> codeList = [];
  //
  //   if (jsonData.isNotEmpty) {
  //     final List<dynamic> jsonList = jsonDecode(jsonData);
  //     codeList = jsonList.map((e) => CountryMobileCodesList.fromJson(e)).toList();
  //   }
  //
  //   if (codeList.isEmpty) {
  //     try {
  //       final data = {'userid': 1, 'tenantid': 1};
  //       final mobileCodeList = await commonRepository.getCountryCodeList(data);
  //
  //       if (mobileCodeList == null) {
  //         throw InvalidInputException(MobileCodeValidationMessage.notDefinedException);
  //       }
  //
  //       emit(MobileCodeFetched(mobileCodes: mobileCodeList));
  //       // GetStorageUtils.setString(kMobileCodeList, jsonEncode(mobileCodeList));
  //     } catch (e) {
  //       emit(MobileCodeFailure(error: e.toString()));
  //     }
  //   } else {
  //     emit(MobileCodeFetched(mobileCodes: codeList));
  //   }
  // }
  Future<void> _getMobileCode(
    GetMobileCode event,
    Emitter<CommonState> emit,
  ) async {
    // If already cached in HydratedBloc, no need to fetch again
    if (state is MobileCodeFetched) {
      final cached = state as MobileCodeFetched;
      if (cached.mobileCodes.isNotEmpty) {
        emit(cached);
        return;
      }
    }

    emit(MobileCodeLoading());
    try {
      final data = {'userid': 1, 'tenantid': 1};
      final mobileCodeList = await commonRepository.getCountryCodeList(data);

      if (mobileCodeList == null || mobileCodeList.isEmpty) {
        throw InvalidInputException(
          MobileCodeValidationMessage.notDefinedException,
        );
      }

      emit(MobileCodeFetched(mobileCodes: mobileCodeList));
    } catch (e) {
      emit(MobileCodeFailure(error: e.toString()));
    }
  }

  @override
  CommonState? fromJson(Map<String, dynamic> json) {
    try {
      if (json['mobileCodes'] != null) {
        final list = (json['mobileCodes'] as List<dynamic>)
            .map(
              (e) => CountryMobileCodesList.fromJson(e as Map<String, dynamic>),
            )
            .toList();
        return MobileCodeFetched(mobileCodes: list);
      }
      return CommonInitial();
    } catch (_) {
      return CommonInitial();
    }
  }

  @override
  Map<String, dynamic>? toJson(CommonState state) {
    if (state is MobileCodeFetched) {
      return {'mobileCodes': state.mobileCodes.map((e) => e.toJson()).toList()};
    }
    return null;
  }
}
