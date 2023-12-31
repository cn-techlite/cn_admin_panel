import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../model/login_response_model.dart';
import '../utils/constants.dart';
import '../utils/package_export.dart';
import 'endpoints.dart';

final GetIt getIt = GetIt.instance;

class AppGlobals {
  factory AppGlobals() => instance;

  AppGlobals._();

  static final AppGlobals instance = AppGlobals._();

  String? isLoggedIn;
  int? isViewed;
  StopWatchTimer? stopWatchTimer;
  String? token = "";
  String? userId = "";
  String? userEmail = "";
  String? userPassword = "";

  Future<void> init() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = await getFromLocalStorage(name: "token") ?? "";
    userId = await getFromLocalStorage(name: "userId") ?? "";
    userEmail = await getFromLocalStorage(name: "userEmail") ?? "";
    userPassword = await getFromLocalStorage(name: "userPassword") ?? "";

    isViewed = preferences.getInt('onBoard');
    isLoggedIn = preferences.getString('isLoggedIn') ?? "";
    printData("token", token);
    printData("UserId", userId);
    printData("userEmail", userEmail);
    printData("isLoggedIn", isLoggedIn);
  }

  Future<void> login() async {
    String url = Endpoints.usersLoginUrl;
    var stingUrl = Uri.parse(Endpoints.baseUrl + url);
    String userPassword = await getFromLocalStorage(name: "userPassword") ?? "";
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      final msg = jsonEncode({
        "email": userEmail,
        "password": userPassword,
      });
      http.Response response =
          await http.post(stingUrl, body: msg, headers: headers);
      printData("dataResponse", response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        LoginResponseModel loginResponseModel =
            LoginResponseModel.fromJson(jsonDecode(response.body));
        setToLocalStorage(name: "token", data: loginResponseModel.token);
        setToLocalStorage(name: "userEmail", data: loginResponseModel.email);
        setToLocalStorage(name: "userId", data: loginResponseModel.userId);
        printData("verify", loginResponseModel.email);
        token = await getFromLocalStorage(name: "token") ?? "";
        printData("token", token);
        await init();
        //navigateToRoute(cxt, Ta)
      } else {
        printData("errors", response.body);
        printData("Error", response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  void dispose() {}
}

AppGlobals globals = getIt.get<AppGlobals>();
