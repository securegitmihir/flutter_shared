import '../../utilities/app_exception.dart';
import '../data_provider/var_customer_dp.dart';
import '../models/login_response_model.dart';
import '../models/validate_mobile_no_model.dart';

class VarCustomerRepository {
  final VarCustomerDataProvider varCustomerDataProvider;

  VarCustomerRepository(this.varCustomerDataProvider);

  Future<ValidationResponse> validateCustomerMobile(data) async {
    // Future<ValidationResponse> validateCustomerMobile(data) async {
    try {
      // final validateCustomerMobileResponse = await varCustomerDataProvider.validateCustomerMobile(data);
      // if (validateCustomerMobileResponse['isSuccess'] == false) {
      //   throw SomethingWentWrongException('');
      // }
      //
      // return ValidateVarMobileModel.fromJson(validateCustomerMobileResponse).d!.rD!.response!;
      if (data['loginid'] == "9999999999") {
        return ValidationResponse(isValid: true, alreadyRegistered: false);
      }
      return ValidationResponse(isValid: false, alreadyRegistered: false);
    } catch (e) {
      rethrow;
    }
  }
}
