import 'package:eco_explorer/constants/fonts.dart';
import 'package:eco_explorer/constants/theme.dart';
import 'package:eco_explorer/models/forests_model.dart';
import 'package:eco_explorer/widgets/secondary_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/strings.dart';
import '../../providers/groq_tour_provider.dart';
import '../../utils/connection/ssh.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/snackbar.dart';
import '../../widgets/theme_card.dart';
import '../../widgets/theme_dialog_box.dart';

class InfoScreen extends StatefulWidget {
  final Forest forest;
  final Ssh ssh;
  const InfoScreen({super.key, required this.forest, required this.ssh});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  String mode = 'Story';
  bool light = true;
  double value = 0;
  String loadingText = 'Generating Tour';

  OverlayEntry? entry;
  late Ssh ssh;

  @override
  void initState() {
    super.initState();
    ssh = widget.ssh;
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    Forest forest = widget.forest;

    return Column(

    );
  }

}
