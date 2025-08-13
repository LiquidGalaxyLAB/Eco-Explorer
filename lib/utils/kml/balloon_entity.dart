import 'package:eco_explorer/constants/strings.dart';
import 'package:eco_explorer/models/fire/fire_model.dart';
import 'package:eco_explorer/models/forests_model.dart';
import 'package:eco_explorer/models/tour_model.dart';

class BalloonEntity{
  static String blankBalloon(String id) => '''
  <?xml version="1.0" encoding="UTF-8"?>
  <kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
  <Document id="id">
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
          <img src="$image" alt="picture" width="900" height="600" />
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
      Forest forest, IndividualTour place, double zoom, double tilt, double heading) =>
  '''
  <?xml version="1.0" encoding="UTF-8"?>
  <kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
  <Document>
   <name>About Data</name>
   <Style id="about_style">
     <BalloonStyle>
        <bgColor>ff101816</bgColor> 
        <textColor>ffffffff</textColor>
        <text><![CDATA[
          <div style="width: 400px; font-family: 'Segoe UI', sans-serif; background-color: #1f2937; color: #ffffff; border-radius: 12px; overflow: hidden; box-shadow: 0 10px 30px rgba(0,0,0,0.5); border: 1px solid #374151;">
            <div style="background-color: #2dd4bf; padding: 14px 20px;">
              <h2 style="margin: 0; font-size: 25px; font-weight: 700;">📍 ${place.name}l</h2>
            </div>
            <div style="padding: 20px; font-size: 20px; line-height: 1.6;">
              ${place.desc}
            </div>
            <div style="background-color: #111827; padding: 12px 20px; font-family: monospace; font-size: 13px; color: #d1d5db;">
              ${place.lat}, ${place.lon}
            </div>
          </div>
        ]]></text>
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
      Forest forest,
      List<FireInfo> fires,
      String image,
      double zoom,
      double tilt,
      double heading,
      ) {
    int night = 0;
    for (FireInfo fire in fires) {
      if (fire.dayNight == 'N') night++;
    }

    return '''
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2"
     xmlns:gx="http://www.google.com/kml/ext/2.2"
     xmlns:kml="http://www.opengis.net/kml/2.2"
     xmlns:atom="http://www.w3.org/2005/Atom">
  <Document>
    <name>Fire Overview</name>

    <Style id="about_style">
      <BalloonStyle>
        <bgColor>ff101816</bgColor>
        <textColor>ffffffff</textColor>
        <text><![CDATA[
          <div style="width: 500px; font-family: 'Segoe UI', sans-serif; background-color: #1f2937; color: #ffffff; border-radius: 12px; overflow: hidden; border: 1px solid #374151; box-shadow: 0 8px 20px rgba(0,0,0,0.5);">
            
            <div style="background-color: #0d9488; padding: 16px 20px;">
              <h2 style="margin: 0; font-size: 18px; font-weight: 700;">🔥 Fire Overview</h2>
            </div>

            <div style="padding: 16px 20px;">
              <p style="font-size: 14px;">Tap on any ongoing fire in the application for more details.</p>
              <img src="$image" alt="fire image" style="width:100%; height:auto; border-radius: 8px; margin-top: 10px;"/>
            </div>

            <div style="padding: 0 20px 20px 20px;">
              <table style="width:100%; border-collapse: collapse; font-size: 14px;">
                <tr>
                  <td style="padding: 8px; font-weight: bold;">Date</td>
                  <td style="padding: 8px;">${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}</td>
                </tr>
                <tr style="background-color: #374151;">
                  <td style="padding: 8px; font-weight: bold;">Active Fires</td>
                  <td style="padding: 8px;">${fires.length}</td>
                </tr>
                <tr>
                  <td style="padding: 8px; font-weight: bold;">Day / Night</td>
                  <td style="padding: 8px;">${fires.length - night} / $night</td>
                </tr>
                <tr style="background-color: #374151;">
                  <td style="padding: 8px; font-weight: bold;">Instrument</td>
                  <td style="padding: 8px;">VIIRS</td>
                </tr>
              </table>
            </div>

            <div style="background-color: #111827; padding: 12px 20px; font-family: monospace; font-size: 13px; color: #d1d5db;">
              Forest center: ${forest.lat}, ${forest.lon}
            </div>
          </div>
        ]]></text>
      </BalloonStyle>
    </Style>

    <Placemark id="ab">
      <description></description>
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

  static String zoomedFireBalloon(FireInfo fire, double zoom, double tilt, double heading) => '''
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2"
     xmlns:gx="http://www.google.com/kml/ext/2.2"
     xmlns:kml="http://www.opengis.net/kml/2.2"
     xmlns:atom="http://www.w3.org/2005/Atom">
  <Document>
    <name>Fire Info</name>
    
    <Style id="fire_style">
      <BalloonStyle>
        <bgColor>ff101816</bgColor> <!-- Dark background -->
        <textColor>ffffffff</textColor>
        <text><![CDATA[
          <div style="width: 420px; font-family: 'Segoe UI', sans-serif; background-color: #1f2937; color: #ffffff; border-radius: 12px; overflow: hidden; border: 1px solid #374151; box-shadow: 0 10px 30px rgba(0,0,0,0.5);">
            
            <div style="background-color: #0d9488; padding: 14px 20px;">
              <h2 style="margin: 0; font-size: 25px; font-weight: 700;">🔥 Fire Details</h2>
            </div>

            <div style="padding: 20px; font-size: 20px; line-height: 1.6;">
              <p><b>TI4 Brightness:</b> ${fire.bright_ti4}</p>
              <p><b>TI5 Brightness:</b> ${fire.bright_ti5}</p>
            </div>

            <div style="background-color: #111827; padding: 12px 20px; font-family: monospace; font-size: 13px; color: #d1d5db;">
              Coordinates: ${fire.lat}°, ${fire.lon}°
            </div>
          </div>
        ]]></text>
      </BalloonStyle>
    </Style>

    <Placemark id="fire_marker">
      <description></description>
      <LookAt>
        <longitude>${fire.lon}</longitude>
        <latitude>${fire.lat}</latitude>
        <heading>$heading</heading>
        <tilt>$tilt</tilt>
        <range>$zoom</range>
      </LookAt>
      <styleUrl>#fire_style</styleUrl>
      <gx:balloonVisibility>1</gx:balloonVisibility>
      <Point>
        <coordinates>${fire.lon},${fire.lat},0</coordinates>
      </Point>
    </Placemark>
  </Document>
</kml>
''';


  static String aqiBalloon(
      Forest forest, double zoom, double tilt, double heading, double ratio
      )=>'''
  <?xml version="1.0" encoding="UTF-8"?>
  <kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
  <Document>
  <name>AQI Data</name>
  <Style id="aqi_style">
   <BalloonStyle>
     <textColor>ffffffff</textColor>
     <text>
      <h1>${forest.name}</h1>
      <img src="file://${Constants.remoteFile}${forest.path}_${Constants.dataFile}.png" alt="picture" width="400" height="${400*ratio}" />
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
          <img src="$image" alt="picture" width="600"/>
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

      Forest forest, String link, double ratio, double zoom, double tilt, double heading,int year)=>'''
  <?xml version="1.0" encoding="UTF-8"?>
  <kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
  <Document>
  <name>AQI Data</name>
  <Style id="aqi_style">
   <BalloonStyle>
     <textColor>ffffffff</textColor>
     <text>
      <h1>Deforestation Magnitude</h1>
      <h1>Year: $year</h1>
      <img src="$link" alt="picture" width="1000" height="${1000*ratio}" />
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