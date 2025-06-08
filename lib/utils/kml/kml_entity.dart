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


}