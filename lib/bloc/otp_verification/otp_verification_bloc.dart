import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repository/otp_verification_repo.dart';
import '../../services/validation_function.dart';
import '../../services/network_api_service.dart';

part 'otp_verification_event.dart';
part 'otp_verification_state.dart';

class OtpVerificationBloc
    extends Bloc<OtpVerificationEvent, OtpVerificationState> {
  Timer? _timer;
  OTPVerificationRepository otpVerificationRepository;

  OtpVerificationBloc(this.otpVerificationRepository)
    : super(
        const OtpVerificationInitial(
          resendOtpLoading: false,
          resendOtpSuccess: true,
        ),
      ) {
    on<VerifyButtonClicked>(_onVerifyButtonClicked);
    on<OTPEntered>(_onOtpEntered);
    on<Tick>(_onTick);
    on<StartTimer>(_onStartTimer);
    on<ResendOTPClicked>(_onResendOTPClicked);
    on<SetNewOTPEvent>(_onSetNewOTPEvent);
    on<ResetEvent>(_onResetEvent);
  }

  void _onVerifyButtonClicked(
    VerifyButtonClicked event,
    Emitter<OtpVerificationState> emit,
  ) {
    final state = this.state;

    if (state.actualOtp == event.enteredOtp) {
      emit(const OtpVerificationSuccessful(otpMatched: true));
    } else {
      emit(
        OtpVerificationFailed(
          isOtpValid: state.isOtpValid,
          enteredOtp: state.enteredOtp,
          otpMatched: false,
          duration: state.duration,
          resendOtpLoading: state.resendOtpLoading,
          resendOtpSuccess: state.resendOtpSuccess,
          actualOtp: state.actualOtp,
        ),
      );
    }
  }

  void _onOtpEntered(OTPEntered event, Emitter<OtpVerificationState> emit) {
    final state = this.state;
    emit(
      OtpVerificationState(
        actualOtp: state.actualOtp,
        isOtpValid: ValidationFunctions.isOtpValid(event.enteredOtp),
        enteredOtp: event.enteredOtp,
        otpMatched: ValidationFunctions.isOtpValid(event.enteredOtp),
        duration: state.duration,
        resendOtpLoading: state.resendOtpLoading,
        resendOtpSuccess: state.resendOtpSuccess,
      ),
    );
  }

  void _onTick(Tick event, Emitter<OtpVerificationState> emit) {
    final state = this.state;
    if (event.duration > 0) {
      emit(
        OtpVerificationState(
          isOtpValid: state.isOtpValid,
          enteredOtp: state.enteredOtp,
          otpMatched: state.otpMatched,
          actualOtp: state.actualOtp,
          duration: event.duration,
          resendOtpLoading: state.resendOtpLoading,
          resendOtpSuccess: state.resendOtpSuccess,
        ),
      );
    } else {
      _timer?.cancel();
      emit(
        OtpVerificationState(
          isOtpValid: state.isOtpValid,
          enteredOtp: state.enteredOtp,
          otpMatched: state.otpMatched,
          actualOtp: state.actualOtp,
          duration: 0,
          resendOtpLoading: state.resendOtpLoading,
          resendOtpSuccess: state.resendOtpSuccess,
        ),
      );
    }
  }

  void _onStartTimer(StartTimer event, Emitter<OtpVerificationState> emit) {
    _timer?.cancel();
    add(Tick(duration: event.time));
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      add(Tick(duration: event.time - timer.tick));
    });
  }

  void _onResendOTPClicked(
    ResendOTPClicked event,
    Emitter<OtpVerificationState> emit,
  ) async {
    final state = this.state;

    /// to handle the erro not clearning issue and other related issues with the otp resend
    emit(
      OtpVerificationState(
        // isOtpValid: state.isOtpValid,
        // enteredOtp: state.enteredOtp,
        // otpMatched: state.otpMatched,
        enteredOtp: '',
        isOtpValid: false,
        otpMatched: false,
        duration: state.duration,
        actualOtp: state.actualOtp,
        resendOtpLoading: true,
        resendOtpSuccess: state.resendOtpSuccess,
      ),
    );
    try {
      final otpResponse = await otpVerificationRepository.getOTP(
        int.tryParse(event.enteredMobileNumber),
      );
      // await showNotification("OTP Received", otpResponse);
      /// to handle the erro not clearning issue and other related issues with the otp resend
      if (otpResponse == null || otpResponse.toString().isEmpty) {
        emit(
          GetOTPFailure(
            error: "exceptions.somethingWentWrongExceptionMsg".tr(),
          ),
        );
      } else {
        emit(
          OtpResendSuccess(
            // isOtpValid: state.isOtpValid,
            // enteredOtp: '',
            // otpMatched: state.otpMatched,
            enteredOtp: '',
            isOtpValid: false,
            otpMatched: false,
            duration: state.duration,
            actualOtp: otpResponse,
            resendOtpLoading: false,
            resendOtpSuccess: true,
          ),
        );
        add(StartTimer(time: event.time));
      }
    } catch (e) {
      emit(GetOTPFailure(error: e.toString()));

      /// to handle the erro not clearning issue and other related issues with the otp resend
      emit(
        OtpVerificationState(
          enteredOtp: '',
          isOtpValid: false,
          otpMatched: false,
          // enteredOtp: state.enteredOtp,
          //isOtpValid: state.isOtpValid,
          // otpMatched: state.otpMatched,
          duration: state.duration,
          actualOtp: state.actualOtp,
          resendOtpLoading: false,
          resendOtpSuccess: false,
        ),
      );
    }
  }

  void _onSetNewOTPEvent(
    SetNewOTPEvent event,
    Emitter<OtpVerificationState> emit,
  ) {
    emit(
      OtpVerificationState(
        actualOtp: event.otp,
        isOtpValid: state.isOtpValid,
        enteredOtp: state.enteredOtp,
        otpMatched: state.otpMatched,
        duration: state.duration,
        resendOtpLoading: state.resendOtpLoading,
        resendOtpSuccess: state.resendOtpSuccess,
      ),
    );
  }

  void _onResetEvent(ResetEvent event, Emitter<OtpVerificationState> emit) {
    emit(
      const OtpVerificationInitial(
        resendOtpLoading: false,
        resendOtpSuccess: true,
      ),
    );
  }
}
