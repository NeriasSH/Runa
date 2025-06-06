// lib/services/permission_service.dart
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<bool> requestNetworkPermissions() async {
    try {
      // Verifica si ya tiene los permisos
      if (await Permission.manageExternalStorage.isGranted &&
          await Permission.accessMediaLocation.isGranted) {
        return true;
      }

      // Solicita permisos
      final status = await [
        Permission.manageExternalStorage,
        Permission.accessMediaLocation,
      ].request();

      return status[Permission.manageExternalStorage]!.isGranted &&
          status[Permission.accessMediaLocation]!.isGranted;
    } catch (e) {
      return false;
    }
  }

  static Future<void> showPermissionDeniedDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permisos requeridos'),
        content: const Text(
          'La aplicación necesita permisos de red para funcionar correctamente. '
          'Por favor, concede los permisos en Ajustes.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => openAppSettings(),
            child: const Text('Ajustes'),
          ),
        ],
      ),
    );
  }
}
