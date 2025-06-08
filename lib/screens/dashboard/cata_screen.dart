import 'dart:io';

import 'package:eco_explorer/constants/fonts.dart';
import 'package:eco_explorer/constants/strings.dart';
import 'package:eco_explorer/constants/theme.dart';
import 'package:eco_explorer/events/fire_event.dart';
import 'package:eco_explorer/models/fire/fire_model.dart';
import 'package:eco_explorer/utils/kml/balloon_entity.dart';
import 'package:eco_explorer/utils/kml/kml_entity.dart';
import 'package:eco_explorer/widgets/primary_button.dart';
import 'package:eco_explorer/widgets/snackbar.dart';
import 'package:eco_explorer/widgets/theme_card.dart';
import 'package:eco_explorer/widgets/theme_dialog_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/fire_bloc.dart';
import '../../models/forests_model.dart';
import '../../states/api_state.dart';
import '../../utils/connection/ssh.dart';

class CataScreen extends StatefulWidget {
  final Forest forest;
  final Ssh ssh;
  const CataScreen({super.key, required this.forest, required this.ssh});

  @override
  State<CataScreen> createState() => _CataScreenState();
}

class _CataScreenState extends State<CataScreen> {
  late Ssh ssh;

  @override
  void initState() {
    super.initState();
    ssh = widget.ssh;
  }

  @override
  Widget build(BuildContext context) {
    int range = 1;
    bool isLoading = false;

    String filename = '${widget.forest.name}_fires';

    return Column(
    );
  }
}
