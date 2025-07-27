import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:dartssh2/dartssh2.dart';
import 'package:eco_explorer/constants/strings.dart';
import 'package:eco_explorer/utils/kml/kml_entity.dart';
import 'package:eco_explorer/utils/kml/look_at_entity.dart';
import 'package:eco_explorer/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/theme.dart';
import '../../ref/values_provider.dart';
import '../kml/balloon_entity.dart';

class Ssh extends ChangeNotifier{
  late String _host;
  late String _port;
  late String _username;
  late String _passwordOrKey;
  late String _numberOfRigs;
  SSHClient? _client;

  bool isConnected = false;
  bool get connected => isConnected;

  static const String lgUrl = 'http://lg1:81';

  int rigCount()
  {
    return int.parse(_numberOfRigs);
  }

  Future<void> initConnectionDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _host = prefs.getString('ipAddress') ?? 'default_host';
    _port = prefs.getString('sshPort') ?? '22';
    _username = prefs.getString('username') ?? 'lg';
    _passwordOrKey = prefs.getString('password') ?? 'lg';
    _numberOfRigs = prefs.getString('numberOfRigs') ?? '3';
  }

  Future<bool?> connectToLG(
      BuildContext context
      ) async {
    await initConnectionDetails();
    print("Attempting SSH connection...");
    try {
      final socket = await SSHSocket.connect(_host, int.parse(_port));

      _client = SSHClient(socket, username: _username,
        onPasswordRequest: () =>_passwordOrKey,
      );

      print('IP: $_host, port: $_port ');
      isConnected = true;
      notifyListeners();

      showSnackBar(context, 'Connected to LG Server', Colors.green);
      return true;
    } catch (e) {
      print('Failed to connect: $e');
      isConnected = false;
      notifyListeners();
      showSnackBar(context, 'Failed to connect', Themes.error);
      return false;
    }
  }

  Future<bool> reconnectToLG(BuildContext context) async {
    await connectToLG(context);
    return isConnected;
  }

  disconnect(BuildContext context) async{
    try {
      if (_client == null) {
        return;
      }
      _client?.close();
      isConnected = false;
      notifyListeners();
      showSnackBar(context, 'Disconnected from LG Server', Colors.grey);
    }catch(e){
      showSnackBar(context, 'Failed to disconnect', Colors.grey);
    }
  }

  Future<void> setRefresh(BuildContext context) async {
    try{
      if(_client==null) {
        return;
      }
      for(int i=2;i<=int.parse(_numberOfRigs);i++){
        String search = '<href>##LG_PHPIFACE##kml\\/slave_$i.kml<\\/href>';
        String replace =
            '<href>##LG_PHPIFACE##kml\\/slave_$i.kml<\\/href><refreshMode>onInterval<\\/refreshMode><refreshInterval>2<\\/refreshInterval>';

        await _client!.run(
            'sshpass -p $_passwordOrKey ssh -t lg$i \'echo $_passwordOrKey | sudo -S sed -i "s/$replace/$search/" ~/earth/kml/slave/myplaces.kml\'');
        await _client!.run(
            'sshpass -p $_passwordOrKey ssh -t lg$i \'echo $_passwordOrKey | sudo -S sed -i "s/$search/$replace/" ~/earth/kml/slave/myplaces.kml\'');
      }
      showSnackBar(context, 'Refresh set', Colors.green);
    }catch(e){
      showSnackBar(context, e.toString(), Themes.error);
    }
  }

  Future<void> resetRefresh(BuildContext context) async {
    try{
      if(_client==null) {
        return;
      }
      for(int i=2;i<=int.parse(_numberOfRigs);i++){
        String search =
            '<href>##LG_PHPIFACE##kml\\/slave_$i.kml<\\/href><refreshMode>onInterval<\\/refreshMode><refreshInterval>2<\\/refreshInterval>';
        String replace = '<href>##LG_PHPIFACE##kml\\/slave_$i.kml<\\/href>';

        await _client?.run(
            'sshpass -p $_passwordOrKey ssh -t lg$i \'echo $_passwordOrKey | sudo -S sed -i "s/$search/$replace/" ~/earth/kml/slave/myplaces.kml\'');
        showSnackBar(context, 'Refresh reset', Colors.green);
      }
    }catch(e){
      showSnackBar(context, e.toString(), Themes.error);
    }
  }

  Future<void> relaunchLG(BuildContext context) async {
    try{
      if(_client==null) {
        return;
      }
      for(int i=1;i<=int.parse(_numberOfRigs);i++){
        String command = """RELAUNCH_CMD="\\
          if [ -f /etc/init/lxdm.conf ]; then
            export SERVICE=lxdm
          elif [ -f /etc/init/lightdm.conf ]; then
            export SERVICE=lightdm
          else
            exit 1
          fi
          if  [[ \\\$(service \\\$SERVICE status) =~ 'stop' ]]; then
            echo $_passwordOrKey | sudo -S service \\\${SERVICE} start
          else
            echo $_passwordOrKey | sudo -S service \\\${SERVICE} restart
          fi
          " && sshpass -p $_passwordOrKey ssh -x -t lg@lg$i "\$RELAUNCH_CMD\"""";

        await _client!
            .execute('"/home/$_username/bin/lg-relaunch" > /home/$_client/log.txt');
        await _client!.execute(command);
        showSnackBar(context, 'Relaunch Successful', Colors.green);
      }
    }catch(e){
      showSnackBar(context, e.toString(), Themes.error);
    }
  }

  Future<void> rebootLG(BuildContext context) async{
    try{
      if(_client==null) {
        return;
      }
      for(int i=int.parse(_numberOfRigs);i>=1;i--){
        await _client!.execute(
            'sshpass -p $_passwordOrKey ssh -t lg$i "echo $_passwordOrKey | sudo -S reboot"'
        );
      }
      showSnackBar(context, 'Reboot Successful', Colors.green);
    }catch(e){
      showSnackBar(context, e.toString(), Themes.error);
    }
  }

  Future<void> powerOff(BuildContext context) async{
    try{
      if(_client==null) {
        return;
      }
      for(int i=int.parse(_numberOfRigs);i>=1;i--){
        await _client!.execute(
            'sshpass -p $_passwordOrKey ssh -t lg$i "echo $_passwordOrKey | sudo -S poweroff"'
        );
      }
      showSnackBar(context, 'Power Off Successful', Colors.green);

    }catch(e){
      showSnackBar(context, e.toString(), Themes.error);
    }
  }

  Future<void> clearKml(BuildContext context) async{
    try{
      String query =
          'echo "exittour=true" > /tmp/query.txt && > /var/www/html/kmls.txt';
      for (var i = 2; i <= int.parse(_numberOfRigs); i++) {
        String blankKml = KmlEntity.generateBlank('slave_$i');
        query += " && echo '$blankKml' > /var/www/html/kml/slave_$i.kml";
      }

      await _client!.run(query);

      showSnackBar(context, 'Cleared Logos and KMLs', Colors.green);
    }catch(e){
      await reconnectToLG(context);
      clearKml(context);
    }
  }

  cleanBalloon(context) async {
    try {
      await _client!.run(
          "echo '${BalloonEntity.blankBalloon()}' > /var/www/html/kml/slave_${Constants.rightRig(int.parse(_numberOfRigs))}.kml");
    } catch (error) {
      await reconnectToLG(context);
      await cleanBalloon(context);
    }
  }

  makeFile(String filename, String content) async {
    try {
      var localPath = await getApplicationDocumentsDirectory();
      print(localPath.path.toString());
      File localFile = File('${localPath.path}/$filename');
      await localFile.writeAsString(content,flush: true);
      print("file created");

      return localFile;
    }
    catch (e) {
      print("error : $e");
    }
  }

  kmlFileUpload(File inputFile, String kmlName) async {
    try {
      if(_client == null) {
        return;
      }

      final sftp = await _client?.sftp();

      final remotePath = '/var/www/html/$kmlName';

      try {
        await sftp?.remove(remotePath);
      } catch (e) {
      }

      final fileContents = await inputFile.readAsString();
      print("File contents:\n$fileContents");

      final file = await sftp?.open(remotePath,
          mode: SftpFileOpenMode.create |
          SftpFileOpenMode.truncate |
          SftpFileOpenMode.write);
      await file?.write(inputFile.openRead().cast());
      if (file == null) {
        return;
      }
      await file.close();
    } catch (e) {
      print(e);
    }
  }

  Future<bool?> sendKml(BuildContext context, String fileName) async{
    try {
      if(_client==null) {
        return false;
      }
      print('running kml');
      await _client!.run('echo "\nhttp://lg1:81/$fileName" > /var/www/html/kmls.txt');
      print('kml ran');
      return true;
    } catch(e){
      showSnackBar(context, e.toString(), Themes.error);
      return false;
    }
  }

  Future<void> sendKmltoSlave(BuildContext context, String kmlContent, int slaveNo) async{
    try{
      if(_client==null) {
        return;
      }

      await _client!.run("echo '${kmlContent.trim()}' > /var/www/html/kml/slave_$slaveNo.kml");
    }catch(e){
      showSnackBar(context, e.toString(), Themes.error);
    }
  }

  Future<void> startOrbit(BuildContext context) async {
    try {
      if(_client==null) {
        return;
      }
      await _client!.run('echo "" > /tmp/query.txt');
      await _client!.run('echo "playtour=Orbit" > /tmp/query.txt');
      print('tour started');
    } catch (e) {
      await startOrbit(context);
    }
  }

  Future<void> stopOrbit(BuildContext context) async{
    try {
      await _client!.run('echo "exittour=true" > /tmp/query.txt');
    } catch (error) {
      await reconnectToLG(context);
      stopOrbit(context);
    }
  }

  Future<bool> flyToOrbit(BuildContext context, double latitude, double longitude, double altitude,
      double zoom, double tilt, double heading) async {
    try {
      if(_client==null)
      {
        await reconnectToLG(context);
        if(isConnected==false) {
          return false;
        }
      }
      String lookAt = LookAtEntity(longitude, latitude, altitude, zoom, tilt, heading).orbitLinearLookAt();
      await _client!.run(
          'echo "flytoview=$lookAt" > /tmp/query.txt');
      return true;
    } catch (e) {
      showSnackBar(context, e.toString(), Themes.error);
      return false;
    }
  }

  Future<void> flyToWithoutSaving(BuildContext context, WidgetRef ref, double latitude, double longitude, double altitude,
      double zoom, double tilt, double heading) async {
    try {
      String lookAt = LookAtEntity(longitude, latitude, altitude, zoom, tilt, heading).linearLookAt();
      await _client!.run(
          'echo "flytoview=$lookAt" > /tmp/query.txt');
      setMap(ref, latitude, longitude, altitude, zoom, tilt, heading);
    } catch (e) {
      showSnackBar(context, e.toString(), Themes.error);
    }
  }

  flyTo(WidgetRef ref, BuildContext context, double latitude, double longitude, double zoom, double tilt,
      double bearing) async {
    try {
      Future.delayed(Duration.zero).then((_) async {
        ref.read(lastMapPositionProvider.notifier).state = CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: zoom,
          tilt: tilt,
          bearing: bearing,
        );
      });

      double altitude = 130000000.0 / pow(2, zoom);

      await _client!.run(
          'echo "flytoview=${LookAtEntity(longitude, latitude, altitude, zoom, tilt, bearing).linearLookAt()}" > /tmp/query.txt');
    } catch (e) {
      showSnackBar(context, e.toString(), Themes.error);
    }
  }

  makeImageFile(Uint8List imageBytes, int number) async {
    var localPath = await getApplicationDocumentsDirectory();
    File localFile = File('${localPath.path}/$number.png');
    localFile.writeAsBytes(imageBytes);
    return localFile;
  }

  prepareImageUpload(BuildContext context) async {
    String command =
        'echo "$_passwordOrKey" | sudo -S chmod 777 ${Constants.remoteFile}';
    try {
      await _client!.run(command);
      await _client!.run(
          "sshpass -p \"$_passwordOrKey\" ssh -t lg@lg${Constants.rightRig(int.parse(_numberOfRigs))} '$command'");
    } catch (e) {
      showSnackBar(context,e.toString(),Themes.error);
    }
  }

  imageFileUpload(BuildContext context, Uint8List imageBytes, String fileName) async {
    try {
      File inputFile = await makeImageFile(imageBytes, 1);
      final sftp = await _client?.sftp();

      print('${Constants.remoteFile}$fileName.png');
      final file = await sftp?.open(
          '${Constants.remoteFile}$fileName.png',
          mode: SftpFileOpenMode.create |
          SftpFileOpenMode.truncate |
          SftpFileOpenMode.write);

      file?.write(inputFile.openRead().cast());

    } catch (e) {
      showSnackBar(context,e.toString(),Themes.error);
    }
  }

  // imageFileUploadSlave(BuildContext context, String fileName) async {
  //   try {
  //
  //     try {
  //       final checkSlaveDir = 'sshpass -p $_passwordOrKey ssh lg@lg${Constants.rightRig(int.parse(_numberOfRigs))} '
  //           '"ls -ld ${Constants.remoteFile}"';
  //       final output = await _client!.run(checkSlaveDir);
  //       print('Slave directory permissions: $output');
  //     } catch (e) {
  //       print('Error checking slave directory: $e');
  //     }
  //
  //     final command = 'echo "put ${Constants.remoteFile}$fileName.png" | sshpass -p $_passwordOrKey sftp -oBatchMode=no -b - lg@lg${Constants.rightRig(int.parse(_numberOfRigs))}:${Constants.remoteFile}';
  //     print(command);
  //
  //     final result = await _client!.run(command);
  //     print('Command output: $result');
  //
  //     print('File transfer successful');
  //   } catch (e) {
  //     showSnackBar(context,e.toString(),Themes.error);
  //   }
  // }

  imageFileUploadSlave(BuildContext context, String fileName) async {
    try {
      final uploadCmd = 'sshpass -p $_passwordOrKey scp ${Constants.remoteFile}$fileName.png '
          'lg@lg${Constants.rightRig(int.parse(_numberOfRigs))}:/tmp/';
      await _client!.run(uploadCmd);

      final moveCmd = 'sshpass -p $_passwordOrKey ssh lg@lg${Constants.rightRig(int.parse(_numberOfRigs))} '
          '"echo \'$_passwordOrKey\' | sudo -S mv /tmp/$fileName.png ${Constants.remoteFile}"';
      await _client!.run(moveCmd);
    } catch (e) {
      showSnackBar(context,e.toString(),Themes.error);
    }
  }
}