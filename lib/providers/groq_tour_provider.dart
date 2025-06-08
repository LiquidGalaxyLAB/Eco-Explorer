import 'package:groq/groq.dart';

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
  late Groq groq = Groq(
  apiKey: Constants.groqApiKey,
  model: "gemma2-9b-it",
  );

  Future<String> getTour(String forest, double lat, double lon) async{

    groq.setCustomInstructionsWith('''
      Create the output in JSON format only.
      It should have the structure as: 
      $jsonStruct
      Include 5 locations.
      The first location must be:
      lat: $lat, lon: $lon, name: $forest, desc: (A small overall forest description).
      Ensure proper escaping (\\, \\n, space) so it can be parsed by Flutter JSON decoder.
      '''
    );

    groq.startChat();

    GroqResponse response = await groq.sendMessage('Design a tour for $forest');

    return response.choices.first.message.content;
  }
}