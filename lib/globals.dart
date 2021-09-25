
import 'dart:ui';

import 'package:DepoSms/services/database_service.dart';
import 'package:flutter/material.dart';

final dbHelper = DatabaseHelper.instance;

Map<int, Color> color =
{
  50:Color.fromRGBO(63,18,114, .1),
  100:Color.fromRGBO(63,18,114, .2),
  200:Color.fromRGBO(63,18,114, .3),
  300:Color.fromRGBO(63,18,114, .4),
  400:Color.fromRGBO(63,18,114, .5),
  500:Color.fromRGBO(63,18,114, .6),
  600:Color.fromRGBO(63,18,114, .7),
  700:Color.fromRGBO(63,18,114, .8),
  800:Color.fromRGBO(63,18,114, .9),
  900:Color.fromRGBO(63,18,114, 1),
};

MaterialColor colorCustom = MaterialColor(0xff3f1272, color);