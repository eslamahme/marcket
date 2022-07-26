
import'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class Auth with ChangeNotifier{
  String? _token;
  DateTime ?_expiryDate;
  String? _userId;
  Timer? _authTimer;
  bool get isAuth{
    return token!=null;
  }
  String? get token{
    if(_expiryDate !=null && _expiryDate!.isAfter(DateTime.now())&&_token!=null){
      return _token;
    }
    return null;
  }
  String? get userId{
    return _userId!;
  }
  Future<void> _authenticate(String email,String password,String urlSegment)async {
    final  url='https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCeV6gBUsxL2VkJQZcdtIq0vt6F_aOPmLc';
    try{
      final res = await http.post(Uri.parse(url),body: json.encode({
        'email':email,
        'password':password,
        'returnSecureToken':true,
      }));

      final responseData=json.decode(res.body);
      if(responseData['error']!=null){
        throw  HttpException(responseData['error']['message']);
      }
      _token=responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate=DateTime.now().add(Duration(seconds:int.parse(responseData['expiresIn']) ));
      _autoLogOut();
      notifyListeners();
      final prefs=await SharedPreferences.getInstance();
      String userData=json.encode({
        'token':_token,
        'userId':_userId,
        'expiryDate':_expiryDate.toString(),
      });
      prefs.setString('userData',userData);
    }catch(e){
      rethrow;

    }
  }
  Future<void> signUp(String email,String password)async{
    return _authenticate(email, password, 'signUp');
  }
  Future<void> logIn(String email,String password)async{
    return _authenticate(email, password, 'signInWithPassword');
  }
  Future<bool> tryAutoLogin()async{
    final prefs= await SharedPreferences.getInstance();
    if(!prefs.containsKey('userData')){
      return false;
    }
    final extractData=json.decode(prefs.getString('userData')!) as Map<String,Object>;
    final expiryDate=DateTime.parse(extractData['expiryDate'].toString());
    if(expiryDate.isBefore(DateTime.now())){
      return false;
    }
    _token = extractData['token'].toString();
    _userId = extractData['userId'].toString();
    _expiryDate= expiryDate;
    notifyListeners();
    _autoLogOut();
    return true;
  }
  Future<void> logOut()async{
    _token = null;
    _userId=null;
    _expiryDate=null;
    if(_authTimer!= null){
      _authTimer!.cancel();
      _authTimer= null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
  void _autoLogOut(){
    if(_authTimer!= null){
      _authTimer!.cancel();
    }
    final timeExpiry=_expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeExpiry), logOut);
  }


}