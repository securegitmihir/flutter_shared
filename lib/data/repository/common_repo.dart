import '../data_provider/common_dp.dart';
import '../models/country_code_model.dart';

class CommonRepository {
  final CommonDataProvider commonDataProvider;

  CommonRepository(this.commonDataProvider);

  Future<List<CountryMobileCodesList>?> getCountryCodeList(data) async {
    try {
      // final countryCodeData = await commonDataProvider.getCountryCodeList(data);
      // if (countryCodeData['isSuccess'] == false) {
      //   throw SomethingWentWrongException('');
      // }
      // return CountryCodeModel
      //     .fromJson(countryCodeData)
      //     .d!
      //     .rD!
      //     .countryMobilecodesList;
      return [
        CountryMobileCodesList(
          id: 1,
          countryCode: "+91",
          shortcode: "Ind",
          numberLength: 10,
        ),
        CountryMobileCodesList(
          id: 2,
          countryCode: "+1",
          shortcode: "USA",
          numberLength: 10,
        ),
        CountryMobileCodesList(
          id: 3,
          countryCode: "+44",
          shortcode: "UK",
          numberLength: 11,
        ),
      ];
    } catch (e) {
      rethrow;
    }
  }
}
