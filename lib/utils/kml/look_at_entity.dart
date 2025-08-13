class LookAtEntity{

  double longitude;
  double latitude;
  double altitude;
  double zoom;
  double tilt;
  double heading;

  LookAtEntity(this.longitude, this.latitude, this.altitude, this.zoom, this.tilt, this.heading);

   String lookAt() => '''<LookAt>
  <longitude>$longitude</longitude>
  <latitude>$latitude</latitude>
  <range>$zoom</range>
  <tilt>$tilt</tilt>
  <heading>$heading</heading>
  <gx:altitudeMode>absolute</gx:altitudeMode>
</LookAt>''';

   String linearLookAt() =>
      '<LookAt><longitude>$longitude</longitude><latitude>$latitude</latitude><altitude>$altitude</altitude><range>$zoom</range><tilt>$tilt</tilt><heading>$heading</heading><gx:altitudeMode>relativeToGround</gx:altitudeMode></LookAt>';

   String orbitLinearLookAt() =>
      '<gx:duration>2</gx:duration><gx:flyToMode>smooth</gx:flyToMode><LookAt><longitude>$longitude</longitude><latitude>$latitude</latitude><altitude>$altitude</altitude><range>$zoom</range><tilt>$tilt</tilt><heading>$heading</heading><gx:altitudeMode>relativeToGround</gx:altitudeMode></LookAt>';

}