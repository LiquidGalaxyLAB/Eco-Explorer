import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../constants/strings.dart';
import '../../models/fire/fire_model.dart';
import 'noise_polygon_generator.dart';

class KmlEntity{
  static String getKmlSkeleton(String content, String name)=>'''
  <?xml version="1.0" encoding="UTF-8"?>
      <kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
      <Document>
        <name>$name</name>
        <open>1</open>
        <Folder>
          $content
        </Folder>
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
        <size x="${300}" y="${(300 * factor)}" xunits="pixels" yunits="pixels"/>
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
}