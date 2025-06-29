import '../../constants/strings.dart';
import '../../models/fire/fire_model.dart';

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

}