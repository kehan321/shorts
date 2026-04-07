import 'package:flutter_bloc/flutter_bloc.dart';

import '/data/models/local/local_user_info_store_model.dart';

class LoginDataSources extends Cubit<LocalUserInfoStoreModel> {
  LoginDataSources() : super(LocalUserInfoStoreModel.empty().copyWith());
  setLoginDataSources(
          {required LocalUserInfoStoreModel localUserInfoStoreModel}) =>
      emit(localUserInfoStoreModel);
}





