import 'package:eco_explorer/constants/strings.dart';
import 'package:eco_explorer/models/forests_model.dart';
import 'package:eco_explorer/utils/kml/look_at_entity.dart';
import 'package:eco_explorer/utils/kml/noise_polygon_generator.dart';
import 'package:eco_explorer/models/tour_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/deforestation_data_model.dart';
import '../../models/fire/fire_model.dart';
import '../../ref/instance_provider.dart';
import '../connection/ssh.dart';
import 'balloon_entity.dart';

class KmlEntity{
  static String getKmlSkeleton(String content, String name)=>'''
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
<Document>
  <name>$name</name>
    $content
</Document>
</kml>
  ''';
  static String screenOverlayImage(String imageUrl, double factor) =>
      getKmlSkeleton('''
      <name>tags</name>
      <Style>
        <ListStyle>
          <listItemType>checkHideChildren</listItemType>
          <bgColor>00ffffff</bgColor>
          <maxSnippetLines>2</maxSnippetLines>
        </ListStyle>
      </Style>
      <ScreenOverlay id="123">
        <name>EcoExplorer</name>
        <Icon>
          <href>$imageUrl</href>
        </Icon>
        <overlayXY x="0" y="1" xunits="fraction" yunits="fraction"/>
        <screenXY x="0.025" y="0.95" xunits="fraction" yunits="fraction"/>
        <rotationXY x="0" y="0" xunits="fraction" yunits="fraction"/>
        <size x="${554}" y="${(554 * factor)}" xunits="pixels" yunits="pixels"/>
      </ScreenOverlay>
      ''', 'EcoExplorer');
  //
  // '''
  // <?xml version="1.0" encoding="UTF-8"?>
  // <kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
  // <Document>
  //   <name>EcoExplorer</name>
  //   <open>1</open>
  //   <Folder>
  //     <name>tags</name>
  //     <Style>
  //       <ListStyle>
  //         <listItemType>checkHideChildren</listItemType>
  //         <bgColor>00ffffff</bgColor>
  //         <maxSnippetLines>2</maxSnippetLines>
  //       </ListStyle>
  //     </Style>
  //     <ScreenOverlay id="123">
  //       <name>EcoExplorer</name>
  //       <Icon>
  //         <href>$imageUrl</href>
  //       </Icon>
  //       <overlayXY x="0" y="1" xunits="fraction" yunits="fraction"/>
  //       <screenXY x="0.025" y="0.95" xunits="fraction" yunits="fraction"/>
  //       <rotationXY x="0" y="0" xunits="fraction" yunits="fraction"/>
  //       <size x="${300}" y="${(300 * factor)}" xunits="pixels" yunits="pixels"/>
  //     </ScreenOverlay>
  //   </Folder>
  // </Document>
  // </kml>
  // ''';

  static String generateBlank(String id) => '''
    <?xml version="1.0" encoding="UTF-8"?>
    <kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
      <Document id="$id">
      </Document>
    </kml>
    ''';

  static String buildOrbit(double lat, double lon){
    String lookAts = '';

    for (int i=0;i<=360;i+=10) {
      lookAts += '''
      <gx:FlyTo>
              <gx:duration>1.2</gx:duration>
              <gx:flyToMode>smooth</gx:flyToMode>
              <LookAt>
                  <longitude>$lon</longitude>
                  <latitude>$lat</latitude>
                  <heading>${i.toDouble()}</heading>
                  <tilt>60</tilt>
                  <range>40000</range>
                  <gx:fovy>60</gx:fovy> 
                  <altitude>3341.7995674</altitude> 
                  <gx:altitudeMode>absolute</gx:altitudeMode>
              </LookAt>
            </gx:FlyTo>
''';
    }

    return '''<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
   <gx:Tour>
   <name>Orbit</name>
      <gx:Playlist>
         $lookAts
      </gx:Playlist>
   </gx:Tour>
</kml>''';
  }

  static Future<String> buildForestTour(TourModel model) async {
    String lookAts = '';

    for (var location in model.locations) {

      // await ssh.sendKmltoSlave(context, BalloonEntity.tourBalloon(ref.read(forestProvider.notifier).state!, location.name, Constants.orbitScale, 0, 0), Constants.rightRig(ssh.rigCount()));

      lookAts += '''<gx:FlyTo>
  <gx:duration>1.2</gx:duration>
  <gx:flyToMode>bounce</gx:flyToMode>
  <longitude>${location.lon}</longitude>
  <latitude>${location.lat}</latitude>
  <heading>0</heading>
  <tilt>60</tilt>
  <range>40000</range>
  <gx:fovy>60</gx:fovy> 
  <altitude>3341.7995674</altitude> 
  <gx:altitudeMode>absolute</gx:altitudeMode>
</gx:FlyTo>
''';
      for (int i=0;i<=360;i+=10) {
        lookAts += '''<gx:FlyTo>
  <gx:duration>1.2</gx:duration>
  <gx:flyToMode>smooth</gx:flyToMode>
  <LookAt>
      <longitude>${location.lon}</longitude>
      <latitude>${location.lat}</latitude>
      <heading>${i.toDouble()}</heading>
      <tilt>60</tilt>
      <range>40000</range>
      <gx:fovy>60</gx:fovy> 
      <altitude>3341.7995674</altitude> 
      <gx:altitudeMode>absolute</gx:altitudeMode>
  </LookAt>
</gx:FlyTo>
''';
      }
    }

    return '''<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
   <gx:Tour>
   <name>Orbit</name>
      <gx:Playlist>
         $lookAts
      </gx:Playlist>
   </gx:Tour>
</kml>''';
  }

  static String getFirePlacemark(int id,double lat, double lon, String style)=>'''
      <Placemark>
        <styleUrl>$style</styleUrl>
        <Point>
          <coordinates>$lon,$lat,0</coordinates>
        </Point>
      </Placemark>
      ''';

  static String getFireKml(List<FireInfo> fires){

    String firePlacemarks = '';
    for(int i = 0; i < fires.length; i++){

      final ti4 = fires[i].bright_ti4;
      final ti5 = fires[i].bright_ti5;
      final delta = ti4 - ti5;

      String fireStyle =
      (delta >= 100 || ti4 >= 360) ? '#high' : (delta >= 50 || ti4 >= 330) ? '#med' : '#low';

      firePlacemarks += getFirePlacemark(i, fires[i].lat, fires[i].lon, fireStyle);
    }

    return getKmlSkeleton('''
<Style id="low">
  <IconStyle>
    <scale>2</scale>
    <Icon>
      <href>${Constants.low}</href>
    </Icon>
  </IconStyle>
</Style>

<Style id="med">
  <IconStyle>
    <scale>2.5</scale>
    <Icon>
      <href>${Constants.med}</href>
    </Icon>
  </IconStyle>
</Style>

<Style id="high">
  <IconStyle>
    <scale>3</scale>
    <Icon>
      <href>${Constants.high}</href>
    </Icon>
  </IconStyle>
</Style>
      
$firePlacemarks
    ''', 'Recent fires');
  }

  static String getZoomedFireKml(FireInfo fire){

    final ti4 = fire.bright_ti4;
    final ti5 = fire.bright_ti5;
    final delta = ti4 - ti5;

    final clampedDelta = delta.clamp(0.0, 80.0);

    final radiusMean = 0.05 + (clampedDelta / 1000.0) * (0.3 - 0.05);

    NoisePolygonGenerator noise = NoisePolygonGenerator(
        numVertices: (2*delta).floor() + 1,
        radiusMean: radiusMean,
        // noiseScale: 0.25,
        noiseAmplitude: radiusMean*2/3
    );

    double lat = fire.lat;
    double lon = fire.lon;

    List<LatLng> points = noise.createPolygon(lat, lon);

    String pointsString = '';
    for(int i = 0; i < points.length; i++){
      pointsString += '''${points[i].longitude},${points[i].latitude},0 ''';
    }
    print(pointsString);

    String border =
    (delta >= 100 || ti4 >= 360) ? 'ff0000ff' : (delta >= 50 || ti4 >= 330) ? 'ff006efa' : 'ff00e3ec';
    String fill =
    (delta >= 100 || ti4 >= 360) ? '660070fa' : (delta >= 50 || ti4 >= 330) ? '6633fff3' : '66bcede8';

    return getKmlSkeleton('''
<StyleMap id="firePolygon">
<Pair>
  <key>normal</key>
  <styleUrl>#sn_ylw-pushpin</styleUrl>
</Pair>
<Pair>
  <key>highlight</key>
  <styleUrl>#sh_ylw-pushpin</styleUrl>
</Pair>
</StyleMap>
<Style id="sh_ylw-pushpin">
  <IconStyle>
    <scale>1.3</scale>
    <Icon>
      <href>http://maps.google.com/mapfiles/kml/pushpin/ylw-pushpin.png</href>
    </Icon>
    <hotSpot x="20" y="2" xunits="pixels" yunits="pixels"/>
  </IconStyle>
  <BalloonStyle>
  </BalloonStyle>
  <LineStyle>
        <color>$border</color>
        <width>5</width>
  </LineStyle>
  <PolyStyle>
      <color>$fill</color>
  </PolyStyle>
</Style>
<Style id="sn_ylw-pushpin">
  <IconStyle>
    <scale>1.1</scale>
    <Icon>
      <href>http://maps.google.com/mapfiles/kml/pushpin/ylw-pushpin.png</href>
    </Icon>
    <hotSpot x="20" y="2" xunits="pixels" yunits="pixels"/>
  </IconStyle>
  <BalloonStyle>
  </BalloonStyle>
  <LineStyle>
        <color>$border</color>
        <width>5</width>
    </LineStyle>
    <PolyStyle>
        <color>$fill</color>
    </PolyStyle>
</Style>
  <Placemark>
  <styleUrl>#firePolygon</styleUrl>
  <Polygon>
    <outerBoundaryIs>
      <LinearRing>
        <coordinates>
          $pointsString
        </coordinates>
      </LinearRing>
    </outerBoundaryIs>
  </Polygon>
  </Placemark>
  <GroundOverlay>
  <name>Fire Icon</name>
  <Icon>
      <href>${Constants.fireIcon}</href>  
  </Icon>
  <LatLonBox>
      <north>$lon</north>
      <south>$lon</south>
      <east>$lat</east>
      <west>$lat</west>
  </LatLonBox>
  </GroundOverlay>
    ''', 'Zooomed fire');
  }

  static String getMultiGeometryPolygon(String data, String style,int year)=>'''
<Placemark>
  <name>Deforestation Data</name>
  <styleUrl>#$style</styleUrl>
  <MultiGeometry>
    $data
  </MultiGeometry>
  <TimeSpan>
    <begin>$year-01-01</begin>
    <end>2023-12-31</end>
  </TimeSpan>
</Placemark>
  ''';

  static Future<String> getDeforestationKml(DeforestationDataModel model, int year, Forest forest) async{

    List<String> borders = ['ff30ff3b', 'ff00ff95', 'ff00ffcc', 'ff00aeff', 'ff5934c7'];
    List<String> fills = ['6630ff3b', '6600ff95', '6600ffcc', '6600aeff', '665934c7'];

    List<String> files = model.files;
    List<int> magnitudes = model.magnitudes;

    String polygons = '';

    for(int i = 0; i < magnitudes.length; i++){

      String data = await rootBundle.loadString('assets/catastrophe/${forest.path}/${files[i]}.txt');

      String style = (magnitudes[i] <= 10)? 'style1':(magnitudes[i]>10 && magnitudes[i]<=100)? 'style2'
          :(magnitudes[i]>100 && magnitudes[i]<=1000)?'style3':(magnitudes[i]>1000 && magnitudes[i]<=5000)?'style4':'style5';

      polygons += getMultiGeometryPolygon(data, style, year);

      if(style== 'style4')print(getMultiGeometryPolygon(data, style, year));

      print(style);
    }

    return getKmlSkeleton('''
 <StyleMap id="style1">
  <Pair>
    <key>normal</key>
    <styleUrl>#pin1a</styleUrl>
  </Pair>
  <Pair>
    <key>highlight</key>
    <styleUrl>#pin1b</styleUrl>
  </Pair>
</StyleMap>
<Style id="pin1a">
  <IconStyle>
    <scale>1.3</scale>
    <Icon>
      <href>http://maps.google.com/mapfiles/kml/pushpin/ylw-pushpin.png</href>
    </Icon>
    <hotSpot x="20" y="2" xunits="pixels" yunits="pixels"/>
  </IconStyle>
  <BalloonStyle>
  </BalloonStyle>
  <LineStyle>
        <color>${borders[0]}</color>
        <width>5</width>
  </LineStyle>
  <PolyStyle>
      <color>${fills[0]}</color>
  </PolyStyle>
</Style>
<Style id="pin1b">
  <IconStyle>
    <scale>1.1</scale>
    <Icon>
      <href>http://maps.google.com/mapfiles/kml/pushpin/ylw-pushpin.png</href>
    </Icon>
    <hotSpot x="20" y="2" xunits="pixels" yunits="pixels"/>
  </IconStyle>
  <BalloonStyle>
  </BalloonStyle>
  <LineStyle>
        <color>${borders[0]}</color>
        <width>5</width>
    </LineStyle>
    <PolyStyle>
        <color>${fills[0]}</color>
    </PolyStyle>
</Style>
<StyleMap id="style2">
  <Pair>
    <key>normal</key>
    <styleUrl>#pin2a</styleUrl>
  </Pair>
  <Pair>
    <key>highlight</key>
    <styleUrl>#pin2b</styleUrl>
  </Pair>
</StyleMap>
<Style id="pin2a">
  <IconStyle>
    <scale>1.3</scale>
    <Icon>
      <href>http://maps.google.com/mapfiles/kml/pushpin/ylw-pushpin.png</href>
    </Icon>
    <hotSpot x="20" y="2" xunits="pixels" yunits="pixels"/>
  </IconStyle>
  <BalloonStyle>
  </BalloonStyle>
  <LineStyle>
        <color>${borders[1]}</color>
        <width>5</width>
  </LineStyle>
  <PolyStyle>
      <color>${fills[1]}</color>
  </PolyStyle>
</Style>
<Style id="pin2b">
  <IconStyle>
    <scale>1.1</scale>
    <Icon>
      <href>http://maps.google.com/mapfiles/kml/pushpin/ylw-pushpin.png</href>
    </Icon>
    <hotSpot x="20" y="2" xunits="pixels" yunits="pixels"/>
  </IconStyle>
  <BalloonStyle>
  </BalloonStyle>
  <LineStyle>
        <color>${borders[1]}</color>
        <width>5</width>
    </LineStyle>
    <PolyStyle>
        <color>${fills[1]}</color>
    </PolyStyle>
</Style>
<StyleMap id="style3">
  <Pair>
    <key>normal</key>
    <styleUrl>#pin3a</styleUrl>
  </Pair>
  <Pair>
    <key>highlight</key>
    <styleUrl>#pin3b</styleUrl>
  </Pair>
</StyleMap>
<Style id="pin3a">
  <IconStyle>
    <scale>1.3</scale>
    <Icon>
      <href>http://maps.google.com/mapfiles/kml/pushpin/ylw-pushpin.png</href>
    </Icon>
    <hotSpot x="20" y="2" xunits="pixels" yunits="pixels"/>
  </IconStyle>
  <BalloonStyle>
  </BalloonStyle>
  <LineStyle>
        <color>${borders[2]}</color>
        <width>5</width>
  </LineStyle>
  <PolyStyle>
      <color>${fills[2]}</color>
  </PolyStyle>
</Style>
<Style id="pin3b">
  <IconStyle>
    <scale>1.1</scale>
    <Icon>
      <href>http://maps.google.com/mapfiles/kml/pushpin/ylw-pushpin.png</href>
    </Icon>
    <hotSpot x="20" y="2" xunits="pixels" yunits="pixels"/>
  </IconStyle>
  <BalloonStyle>
  </BalloonStyle>
  <LineStyle>
      <color>${borders[2]}</color>
      <width>5</width>
  </LineStyle>
  <PolyStyle>
      <color>${fills[2]}</color>
  </PolyStyle>
</Style>
<StyleMap id="style4">
  <Pair>
    <key>normal</key>
    <styleUrl>#pin4a</styleUrl>
  </Pair>
  <Pair>
    <key>highlight</key>
    <styleUrl>#pin4b</styleUrl>
  </Pair>
</StyleMap>
<Style id="pin4a">
  <IconStyle>
    <scale>1.3</scale>
    <Icon>
      <href>http://maps.google.com/mapfiles/kml/pushpin/ylw-pushpin.png</href>
    </Icon>
    <hotSpot x="20" y="2" xunits="pixels" yunits="pixels"/>
  </IconStyle>
  <BalloonStyle>
  </BalloonStyle>
  <LineStyle>
    <color>${borders[3]}</color>
    <width>5</width>
  </LineStyle>
  <PolyStyle>
    <color>${fills[3]}</color>
  </PolyStyle>
</Style>
<Style id="pin4b">
  <IconStyle>
    <scale>1.1</scale>
    <Icon>
      <href>http://maps.google.com/mapfiles/kml/pushpin/ylw-pushpin.png</href>
    </Icon>
    <hotSpot x="20" y="2" xunits="pixels" yunits="pixels"/>
  </IconStyle>
  <BalloonStyle>
  </BalloonStyle>
  <LineStyle>
    <color>${borders[3]}</color>
    <width>5</width>
  </LineStyle>
  <PolyStyle>
    <color>${fills[3]}</color>
  </PolyStyle>
</Style>

<StyleMap id="style5">
  <Pair>
    <key>normal</key>
    <styleUrl>#pin5a</styleUrl>
  </Pair>
  <Pair>
    <key>highlight</key>
    <styleUrl>#pin5b</styleUrl>
  </Pair>
</StyleMap>
<Style id="pin5a">
  <IconStyle>
    <scale>1.3</scale>
    <Icon>
      <href>http://maps.google.com/mapfiles/kml/pushpin/ylw-pushpin.png</href>
    </Icon>
    <hotSpot x="20" y="2" xunits="pixels" yunits="pixels"/>
  </IconStyle>
  <BalloonStyle>
  </BalloonStyle>
  <LineStyle>
    <color>${borders[4]}</color>
    <width>5</width>
  </LineStyle>
  <PolyStyle>
    <color>${fills[4]}</color>
  </PolyStyle>
</Style>
<Style id="pin5b">
  <IconStyle>
    <scale>1.1</scale>
    <Icon>
      <href>http://maps.google.com/mapfiles/kml/pushpin/ylw-pushpin.png</href>
    </Icon>
    <hotSpot x="20" y="2" xunits="pixels" yunits="pixels"/>
  </IconStyle>
  <BalloonStyle>
  </BalloonStyle>
  <LineStyle>
    <color>${borders[4]}</color>
    <width>5</width>
  </LineStyle>
  <PolyStyle>
    <color>${fills[4]}</color>
  </PolyStyle>
</Style>
$polygons
    ''', 'Deforestation Data');
  }


}