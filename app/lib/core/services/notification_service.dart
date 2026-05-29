import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('America/Bogota'));

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _plugin.initialize(settings);
  }

  static const _highDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      'igo_channel',
      'IGO Manager',
      channelDescription: 'Alertas de vencimiento e inactividad',
      importance: Importance.high,
      priority: Priority.high,
    ),
  );

  static const _normalDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      'igo_channel',
      'IGO Manager',
      channelDescription: 'Alertas generales',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    ),
  );

  static Future<void> mostrarAhora({
    required int id,
    required String titulo,
    required String cuerpo,
  }) async {
    await _plugin.show(id, titulo, cuerpo, _highDetails);
  }

  static Future<void> programarVencimiento({
    required int id,
    required String tituloIniciativa,
    required DateTime fechaLimite,
  }) async {
    final ahora = DateTime.now();

    final fecha24h = fechaLimite.subtract(const Duration(hours: 24));
    if (fecha24h.isAfter(ahora)) {
      await _plugin.zonedSchedule(
        id,
        'Vencimiento en 24h',
        '"$tituloIniciativa" vence mañana. Revisa tu plan.',
        tz.TZDateTime.from(fecha24h, tz.local),
        _highDetails,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }

    final fecha1h = fechaLimite.subtract(const Duration(hours: 1));
    if (fecha1h.isAfter(ahora)) {
      await _plugin.zonedSchedule(
        id + 1000,
        'Vencimiento en 1h',
        '"$tituloIniciativa" vence en una hora.',
        tz.TZDateTime.from(fecha1h, tz.local),
        _highDetails,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  static Future<void> programarInactividad() async {
    await _plugin.zonedSchedule(
      9999,
      'Sin actividad — 7 días',
      'Hace 7 días no revisas tus prioridades.',
      tz.TZDateTime.now(tz.local).add(const Duration(days: 7)),
      _normalDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> cancelar(int id) async {
    await _plugin.cancel(id);
    await _plugin.cancel(id + 1000);
  }
}
