import 'package:eco_explorer/constants/strings.dart';
import 'package:eco_explorer/models/fire/fire_model.dart';
import 'package:eco_explorer/models/forests_model.dart';

class BalloonEntity{
  static String blankBalloon() => '''
  <?xml version="1.0" encoding="UTF-8"?>
  <kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
  <Document>
   <name>None</name>
   <Style id="blank">
     <BalloonStyle>
       <textColor>ffffffff</textColor>
       <text></text>
       <bgColor>ff101816</bgColor>
     </BalloonStyle>
   </Style>
   <Placemark id="blank">
     <description></description>
     <styleUrl>#blank</styleUrl>
     <gx:balloonVisibility>0</gx:balloonVisibility>
     <Point>
       <coordinates>0,0,0</coordinates>
     </Point>
   </Placemark>
  </Document>
  </kml>''';

  static String orbitBalloon(
      Forest forest, String image, double zoom, double tilt, double heading) =>
      '''
  <?xml version="1.0" encoding="UTF-8"?>
  <kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
  <Document>
   <name>About Data</name>
   <Style id="about_style">
     <BalloonStyle>
       <textColor>ffffffff</textColor>
       <text>
        <![CDATA[
          <h1>${forest.name}</h1>
          <img src="$image" alt="picture" width="300" height="200" />
          <h2>Latitude: ${forest.lat}</h2>
          <h2>Longitude: ${forest.lon}</h2>
          <h2>Area: ${forest.area}</h2>
          <h2>Ecosystem: ${forest.ecosystem}</h2>
        ]]>
       </text>
       <bgColor>ff101816</bgColor>
     </BalloonStyle>
   </Style>
   <Placemark id="ab">
     <description>
     </description>
     <LookAt>
       <longitude>${forest.lon}</longitude>
       <latitude>${forest.lat}</latitude>
       <heading>$heading</heading>
       <tilt>$tilt</tilt>
       <range>$zoom</range>
     </LookAt>
     <styleUrl>#about_style</styleUrl>
     <gx:balloonVisibility>1</gx:balloonVisibility>
     <Point>
       <coordinates>${forest.lon},${forest.lat},0</coordinates>
     </Point>
   </Placemark>
  </Document>
  </kml>''';

  static String tourBalloon(
      Forest forest, String place, double zoom, double tilt, double heading) =>
      '''
  <?xml version="1.0" encoding="UTF-8"?>
  <kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
  <Document>
   <name>About Data</name>
   <Style id="about_style">
     <BalloonStyle>
       <textColor>ffffffff</textColor>
       <text>
        <![CDATA[
          <h1>$place</h1>
        ]]>
       </text>
       <bgColor>ff101816</bgColor>
     </BalloonStyle>
   </Style>
   <Placemark id="ab">
     <description>
     </description>
     <LookAt>
       <longitude>${forest.lon}</longitude>
       <latitude>${forest.lat}</latitude>
       <heading>$heading</heading>
       <tilt>$tilt</tilt>
       <range>$zoom</range>
     </LookAt>
     <styleUrl>#about_style</styleUrl>
     <gx:balloonVisibility>1</gx:balloonVisibility>
     <Point>
       <coordinates>${forest.lon},${forest.lat},0</coordinates>
     </Point>
   </Placemark>
  </Document>
  </kml>''';

  static String fireBalloon(
      Forest forest, List<FireInfo> fires, String image, double zoom, double tilt, double heading) {
    int night = 0;

    for(FireInfo fire in fires){
      if(fire.dayNight == 'N') {
        night++;
      }
    }
    return '''
    <?xml version="1.0" encoding="UTF-8"?>
    <kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
    <Document>
     <name>About Data</name>
     <Style id="about_style">
       <BalloonStyle>
         <textColor>ffffffff</textColor>
         <text>
          <h1>Tap on any ongoing fire in application for more details</h1>
          <img src="$image" alt="picture" width="300" height="200" />
          <table border="1" cellpadding="4" cellspacing="0" style="border-collapse: collapse;">
            <tr>
              <th>Date</th>
              <th>${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}</th>
            </tr>
            <tr>
              <td>Active fires</td>
              <td>${fires.length}</td>
            </tr>
            <tr>
              <td>Day/Night</td>
              <td>${fires.length - night}/$night</td>
            </tr>
            <tr>
              <td>Instrument</td>
              <td>VIIRS</td>
            </tr>
          </table>
         </text>
         <bgColor>ff101816</bgColor>
       </BalloonStyle>
     </Style>
     <Placemark id="ab">
       <description>
       </description>
       <LookAt>
         <longitude>${forest.lon}</longitude>
         <latitude>${forest.lat}</latitude>
         <heading>$heading</heading>
         <tilt>$tilt</tilt>
         <range>$zoom</range>
       </LookAt>
       <styleUrl>#about_style</styleUrl>
       <gx:balloonVisibility>1</gx:balloonVisibility>
       <Point>
         <coordinates>${forest.lon},${forest.lat},0</coordinates>
       </Point>
     </Placemark>
    </Document>
    </kml>
    ''';
  }

  static String zoomedFireBalloon(FireInfo fire,double zoom, double tilt, double heading)=>'''
  <?xml version="1.0" encoding="UTF-8"?>
  <kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
  <Document>
  <name>About Data</name>
  <Style id="about_style">
   <BalloonStyle>
     <textColor>ffffffff</textColor>
     <text>
      <![CDATA[
        <h1>Fire Details</h1>
        <h2>Latitude: ${fire.lat}</h2>
        <h2>Longitude: ${fire.lon}</h2>
        <h2>TI4 Brightness: ${fire.bright_ti4}</h2>
        <h2>TI5 Brightness: ${fire.bright_ti5}</h2>
       ]]>
     </text>
     <bgColor>ff101816</bgColor>
   </BalloonStyle>
  </Style>
  <Placemark id="ab">
   <description>
   </description>
   <LookAt>
     <longitude>${fire.lon}</longitude>
     <latitude>${fire.lat}</latitude>
     <heading>$heading</heading>
     <tilt>$tilt</tilt>
     <range>$zoom</range>
   </LookAt>
   <styleUrl>#about_style</styleUrl>
   <gx:balloonVisibility>1</gx:balloonVisibility>
   <Point>
     <coordinates>${fire.lon},${fire.lat},0</coordinates>
   </Point>
  </Placemark>
  </Document>
  </kml>
  ''';

  static String speciesBalloon(
      Species species, Forest forest, String image, double zoom, double tilt, double heading) =>
      '''
  <?xml version="1.0" encoding="UTF-8"?>
  <kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
  <Document>
   <name>About Data</name>
   <Style id="about_style">
     <BalloonStyle>
       <textColor>ffffffff</textColor>
       <text>
        <![CDATA[
          <h1>${species.name}</h1>
          <img src="$image" alt="picture" width="300" height="200" />
          <h2>Scientific name: ${species.sci_name}</h2>
        ]]>
       </text>
       <bgColor>ff101816</bgColor>
     </BalloonStyle>
   </Style>
   <Placemark id="ab">
     <description>
     </description>
     <LookAt>
       <longitude>${forest.lon}</longitude>
       <latitude>${forest.lat}</latitude>
       <heading>$heading</heading>
       <tilt>$tilt</tilt>
       <range>$zoom</range>
     </LookAt>
     <styleUrl>#about_style</styleUrl>
     <gx:balloonVisibility>1</gx:balloonVisibility>
     <Point>
       <coordinates>${forest.lon},${forest.lat},0</coordinates>
     </Point>
   </Placemark>
  </Document>
  </kml>''';

  static String forestCoverIndicatorBalloon(

      Forest forest, String link, double ratio, double zoom, double tilt, double heading)=>'''
  <?xml version="1.0" encoding="UTF-8"?>
  <kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
  <Document>
  <name>AQI Data</name>
  <Style id="aqi_style">
   <BalloonStyle>
     <textColor>ffffffff</textColor>
     <text>
      <h1>Deforestation Magnitude</h1>
      <img src="$link" alt="picture" width="400" height="${400*ratio}" />
     </text>
     <bgColor>ff101816</bgColor>
   </BalloonStyle>
  </Style>
  <Placemark id="ab">
   <description>
   </description>
   <LookAt>
     <longitude>${forest.lon}</longitude>
     <latitude>${forest.lat}</latitude>
     <heading>$heading</heading>
     <tilt>$tilt</tilt>
     <range>$zoom</range>
   </LookAt>
   <styleUrl>#aqi_style</styleUrl>
   <gx:balloonVisibility>1</gx:balloonVisibility>
   <Point>
     <coordinates>${forest.lon},${forest.lat},0</coordinates>
   </Point>
  </Placemark>
  </Document>
  </kml>
  ''';
}