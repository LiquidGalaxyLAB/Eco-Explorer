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
          <h2>TI4 Area: ${forest.area}</h2>
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
}