import 'package:eco_explorer/constants/theme.dart';
import 'package:eco_explorer/widgets/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groq/groq.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/strings.dart';

String jsonStruct = '''{
  "locations": [
    {
      "lat": "latitude as string",
      "lon": "longitude as string",
      "name": "name of location",
      "desc": "description of location"
    },
    ...
  ]
}''';

class GroqTourProvider{

  Future<String?> getTour(String forest, String mode, BuildContext context) async{

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final groqApiKey = prefs.getString('groqApiKey');

    if(groqApiKey == null) throw 'Invalid API Key';

    Groq groq = Groq(
      // apiKey: Constants.groqApiKey,
      apiKey: groqApiKey,
      model: "gemma2-9b-it",
    );

    try{
      groq.startChat();

      groq.setCustomInstructionsWith('''
      Create the output in JSON format only.
      Avoid ```
      It should have the structure as: 
      $jsonStruct
      Include 5 locations. Ensure the accuracy of the coordinates.
      Ensure proper escaping (\\, \\n, space) so it can be parsed by Flutter JSON decoder.
      The descriptions should be in a paragraph format(each entry when spoken should last for around 15 seconds), in $mode mode.
      '''
      );

      GroqResponse response = await groq.sendMessage('Act as a tour planner and design a tour for $forest');

      return response.choices.first.message.content;

    }on GroqException {
      // showSnackBar(context, e.toString(), Themes.error);
      rethrow;
      return null;
    }
  }
}