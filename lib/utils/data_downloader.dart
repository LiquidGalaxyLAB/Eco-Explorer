import 'dart:io';

import 'package:eco_explorer/widgets/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/strings.dart';
import '../ref/values_provider.dart';

class DataDownloader{
  String? task;
  Future<void> downloadData(WidgetRef ref, BuildContext context) async {
    try {
      final localPath = await getApplicationDocumentsDirectory();
      final fileName = '${Constants.models}.zip';

      task = await FlutterDownloader.enqueue(
        url: 'https://github.com/Ssdosaofc/Assets-Repo/raw/main/eco-explorer/${Constants.models}.zip',
        savedDir: localPath.path,
        fileName: fileName,
        openFileFromNotification: false,
      );

      if (task == null) {
        throw Exception("Download task could not be created.");
      }

      bool downloadFinished = false;
      while (!downloadFinished) {
        final tasks = await FlutterDownloader.loadTasksWithRawQuery(
          query: "SELECT * FROM task WHERE task_id='$task'",
        );

        if (tasks != null && tasks.isNotEmpty) {
          final status = tasks.first.status;
          ref.read(downloadingTextProvider.notifier).state = 'Downloading';
          ref.read(downloadingProvider.notifier).state = tasks.first.progress / 100;

          if (status == DownloadTaskStatus.complete) {
            downloadFinished = true;
            ref.read(downloadingTextProvider.notifier).state = 'Extracting files';
          } else if (status == DownloadTaskStatus.failed || status == DownloadTaskStatus.canceled) {
            throw Exception("Download failed or was cancelled.");
          }
        }

        await Future.delayed(const Duration(milliseconds: 500));
      }

      print('downloaded at ${localPath.path}');

      await ZipFile.extractToDirectory(
        zipFile: File('${localPath.path}/$fileName'),
        destinationDir: Directory(localPath.path),
        onExtracting: (zipEntry, progress) {
          ref.read(downloadingProvider.notifier).state = progress / 100;
          print('Extracting: ${zipEntry.name} (${progress.toStringAsFixed(1)}%)');
          return ZipFileOperation.includeItem;
        },
      );

      print('extracted');


    } catch (e) {
      if(task!=null) FlutterDownloader.cancel(taskId: task!);
      rethrow;
    }
  }

  deleteData() async{
    final localPath = await getApplicationDocumentsDirectory();
    final path = '${localPath.path}/${Constants.models}';
    File file = File(path);

    await file.delete();
  }
}