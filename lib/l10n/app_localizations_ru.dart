// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'MeshCore SAR';

  @override
  String get messages => 'Сообщения';

  @override
  String get contacts => 'Контакты';

  @override
  String get map => 'Карта';

  @override
  String get settings => 'Настройки';

  @override
  String get connect => 'Подключить';

  @override
  String get disconnect => 'Отключить';

  @override
  String get scanningForDevices => 'Поиск устройств...';

  @override
  String get noDevicesFound => 'Устройства не найдены';

  @override
  String get scanAgain => 'Повторить поиск';

  @override
  String get tapToConnect => 'Нажмите для подключения';

  @override
  String get deviceNotConnected => 'Устройство не подключено';

  @override
  String get locationPermissionDenied => 'Доступ к геолокации запрещён';

  @override
  String get locationPermissionPermanentlyDenied =>
      'Доступ к геолокации запрещён навсегда. Включите его в настройках.';

  @override
  String get locationPermissionRequired =>
      'Доступ к геолокации необходим для GPS-трекинга и координации команды. Вы можете включить его позже в настройках.';

  @override
  String get locationServicesDisabled =>
      'Службы геолокации отключены. Пожалуйста, включите их в настройках.';

  @override
  String get failedToGetGpsLocation => 'Не удалось получить GPS-координаты';

  @override
  String advertisedAtLocation(String latitude, String longitude) {
    return 'Транслируется в $latitude, $longitude';
  }

  @override
  String failedToAdvertise(String error) {
    return 'Ошибка трансляции: $error';
  }

  @override
  String reconnecting(int attempt, int max) {
    return 'Переподключение... ($attempt/$max)';
  }

  @override
  String get cancelReconnection => 'Отменить переподключение';

  @override
  String get mapManagement => 'Управление картой';

  @override
  String get general => 'Основные';

  @override
  String get theme => 'Тема';

  @override
  String get chooseTheme => 'Выбрать тему';

  @override
  String get light => 'Светлая';

  @override
  String get dark => 'Тёмная';

  @override
  String get blueLightTheme => 'Синяя светлая тема';

  @override
  String get blueDarkTheme => 'Синяя тёмная тема';

  @override
  String get sarRed => 'SAR Красная';

  @override
  String get alertEmergencyMode => 'Режим тревоги / ЧС';

  @override
  String get sarGreen => 'SAR Зелёная';

  @override
  String get safeAllClearMode => 'Режим «Всё в порядке»';

  @override
  String get autoSystem => 'Авто (Система)';

  @override
  String get followSystemTheme => 'Следовать системной теме';

  @override
  String get showRxTxIndicators => 'Показывать индикаторы RX/TX';

  @override
  String get displayPacketActivity =>
      'Отображать активность пакетов в верхней панели';

  @override
  String get simpleMode => 'Простой режим';

  @override
  String get simpleModeDescription =>
      'Скрыть второстепенную информацию в сообщениях и контактах';

  @override
  String get disableMap => 'Отключить карту';

  @override
  String get disableMapDescription =>
      'Скрыть вкладку карты для экономии заряда батареи';

  @override
  String get language => 'Язык';

  @override
  String get chooseLanguage => 'Выбрать язык';

  @override
  String get english => 'Английский';

  @override
  String get slovenian => 'Словенский';

  @override
  String get croatian => 'Хорватский';

  @override
  String get german => 'Немецкий';

  @override
  String get spanish => 'Испанский';

  @override
  String get french => 'Французский';

  @override
  String get italian => 'Итальянский';
  
  @override
  String get russian => 'Русский';

  @override
  String get locationBroadcasting => 'Трансляция местоположения';

  @override
  String get autoLocationTracking => 'Авто-отслеживание геолокации';

  @override
  String get automaticallyBroadcastPosition =>
      'Автоматически транслировать обновления позиции';

  @override
  String get configureTracking => 'Настроить отслеживание';

  @override
  String get distanceAndTimeThresholds => 'Пороги расстояния и времени';

  @override
  String get locationTrackingConfiguration =>
      'Настройка отслеживания геолокации';

  @override
  String get configureWhenLocationBroadcasts =>
      'Настройте условия отправки обновлений геолокации в mesh-сеть';

  @override
  String get minimumDistance => 'Минимальное расстояние';

  @override
  String broadcastAfterMoving(String distance) {
    return 'Транслировать только после перемещения на $distance м';
  }

  @override
  String get maximumDistance => 'Максимальное расстояние';

  @override
  String alwaysBroadcastAfterMoving(String distance) {
    return 'Всегда транслировать после перемещения на $distance м';
  }

  @override
  String get minimumTimeInterval => 'Минимальный интервал времени';

  @override
  String alwaysBroadcastEvery(String duration) {
    return 'Всегда транслировать каждые $duration';
  }

  @override
  String get save => 'Сохранить';

  @override
  String get cancel => 'Отмена';

  @override
  String get close => 'Закрыть';

  @override
  String get about => 'О приложении';

  @override
  String get appVersion => 'Версия приложения';

  @override
  String get appName => 'Название приложения';

  @override
  String get aboutMeshCoreSar => 'О MeshCore SAR';

  @override
  String get aboutDescription =>
      'Приложение для поисково-спасательных операций, разработанное для аварийно-спасательных служб. Возможности:\n\n• BLE mesh-сеть для связи между устройствами\n• Офлайн-карты с несколькими вариантами слоёв\n• Отслеживание членов команды в реальном времени\n• Тактические маркеры SAR (найденный человек, пожар, место сбора)\n• Управление контактами и обмен сообщениями\n• GPS-трекинг с показанием курса компаса\n• Кэширование тайлов карт для работы офлайн';

  @override
  String get technologiesUsed => 'Используемые технологии:';

  @override
  String get technologiesList =>
      '• Flutter для кросс-платформенной разработки\n• BLE (Bluetooth Low Energy) для mesh-сети\n• OpenStreetMap для карт\n• Provider для управления состоянием\n• SharedPreferences для локального хранилища';

  @override
  String get moreInfo => 'Подробнее';

  @override
  String get learnMoreAbout => 'Узнать больше о MeshCore SAR';

  @override
  String get developer => 'Разработчик';

  @override
  String get packageName => 'Имя пакета';

  @override
  String get sampleData => 'Тестовые данные';

  @override
  String get sampleDataDescription =>
      'Загрузить или очистить тестовые контакты, сообщения каналов и маркеры SAR';

  @override
  String get loadSampleData => 'Загрузить тестовые данные';

  @override
  String get clearAllData => 'Очистить все данные';

  @override
  String get clearAllDataConfirmTitle => 'Очистить все данные';

  @override
  String get clearAllDataConfirmMessage =>
      'Это удалит все контакты и маркеры SAR. Вы уверены?';

  @override
  String get clear => 'Очистить';

  @override
  String loadedSampleData(
    int teamCount,
    int channelCount,
    int sarCount,
    int messageCount,
  ) {
    return 'Загружено: $teamCount членов команды, $channelCount каналов, $sarCount маркеров SAR, $messageCount сообщений';
  }

  @override
  String failedToLoadSampleData(String error) {
    return 'Не удалось загрузить тестовые данные: $error';
  }

  @override
  String get allDataCleared => 'Все данные очищены';

  @override
  String get failedToStartBackgroundTracking =>
      'Не удалось запустить фоновое отслеживание. Проверьте разрешения и BLE-соединение.';

  @override
  String locationBroadcast(String latitude, String longitude) {
    return 'Трансляция геолокации: $latitude, $longitude';
  }

  @override
  String get defaultPinInfo =>
      'PIN-код по умолчанию для устройств без экрана — 123456. Проблемы с сопряжением? Удалите устройство из Bluetooth в системных настройках.';

  @override
  String get noMessagesYet => 'Сообщений пока нет';

  @override
  String get pullDownToSync => 'Потяните вниз для синхронизации сообщений';

  @override
  String get deleteContact => 'Удалить контакт';

  @override
  String get delete => 'Удалить';

  @override
  String get viewOnMap => 'Показать на карте';

  @override
  String get refresh => 'Обновить';

  @override
  String get sendDirectMessage => 'Отправить';

  @override
  String get resetPath => 'Сбросить маршрут (перепроложить)';

  @override
  String get publicKeyCopied => 'Публичный ключ скопирован в буфер обмена';

  @override
  String copiedToClipboard(String label) {
    return '$label скопировано в буфер обмена';
  }

  @override
  String get pleaseEnterPassword => 'Пожалуйста, введите пароль';

  @override
  String failedToSyncContacts(String error) {
    return 'Не удалось синхронизировать контакты: $error';
  }

  @override
  String get loggedInSuccessfully =>
      'Вход выполнен! Ожидание сообщений комнаты...';

  @override
  String get loginFailed => 'Ошибка входа — неверный пароль';

  @override
  String loggingIn(String roomName) {
    return 'Вход в $roomName...';
  }

  @override
  String failedToSendLogin(String error) {
    return 'Не удалось отправить данные входа: $error';
  }

  @override
  String get lowLocationAccuracy => 'Низкая точность геолокации';

  @override
  String get continue_ => 'Продолжить';

  @override
  String get sendSarMarker => 'Отправить маркер SAR';

  @override
  String get deleteDrawing => 'Удалить рисунок';

  @override
  String get drawingTools => 'Инструменты рисования';

  @override
  String get drawLine => 'Нарисовать линию';

  @override
  String get drawLineDesc => 'Нарисуйте произвольную линию на карте';

  @override
  String get drawRectangle => 'Нарисовать прямоугольник';

  @override
  String get drawRectangleDesc => 'Нарисуйте прямоугольную область на карте';

  @override
  String get measureDistance => 'Измерить расстояние';

  @override
  String get measureDistanceDesc => 'Долгое нажатие на две точки для измерения';

  @override
  String get clearMeasurement => 'Сбросить измерение';

  @override
  String distanceLabel(String distance) {
    return 'Расстояние: $distance';
  }

  @override
  String get longPressForSecondPoint => 'Долгое нажатие для второй точки';

  @override
  String get longPressToStartMeasurement =>
      'Долгое нажатие для установки первой точки';

  @override
  String get longPressToStartNewMeasurement =>
      'Долгое нажатие для начала нового измерения';

  @override
  String get shareDrawings => 'Поделиться рисунками';

  @override
  String get clearAllDrawings => 'Удалить все рисунки';

  @override
  String get completeLine => 'Завершить линию';

  @override
  String broadcastDrawingsToTeam(int count, String plural) {
    return 'Транслировать $count рисун$plural команде';
  }

  @override
  String removeAllDrawings(int count, String plural) {
    return 'Удалить все $count рисун$plural';
  }

  @override
  String deleteAllDrawingsConfirm(int count, String plural) {
    return 'Удалить все $count рисун$plural с карты?';
  }

  @override
  String get drawing => 'Рисунок';

  @override
  String shareDrawingsCount(int count, String plural) {
    return 'Поделиться $count рисун$plural';
  }

  @override
  String sentDrawingsToRoom(int count, String plural, String roomName) {
    return 'Отправлено $count рисун$plural в $roomName';
  }

  @override
  String sharedDrawingsToRoom(
    int success,
    int total,
    String plural,
    String roomName,
  ) {
    return 'Передано $success/$total рисун$plural в $roomName';
  }

  @override
  String get showReceivedDrawings => 'Показать полученные рисунки';

  @override
  String get showingAllDrawings => 'Показаны все рисунки';

  @override
  String get showingOnlyYourDrawings => 'Показаны только ваши рисунки';

  @override
  String get showSarMarkers => 'Показать маркеры SAR';

  @override
  String get showingSarMarkers => 'Маркеры SAR отображаются';

  @override
  String get hidingSarMarkers => 'Маркеры SAR скрыты';

  @override
  String get clearAll => 'Очистить всё';

  @override
  String get noLocalDrawings => 'Нет локальных рисунков для отправки';

  @override
  String get publicChannel => 'Публичный канал';

  @override
  String get broadcastToAll => 'Трансляция всем ближайшим узлам (временно)';

  @override
  String get storedPermanently => 'Сохранено постоянно в комнате';

  @override
  String drawingsSentToPublicChannel(int count, String plural) {
    return 'Отправлено $count рисун$plural в публичный канал';
  }

  @override
  String drawingsSharedToPublicChannel(int success, int total) {
    return 'Передано $success/$total рисунков в публичный канал';
  }

  @override
  String get notConnectedToDevice => 'Устройство не подключено';

  @override
  String get directMessage => 'Личное сообщение';

  @override
  String directMessageSentTo(String contactName) {
    return 'Личное сообщение отправлено $contactName';
  }

  @override
  String failedToSend(String error) {
    return 'Не удалось отправить: $error';
  }

  @override
  String directMessageInfo(String contactName) {
    return 'Это сообщение будет отправлено напрямую $contactName. Оно также появится в общей ленте сообщений.';
  }

  @override
  String get typeYourMessage => 'Введите сообщение...';

  @override
  String get quickLocationMarker => 'Быстрый маркер местоположения';

  @override
  String get markerType => 'Тип маркера';

  @override
  String get sendTo => 'Отправить в';

  @override
  String get noDestinationsAvailable => 'Нет доступных получателей.';

  @override
  String get selectDestination => 'Выберите получателя...';

  @override
  String get ephemeralBroadcastInfo =>
      'Временно: передаётся по эфиру. Не сохраняется — узлы должны быть онлайн.';

  @override
  String get persistentRoomInfo =>
      'Постоянно: хранится неизменно в комнате. Синхронизируется автоматически и доступно офлайн.';

  @override
  String get location => 'Местоположение';

  @override
  String get myLocation => 'Моё местоположение';

  @override
  String get fromMap => 'С карты';

  @override
  String get gettingLocation => 'Получение местоположения...';

  @override
  String get locationError => 'Ошибка геолокации';

  @override
  String get retry => 'Повторить';

  @override
  String get refreshLocation => 'Обновить местоположение';

  @override
  String accuracyMeters(int accuracy) {
    return 'Точность: ±${accuracy}м';
  }

  @override
  String get notesOptional => 'Заметки (необязательно)';

  @override
  String get addAdditionalInformation => 'Добавьте дополнительную информацию...';

  @override
  String lowAccuracyWarning(int accuracy) {
    return 'Точность геолокации: ±${accuracy}м. Этого может быть недостаточно для операций SAR.\n\nПродолжить всё равно?';
  }

  @override
  String get loginToRoom => 'Войти в комнату';

  @override
  String get enterPasswordInfo =>
      'Введите пароль для доступа к этой комнате. Пароль будет сохранён для дальнейшего использования.';

  @override
  String get password => 'Пароль';

  @override
  String get enterRoomPassword => 'Введите пароль комнаты';

  @override
  String get loggingInDots => 'Вход...';

  @override
  String get login => 'Войти';

  @override
  String failedToAddRoom(String error) {
    return 'Не удалось добавить комнату на устройство: $error\n\nВозможно, комната ещё не объявила себя.\nПопробуйте подождать, пока комната не выйдет на связь.';
  }

  @override
  String get direct => 'Напрямую';

  @override
  String get flood => 'Широковещательно';

  @override
  String get admin => 'Администратор';

  @override
  String get loggedIn => 'Вход выполнен';

  @override
  String get noGpsData => 'Нет данных GPS';

  @override
  String get distance => 'Расстояние';

  @override
  String pingingDirect(String name) {
    return 'Пинг $name (напрямую по маршруту)...';
  }

  @override
  String pingingFlood(String name) {
    return 'Пинг $name (широковещательно — нет маршрута)...';
  }

  @override
  String directPingTimeout(String name) {
    return 'Таймаут прямого пинга — повтор $name широковещательно...';
  }

  @override
  String pingSuccessful(String name, String fallback) {
    return 'Пинг успешен: $name$fallback';
  }

  @override
  String get viaFloodingFallback => ' (через широковещательный резерв)';

  @override
  String pingFailed(String name) {
    return 'Пинг не удался: $name — ответ не получен';
  }

  @override
  String deleteContactConfirmation(String name) {
    return 'Вы уверены, что хотите удалить \"$name\"?\n\nЭто удалит контакт как из приложения, так и с сопряжённого радиоустройства.';
  }

  @override
  String removingContact(String name) {
    return 'Удаление $name...';
  }

  @override
  String contactRemoved(String name) {
    return 'Контакт \"$name\" удалён';
  }

  @override
  String failedToRemoveContact(String error) {
    return 'Не удалось удалить контакт: $error';
  }

  @override
  String get type => 'Тип';

  @override
  String get publicKey => 'Публичный ключ';

  @override
  String get lastSeen => 'Последнее появление';

  @override
  String get roomStatus => 'Статус комнаты';

  @override
  String get loginStatus => 'Статус входа';

  @override
  String get notLoggedIn => 'Не выполнен вход';

  @override
  String get adminAccess => 'Доступ администратора';

  @override
  String get yes => 'Да';

  @override
  String get no => 'Нет';

  @override
  String get permissions => 'Разрешения';

  @override
  String get passwordSaved => 'Пароль сохранён';

  @override
  String get locationColon => 'Местоположение:';

  @override
  String get telemetry => 'Телеметрия';

  @override
  String requestingTelemetry(String name) {
    return 'Запрос телеметрии от $name...';
  }

  @override
  String get voltage => 'Напряжение';

  @override
  String get battery => 'Батарея';

  @override
  String get temperature => 'Температура';

  @override
  String get humidity => 'Влажность';

  @override
  String get pressure => 'Давление';

  @override
  String get gpsTelemetry => 'GPS (телеметрия)';

  @override
  String get updated => 'Обновлено';

  @override
  String pathResetInfo(String name) {
    return 'Маршрут сброшен для $name. Следующее сообщение найдёт новый путь.';
  }

  @override
  String get reLoginToRoom => 'Войти в комнату повторно';

  @override
  String get heading => 'Курс';

  @override
  String get elevation => 'Высота';

  @override
  String get accuracy => 'Точность';

  @override
  String get bearing => 'Азимут';

  @override
  String get direction => 'Направление';

  @override
  String get filterMarkers => 'Фильтр маркеров';

  @override
  String get filterMarkersTooltip => 'Фильтровать маркеры';

  @override
  String get contactsFilter => 'Контакты';

  @override
  String get repeatersFilter => 'Ретрансляторы';

  @override
  String get sarMarkers => 'Маркеры SAR';

  @override
  String get foundPerson => 'Найденный человек';

  @override
  String get fire => 'Пожар';

  @override
  String get stagingArea => 'Место сбора';

  @override
  String get showAll => 'Показать все';

  @override
  String get nearbyContacts => 'Ближайшие контакты';

  @override
  String get locationUnavailable => 'Местоположение недоступно';

  @override
  String get ahead => 'впереди';

  @override
  String degreesRight(int degrees) {
    return '$degrees° вправо';
  }

  @override
  String degreesLeft(int degrees) {
    return '$degrees° влево';
  }

  @override
  String latLonFormat(String latitude, String longitude) {
    return 'Ш: $latitude Д: $longitude';
  }

  @override
  String get noContactsYet => 'Контактов пока нет';

  @override
  String get connectToDeviceToLoadContacts =>
      'Подключите устройство для загрузки контактов';

  @override
  String get teamMembers => 'Члены команды';

  @override
  String get repeaters => 'Ретрансляторы';

  @override
  String get rooms => 'Комнаты';

  @override
  String get channels => 'Каналы';

  @override
  String get cacheStatistics => 'Статистика кэша';

  @override
  String get totalTiles => 'Всего тайлов';

  @override
  String get cacheSize => 'Размер кэша';

  @override
  String get storeName => 'Имя хранилища';

  @override
  String get noCacheStatistics => 'Статистика кэша недоступна';

  @override
  String get downloadRegion => 'Скачать регион';

  @override
  String get mapLayer => 'Слой карты';

  @override
  String get regionBounds => 'Границы региона';

  @override
  String get north => 'Север';

  @override
  String get south => 'Юг';

  @override
  String get east => 'Восток';

  @override
  String get west => 'Запад';

  @override
  String get zoomLevels => 'Уровни масштаба';

  @override
  String minZoom(int zoom) {
    return 'Мин: $zoom';
  }

  @override
  String maxZoom(int zoom) {
    return 'Макс: $zoom';
  }

  @override
  String get downloadingDots => 'Загрузка...';

  @override
  String get cancelDownload => 'Отменить загрузку';

  @override
  String get downloadRegionButton => 'Скачать регион';

  @override
  String get downloadNote =>
      'Внимание: большие регионы или высокие уровни масштаба могут потребовать значительного времени и места.';

  @override
  String get cacheManagement => 'Управление кэшем';

  @override
  String get clearAllMaps => 'Очистить все карты';

  @override
  String get clearMapsConfirmTitle => 'Очистить все карты';

  @override
  String get clearMapsConfirmMessage =>
      'Вы уверены, что хотите удалить все загруженные карты? Это действие нельзя отменить.';

  @override
  String get mapDownloadCompleted => 'Загрузка карты завершена!';

  @override
  String get cacheClearedSuccessfully => 'Кэш успешно очищен!';

  @override
  String get downloadCancelled => 'Загрузка отменена';

  @override
  String get startingDownload => 'Начало загрузки...';

  @override
  String get downloadingMapTiles => 'Загрузка тайлов карты...';

  @override
  String get downloadCompletedSuccessfully => 'Загрузка успешно завершена!';

  @override
  String get cancellingDownload => 'Отмена загрузки...';

  @override
  String errorLoadingStats(String error) {
    return 'Ошибка загрузки статистики: $error';
  }

  @override
  String downloadFailed(String error) {
    return 'Ошибка загрузки: $error';
  }

  @override
  String cancelFailed(String error) {
    return 'Ошибка отмены: $error';
  }

  @override
  String clearCacheFailed(String error) {
    return 'Ошибка очистки кэша: $error';
  }

  @override
  String minZoomError(String error) {
    return 'Мин. масштаб: $error';
  }

  @override
  String maxZoomError(String error) {
    return 'Макс. масштаб: $error';
  }

  @override
  String get minZoomGreaterThanMax =>
      'Минимальный масштаб должен быть меньше или равен максимальному';

  @override
  String get selectMapLayer => 'Выбрать слой карты';

  @override
  String get mapOptions => 'Параметры карты';

  @override
  String get showLegend => 'Показать легенду';

  @override
  String get displayMarkerTypeCounts => 'Отображать счётчики типов маркеров';

  @override
  String get rotateMapWithHeading => 'Поворачивать карту по курсу';

  @override
  String get mapFollowsDirection => 'Карта следует вашему направлению движения';

  @override
  String get resetMapRotation => 'Сбросить поворот';

  @override
  String get resetMapRotationTooltip => 'Вернуть карту на север';

  @override
  String get showMapDebugInfo => 'Показать отладочную информацию карты';

  @override
  String get displayZoomLevelBounds => 'Отображать уровень масштаба и границы';

  @override
  String get fullscreenMode => 'Полноэкранный режим';

  @override
  String get hideUiFullMapView =>
      'Скрыть все элементы интерфейса для полного вида карты';

  @override
  String get openStreetMap => 'OpenStreetMap';

  @override
  String get openTopoMap => 'OpenTopoMap';

  @override
  String get esriSatellite => 'ESRI Спутник';

  @override
  String get googleHybrid => 'Google Гибрид';

  @override
  String get googleRoadmap => 'Google Дороги';

  @override
  String get googleTerrain => 'Google Рельеф';

  @override
  String get downloadVisibleArea => 'Скачать видимую область';

  @override
  String get initializingMap => 'Инициализация карты...';

  @override
  String get dragToPosition => 'Перетащите для позиционирования';

  @override
  String get createSarMarker => 'Создать маркер SAR';

  @override
  String get compass => 'Компас';

  @override
  String get navigationAndContacts => 'Навигация и контакты';

  @override
  String get sarAlert => 'ТРЕВОГА SAR';

  @override
  String get messageSentToPublicChannel => 'Сообщение отправлено в публичный канал';

  @override
  String get pleaseSelectRoomToSendSar =>
      'Пожалуйста, выберите комнату для отправки маркера SAR';

  @override
  String failedToSendSarMarker(String error) {
    return 'Не удалось отправить маркер SAR: $error';
  }

  @override
  String sarMarkerSentTo(String roomName) {
    return 'Маркер SAR отправлен в $roomName';
  }

  @override
  String get notConnectedCannotSync => 'Нет подключения — синхронизация невозможна';

  @override
  String syncedMessageCount(int count) {
    return 'Синхронизировано $count сообщение(й)';
  }

  @override
  String get noNewMessages => 'Новых сообщений нет';

  @override
  String syncFailed(String error) {
    return 'Синхронизация не удалась: $error';
  }

  @override
  String get failedToResendMessage => 'Не удалось повторно отправить сообщение';

  @override
  String get retryingMessage => 'Повторная отправка сообщения...';

  @override
  String retryFailed(String error) {
    return 'Повтор не удался: $error';
  }

  @override
  String get textCopiedToClipboard => 'Текст скопирован в буфер обмена';

  @override
  String get cannotReplySenderMissing =>
      'Не удаётся ответить: нет информации об отправителе';

  @override
  String get cannotReplyContactNotFound =>
      'Не удаётся ответить: контакт не найден';

  @override
  String get messageDeleted => 'Сообщение удалено';

  @override
  String get copyText => 'Копировать текст';

  @override
  String get saveAsTemplate => 'Сохранить как шаблон';

  @override
  String get templateSaved => 'Шаблон успешно сохранён';

  @override
  String get templateAlreadyExists => 'Шаблон с таким эмодзи уже существует';

  @override
  String get deleteMessage => 'Удалить сообщение';

  @override
  String get deleteMessageConfirmation =>
      'Вы уверены, что хотите удалить это сообщение?';

  @override
  String get shareLocation => 'Поделиться местоположением';

  @override
  String shareLocationText(
    String markerInfo,
    String lat,
    String lon,
    String url,
  ) {
    return '$markerInfo\n\nКоординаты: $lat, $lon\n\nGoogle Maps: $url';
  }

  @override
  String get sarLocationShare => 'Местоположение SAR';

  @override
  String get locationShared => 'Местоположение передано';

  @override
  String get refreshedContacts => 'Контакты обновлены';

  @override
  String get justNow => 'Только что';

  @override
  String minutesAgo(int minutes) {
    return '${minutes}м назад';
  }

  @override
  String hoursAgo(int hours) {
    return '${hours}ч назад';
  }

  @override
  String daysAgo(int days) {
    return '${days}д назад';
  }

  @override
  String secondsAgo(int seconds) {
    return '${seconds}с назад';
  }

  @override
  String get sending => 'Отправка...';

  @override
  String get sent => 'Отправлено';

  @override
  String get delivered => 'Доставлено';

  @override
  String deliveredWithTime(int time) {
    return 'Доставлено (${time}мс)';
  }

  @override
  String get failed => 'Ошибка';

  @override
  String get broadcast => 'Трансляция';

  @override
  String deliveredToContacts(int delivered, int total) {
    return 'Доставлено $delivered/$total контактам';
  }

  @override
  String get allDelivered => 'Все доставлено';

  @override
  String get recipientDetails => 'Детали получателей';

  @override
  String get pending => 'Ожидание';

  @override
  String get sarMarkerFoundPerson => 'Найденный человек';

  @override
  String get sarMarkerFire => 'Место пожара';

  @override
  String get sarMarkerStagingArea => 'Место сбора';

  @override
  String get sarMarkerObject => 'Найденный объект';

  @override
  String get from => 'От';

  @override
  String get coordinates => 'Координаты';

  @override
  String get tapToViewOnMap => 'Нажмите, чтобы открыть на карте';

  @override
  String get radioSettings => 'Настройки радио';

  @override
  String get frequencyMHz => 'Частота (МГц)';

  @override
  String get frequencyExample => 'например, 869.618';

  @override
  String get bandwidth => 'Полоса пропускания';

  @override
  String get spreadingFactor => 'Коэффициент расширения';

  @override
  String get codingRate => 'Скорость кодирования';

  @override
  String get txPowerDbm => 'Мощность TX (дБм)';

  @override
  String maxPowerDbm(int power) {
    return 'Макс: $power дБм';
  }

  @override
  String get you => 'Вы';

  @override
  String get offlineVectorMaps => 'Офлайн-векторные карты';

  @override
  String get offlineVectorMapsDescription =>
      'Импортируйте офлайн-векторные тайлы карт (формат MBTiles) для использования без интернета';

  @override
  String get importMbtiles => 'Импортировать файл MBTiles';

  @override
  String get importMbtilesNote =>
      'Поддерживаются файлы MBTiles с векторными тайлами (формат PBF/MVT). Отлично подходят выгрузки Geofabrik!';

  @override
  String get noMbtilesFiles => 'Офлайн-векторные карты не найдены';

  @override
  String get mbtilesImportedSuccessfully => 'Файл MBTiles успешно импортирован';

  @override
  String get failedToImportMbtiles => 'Не удалось импортировать файл MBTiles';

  @override
  String get deleteMbtilesConfirmTitle => 'Удалить офлайн-карту';

  @override
  String deleteMbtilesConfirmMessage(String name) {
    return 'Вы уверены, что хотите удалить \"$name\"? Офлайн-карта будет удалена безвозвратно.';
  }

  @override
  String get mbtilesDeletedSuccessfully => 'Офлайн-карта успешно удалена';

  @override
  String get failedToDeleteMbtiles => 'Не удалось удалить офлайн-карту';

  @override
  String get importExportCachedTiles => 'Импорт/Экспорт кэшированных тайлов';

  @override
  String get importExportDescription =>
      'Резервное копирование, обмен и восстановление загруженных тайлов карт между устройствами';

  @override
  String get exportTilesToFile => 'Экспортировать тайлы в файл';

  @override
  String get importTilesFromFile => 'Импортировать тайлы из файла';

  @override
  String get selectExportLocation => 'Выберите место для экспорта';

  @override
  String get selectImportFile => 'Выберите архив тайлов';

  @override
  String get exportingTiles => 'Экспорт тайлов...';

  @override
  String get importingTiles => 'Импорт тайлов...';

  @override
  String exportSuccess(int count) {
    return 'Экспортировано $count тайлов';
  }

  @override
  String importSuccess(int count) {
    return 'Импортировано $count хранилищ';
  }

  @override
  String exportFailed(String error) {
    return 'Ошибка экспорта: $error';
  }

  @override
  String importFailed(String error) {
    return 'Ошибка импорта: $error';
  }

  @override
  String get exportNote =>
      'Создаёт сжатый архив (.fmtc), которым можно поделиться и импортировать на других устройствах.';

  @override
  String get importNote =>
      'Импортирует тайлы карт из ранее экспортированного архива. Тайлы будут объединены с существующим кэшем.';

  @override
  String get noTilesToExport => 'Нет доступных тайлов для экспорта';

  @override
  String archiveContainsStores(int count) {
    return 'Архив содержит $count хранилищ';
  }

  @override
  String get vectorTiles => 'Векторные тайлы';

  @override
  String get schema => 'Схема';

  @override
  String get unknown => 'Неизвестно';

  @override
  String get bounds => 'Границы';

  @override
  String get onlineLayers => 'Онлайн-слои';

  @override
  String get offlineLayers => 'Офлайн-слои';

  @override
  String get locationTrail => 'Трек местоположения';

  @override
  String get showTrailOnMap => 'Показать трек на карте';

  @override
  String get trailVisible => 'Трек отображается на карте';

  @override
  String get trailHiddenRecording => 'Трек скрыт (запись продолжается)';

  @override
  String get duration => 'Продолжительность';

  @override
  String get points => 'Точки';

  @override
  String get clearTrail => 'Очистить трек';

  @override
  String get clearTrailQuestion => 'Очистить трек?';

  @override
  String get clearTrailConfirmation =>
      'Вы уверены, что хотите очистить текущий трек? Это действие нельзя отменить.';

  @override
  String get noTrailRecorded => 'Трек ещё не записан';

  @override
  String get startTrackingToRecord =>
      'Запустите отслеживание геолокации для записи трека';

  @override
  String get trailControls => 'Управление треком';

  @override
  String get exportTrailToGpx => 'Экспортировать трек в GPX';

  @override
  String get importTrailFromGpx => 'Импортировать трек из GPX';

  @override
  String get trailExportedSuccessfully => 'Трек успешно экспортирован!';

  @override
  String get failedToExportTrail => 'Не удалось экспортировать трек';

  @override
  String failedToImportTrail(String error) {
    return 'Не удалось импортировать трек: $error';
  }

  @override
  String get importTrail => 'Импортировать трек';

  @override
  String importTrailQuestion(int pointCount) {
    return 'Импортировать трек из $pointCount точек?\n\nВы можете заменить текущий трек или просмотреть его рядом.';
  }

  @override
  String get viewAlongside => 'Просмотреть рядом';

  @override
  String get replaceCurrent => 'Заменить текущий';

  @override
  String trailImported(int pointCount) {
    return 'Трек импортирован! ($pointCount точек)';
  }

  @override
  String trailReplaced(int pointCount) {
    return 'Трек заменён! ($pointCount точек)';
  }

  @override
  String get contactTrails => 'Треки контактов';

  @override
  String get showAllContactTrails => 'Показать все треки контактов';

  @override
  String get noContactsWithLocationHistory =>
      'Нет контактов с историей местоположения';

  @override
  String showingTrailsForContacts(int count) {
    return 'Показаны треки для $count контактов';
  }

  @override
  String get individualContactTrails => 'Индивидуальные треки контактов';

  @override
  String get deviceInformation => 'Информация об устройстве';

  @override
  String get bleName => 'Имя BLE';

  @override
  String get meshName => 'Имя в сети Mesh';

  @override
  String get notSet => 'Не задано';

  @override
  String get model => 'Модель';

  @override
  String get version => 'Версия';

  @override
  String get buildDate => 'Дата сборки';

  @override
  String get firmware => 'Прошивка';

  @override
  String get maxContacts => 'Макс. контактов';

  @override
  String get maxChannels => 'Макс. каналов';

  @override
  String get publicInfo => 'Публичная информация';

  @override
  String get meshNetworkName => 'Название сети Mesh';

  @override
  String get nameBroadcastInMesh => 'Имя, транслируемое в mesh-объявлениях';

  @override
  String get telemetryAndLocationSharing => 'Телеметрия и передача местоположения';

  @override
  String get lat => 'Ш';

  @override
  String get lon => 'Д';

  @override
  String get useCurrentLocation => 'Использовать текущее местоположение';

  @override
  String get noneUnknown => 'Нет/Неизвестно';

  @override
  String get chatNode => 'Узел чата';

  @override
  String get repeater => 'Ретранслятор';

  @override
  String get roomChannel => 'Комната/Канал';

  @override
  String typeNumber(int number) {
    return 'Тип $number';
  }

  @override
  String copiedToClipboardShort(String label) {
    return '$label скопировано в буфер обмена';
  }

  @override
  String failedToSave(String error) {
    return 'Не удалось сохранить: $error';
  }

  @override
  String failedToGetLocation(String error) {
    return 'Не удалось получить местоположение: $error';
  }

  @override
  String get sarTemplates => 'Шаблоны SAR';

  @override
  String get manageSarTemplates => 'Управление шаблонами целеуказания';

  @override
  String get addTemplate => 'Добавить шаблон';

  @override
  String get editTemplate => 'Изменить шаблон';

  @override
  String get deleteTemplate => 'Удалить шаблон';

  @override
  String get templateName => 'Название шаблона';

  @override
  String get templateNameHint => 'например, Найденный человек';

  @override
  String get templateEmoji => 'Эмодзи';

  @override
  String get emojiRequired => 'Требуется эмодзи';

  @override
  String get nameRequired => 'Требуется название';

  @override
  String get templateDescription => 'Описание (необязательно)';

  @override
  String get templateDescriptionHint => 'Добавьте дополнительный контекст...';

  @override
  String get templateColor => 'Цвет';

  @override
  String get previewFormat => 'Предпросмотр (формат сообщения SAR)';

  @override
  String get importFromClipboard => 'Импорт';

  @override
  String get exportToClipboard => 'Экспорт';

  @override
  String deleteTemplateConfirmation(String name) {
    return 'Удалить шаблон \'$name\'?';
  }

  @override
  String get templateAdded => 'Шаблон добавлен';

  @override
  String get templateUpdated => 'Шаблон обновлён';

  @override
  String get templateDeleted => 'Шаблон удалён';

  @override
  String templatesImported(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Импортировано $count шаблонов',
      one: 'Импортирован 1 шаблон',
      zero: 'Шаблоны не импортированы',
    );
    return '$_temp0';
  }

  @override
  String templatesExported(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count шаблонов экспортировано в буфер обмена',
      one: '1 шаблон экспортирован в буфер обмена',
    );
    return '$_temp0';
  }

  @override
  String get resetToDefaults => 'Сбросить до умолчаний';

  @override
  String get resetToDefaultsConfirmation =>
      'Все пользовательские шаблоны будут удалены и восстановлены 4 шаблона по умолчанию. Продолжить?';

  @override
  String get reset => 'Сбросить';

  @override
  String get resetComplete => 'Шаблоны сброшены до умолчаний';

  @override
  String get noTemplates => 'Шаблоны недоступны';

  @override
  String get tapAddToCreate => 'Нажмите +, чтобы создать первый шаблон';

  @override
  String get ok => 'ОК';

  @override
  String get permissionsSection => 'Разрешения';

  @override
  String get locationPermission => 'Разрешение геолокации';

  @override
  String get checking => 'Проверка...';

  @override
  String get locationPermissionGrantedAlways => 'Разрешено (всегда)';

  @override
  String get locationPermissionGrantedWhileInUse =>
      'Разрешено (при использовании)';

  @override
  String get locationPermissionDeniedTapToRequest =>
      'Запрещено — нажмите для запроса';

  @override
  String get locationPermissionPermanentlyDeniedOpenSettings =>
      'Запрещено навсегда — откройте настройки';

  @override
  String get locationPermissionDialogContent =>
      'Доступ к геолокации запрещён навсегда. Включите его в настройках устройства для GPS-трекинга и обмена местоположением.';

  @override
  String get openSettings => 'Открыть настройки';

  @override
  String get locationPermissionGranted => 'Разрешение геолокации получено!';

  @override
  String get locationPermissionRequiredForGps =>
      'Разрешение геолокации необходимо для GPS-трекинга и обмена местоположением.';

  @override
  String get locationPermissionAlreadyGranted =>
      'Разрешение геолокации уже предоставлено.';

  @override
  String get sarNavyBlue => 'SAR Тёмно-синяя';

  @override
  String get sarNavyBlueDescription => 'Профессиональный / оперативный режим';

  @override
  String get selectRecipient => 'Выбрать получателя';

  @override
  String get broadcastToAllNearby => 'Трансляция всем ближайшим';

  @override
  String get searchRecipients => 'Поиск получателей...';

  @override
  String get noContactsFound => 'Контакты не найдены';

  @override
  String get noRoomsFound => 'Комнаты не найдены';

  @override
  String get noContactsOrRoomsAvailable => 'Нет доступных контактов или комнат';

  @override
  String get noRecipientsAvailable => 'Нет доступных получателей';

  @override
  String get noChannelsFound => 'Каналы не найдены';

  @override
  String get messagesWillBeSentToPublicChannel =>
      'Сообщения будут отправлены в публичный канал';

  @override
  String get newMessage => 'Новое сообщение';

  @override
  String get channel => 'Канал';

  @override
  String get samplePoliceLead => 'Руководитель группы полиции';

  @override
  String get sampleDroneOperator => 'Оператор дрона';

  @override
  String get sampleFirefighterAlpha => 'Пожарный';

  @override
  String get sampleMedicCharlie => 'Медик';

  @override
  String get sampleCommandDelta => 'Командование';

  @override
  String get sampleFireEngine => 'Пожарная машина';

  @override
  String get sampleAirSupport => 'Авиационная поддержка';

  @override
  String get sampleBaseCoordinator => 'Базовый координатор';

  @override
  String get channelEmergency => 'Аварийный';

  @override
  String get channelCoordination => 'Координация';

  @override
  String get channelUpdates => 'Обновления';

  @override
  String get sampleTeamMember => 'Тестовый член команды';

  @override
  String get sampleScout => 'Тестовый разведчик';

  @override
  String get sampleBase => 'Тестовая база';

  @override
  String get sampleSearcher => 'Тестовый поисковик';

  @override
  String get sampleObjectBackpack => ' Найден рюкзак синего цвета';

  @override
  String get sampleObjectVehicle => ' Брошенный автомобиль — установить владельца';

  @override
  String get sampleObjectCamping => ' Обнаружено туристическое снаряжение';

  @override
  String get sampleObjectTrailMarker => ' Указатель тропы найден вне маршрута';

  @override
  String get sampleMsgAllTeamsCheckIn => 'Всем группам: сообщить о готовности';

  @override
  String get sampleMsgWeatherUpdate => 'Погода: ясно, температура 18°C';

  @override
  String get sampleMsgBaseCamp => 'Базовый лагерь развёрнут у места сбора';

  @override
  String get sampleMsgTeamAlpha => 'Группа выдвигается в сектор 2';

  @override
  String get sampleMsgRadioCheck => 'Проверка связи — всем станциям ответить';

  @override
  String get sampleMsgWaterSupply => 'Вода доступна на контрольной точке 3';

  @override
  String get sampleMsgTeamBravo => 'Группа докладывает: сектор 1 чист';

  @override
  String get sampleMsgEtaRallyPoint => 'Прибытие на место сбора: 15 минут';

  @override
  String get sampleMsgSupplyDrop => 'Сброс снаряжения подтверждён на 14:00';

  @override
  String get sampleMsgDroneSurvey =>
      'Разведка дроном завершена — ничего не обнаружено';

  @override
  String get sampleMsgTeamCharlie => 'Группа запрашивает подкрепление';

  @override
  String get sampleMsgRadioDiscipline =>
      'Всем подразделениям: соблюдать радиодисциплину';

  @override
  String get sampleMsgUrgentMedical =>
      'СРОЧНО: нужна медицинская помощь в секторе 4';

  @override
  String get sampleMsgAdultMale => ' Взрослый мужчина, в сознании';

  @override
  String get sampleMsgFireSpotted => 'Обнаружен пожар — координаты следуют';

  @override
  String get sampleMsgSpreadingRapidly => ' Распространяется быстро!';

  @override
  String get sampleMsgPriorityHelicopter =>
      'ПРИОРИТЕТ: нужна поддержка вертолёта';

  @override
  String get sampleMsgMedicalTeamEnRoute =>
      'Медицинская группа движется к вашему местоположению';

  @override
  String get sampleMsgEvacHelicopter =>
      'Вертолёт эвакуации: прибытие через 10 минут';

  @override
  String get sampleMsgEmergencyResolved =>
      'Чрезвычайная ситуация ликвидирована — опасности нет';

  @override
  String get sampleMsgEmergencyStagingArea => ' Аварийное место сбора';

  @override
  String get sampleMsgEmergencyServices =>
      'Аварийные службы уведомлены и реагируют';

  @override
  String get sampleAlphaTeamLead => 'Руководитель группы';

  @override
  String get sampleBravoScout => 'Разведчик';

  @override
  String get sampleCharlieMedic => 'Медик';

  @override
  String get sampleDeltaNavigator => 'Навигатор';

  @override
  String get sampleEchoSupport => 'Поддержка';

  @override
  String get sampleBaseCommand => 'Базовое командование';

  @override
  String get sampleFieldCoordinator => 'Полевой координатор';

  @override
  String get sampleMedicalTeam => 'Медицинская группа';

  @override
  String get mapDrawing => 'Рисунок на карте';

  @override
  String get navigateToDrawing => 'Перейти к рисунку';

  @override
  String get copyCoordinates => 'Копировать координаты';

  @override
  String get hideFromMap => 'Скрыть с карты';

  @override
  String get lineDrawing => 'Линия';

  @override
  String get rectangleDrawing => 'Прямоугольник';

  @override
  String get coordinatesCopiedToClipboard =>
      'Координаты скопированы в буфер обмена';

  @override
  String get manualCoordinates => 'Ввод координат вручную';

  @override
  String get enterCoordinatesManually => 'Ввести координаты вручную';

  @override
  String get latitudeLabel => 'Широта';

  @override
  String get longitudeLabel => 'Долгота';

  @override
  String get invalidLatitude => 'Неверная широта (от -90 до 90)';

  @override
  String get invalidLongitude => 'Неверная долгота (от -180 до 180)';

  @override
  String get exampleCoordinates => 'Пример: 55.7558, 37.6173';

  @override
  String get drawingShared => 'Рисунок на карте';

  @override
  String get drawingHidden => 'Рисунок скрыт с карты';

  @override
  String alreadyShared(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count уже передано',
      one: '1 уже передан',
    );
    return '$_temp0';
  }

  @override
  String newDrawingsShared(int count, String plural) {
    return 'Передано $count новых рисунк$plural';
  }

  @override
  String get shareDrawing => 'Поделиться рисунком';

  @override
  String get shareWithAllNearbyDevices =>
      'Поделиться со всеми ближайшими устройствами';

  @override
  String get shareToRoom => 'Отправить в комнату';

  @override
  String get sendToPersistentStorage =>
      'Отправить в постоянное хранилище комнаты';

  @override
  String get deleteDrawingConfirm =>
      'Вы уверены, что хотите удалить этот рисунок?';

  @override
  String get drawingDeleted => 'Рисунок удалён';

  @override
  String yourDrawingsCount(int count) {
    return 'Ваши рисунки ($count)';
  }

  @override
  String get shared => 'Передано';

  @override
  String get line => 'Линия';

  @override
  String get rectangle => 'Прямоугольник';

  @override
  String get updateAvailable => 'Доступно обновление';

  @override
  String get currentVersion => 'Текущая';

  @override
  String get latestVersion => 'Последняя';

  @override
  String get downloadUpdate => 'Скачать';

  @override
  String get updateLater => 'Позже';

  @override
  String get cadastralParcels => 'Кадастровые участки';

  @override
  String get forestRoads => 'Лесные дороги';

  @override
  String get showCadastralParcels => 'Показать кадастровые участки';

  @override
  String get showForestRoads => 'Показать лесные дороги';

  @override
  String get wmsOverlays => 'WMS-наложения';

  @override
  String get hikingTrails => 'Туристические маршруты';

  @override
  String get mainRoads => 'Главные дороги';

  @override
  String get houseNumbers => 'Номера домов';

  @override
  String get fireHazardZones => 'Пожароопасные зоны';

  @override
  String get historicalFires => 'Исторические пожары';

  @override
  String get firebreaks => 'Противопожарные просеки';

  @override
  String get krasFireZones => 'Пожарные зоны Краса';

  @override
  String get placeNames => 'Названия мест';

  @override
  String get municipalityBorders => 'Границы муниципалитетов';

  @override
  String get topographicMap => 'Топографическая карта 1:25000';

  @override
  String get recentMessages => 'Последние сообщения';

  @override
  String get addChannel => 'Добавить канал';

  @override
  String get channelName => 'Название канала';

  @override
  String get channelNameHint => 'например, Группа спасения Альфа';

  @override
  String get channelSecret => 'Секрет канала';

  @override
  String get channelSecretHint => 'Общий пароль для этого канала';

  @override
  String get channelSecretHelp =>
      'Этот секрет необходимо передать всем членам команды, которым нужен доступ к каналу';

  @override
  String get channelTypesInfo =>
      'Hash-каналы (#команда): секрет генерируется из названия автоматически. Одно название = один канал на всех устройствах.\n\nЗакрытые каналы: используется явный секрет. Войти могут только те, у кого есть секрет.';

  @override
  String get hashChannelInfo =>
      'Hash-канал: секрет будет автоматически создан из названия. Все, кто использует одно и то же имя, окажутся в одном канале.';

  @override
  String get channelNameRequired => 'Требуется название канала';

  @override
  String get channelNameTooLong =>
      'Название канала не должно превышать 31 символ';

  @override
  String get channelSecretRequired => 'Требуется секрет канала';

  @override
  String get channelSecretTooLong =>
      'Секрет канала не должен превышать 32 символа';

  @override
  String get invalidAsciiCharacters => 'Разрешены только символы ASCII';

  @override
  String get channelCreatedSuccessfully => 'Канал успешно создан';

  @override
  String channelCreationFailed(String error) {
    return 'Не удалось создать канал: $error';
  }

  @override
  String get deleteChannel => 'Удалить канал';

  @override
  String deleteChannelConfirmation(String channelName) {
    return 'Вы уверены, что хотите удалить канал \"$channelName\"? Это действие нельзя отменить.';
  }

  @override
  String get channelDeletedSuccessfully => 'Канал успешно удалён';

  @override
  String channelDeletionFailed(String error) {
    return 'Не удалось удалить канал: $error';
  }

  @override
  String get allChannelSlotsInUse =>
      'Все слоты каналов заняты (максимум 39 пользовательских каналов)';

  @override
  String get createChannel => 'Создать канал';

  @override
  String get wizardBack => 'Назад';

  @override
  String get wizardSkip => 'Пропустить';

  @override
  String get wizardNext => 'Далее';

  @override
  String get wizardGetStarted => 'Начать';

  @override
  String get wizardWelcomeTitle => 'Добро пожаловать в MeshCore SAR';

  @override
  String get wizardWelcomeDescription =>
      'Мощный инструмент связи вне сети для поисково-спасательных операций. Поддерживайте связь с командой через mesh-радио, когда традиционные сети недоступны.';

  @override
  String get wizardConnectingTitle => 'Подключение к радиоустройству';

  @override
  String get wizardConnectingDescription =>
      'Подключите смартфон к радиоустройству MeshCore по Bluetooth для связи вне сети.';

  @override
  String get wizardConnectingFeature1 => 'Поиск ближайших устройств MeshCore';

  @override
  String get wizardConnectingFeature2 =>
      'Сопряжение с радиоустройством по Bluetooth';

  @override
  String get wizardConnectingFeature3 =>
      'Работает полностью офлайн — интернет не нужен';

  @override
  String get wizardSimpleModeTitle => 'Простой режим';

  @override
  String get wizardSimpleModeDescription =>
      'Впервые работаете с mesh-сетью? Включите простой режим для упрощённого интерфейса с основными функциями.';

  @override
  String get wizardSimpleModeFeature1 =>
      'Удобный для новичков интерфейс с основными функциями';

  @override
  String get wizardSimpleModeFeature2 =>
      'Переключиться в расширенный режим можно в любое время в настройках';

  @override
  String get wizardChannelTitle => 'Каналы';

  @override
  String get wizardChannelDescription =>
      'Транслируйте сообщения всем участникам канала — идеально для общих объявлений и координации команды.';

  @override
  String get wizardChannelFeature1 =>
      'Публичный канал для общей связи команды';

  @override
  String get wizardChannelFeature2 =>
      'Создавайте пользовательские каналы для отдельных групп';

  @override
  String get wizardChannelFeature3 =>
      'Сообщения автоматически ретранслируются через mesh';

  @override
  String get wizardContactsTitle => 'Контакты';

  @override
  String get wizardContactsDescription =>
      'Члены вашей команды появляются автоматически по мере подключения к mesh-сети. Отправляйте им личные сообщения или просматривайте их местоположение.';

  @override
  String get wizardContactsFeature1 => 'Контакты обнаруживаются автоматически';

  @override
  String get wizardContactsFeature2 => 'Отправка личных сообщений';

  @override
  String get wizardContactsFeature3 =>
      'Просмотр уровня заряда и времени последнего появления';

  @override
  String get wizardMapTitle => 'Карта и местоположение';

  @override
  String get wizardMapDescription =>
      'Отслеживайте команду в реальном времени и отмечайте важные места для поисково-спасательных операций.';

  @override
  String get wizardMapFeature1 =>
      'Маркеры SAR для найденных людей, пожаров и мест сбора';

  @override
  String get wizardMapFeature2 =>
      'GPS-отслеживание членов команды в реальном времени';

  @override
  String get wizardMapFeature3 =>
      'Загрузка офлайн-карт для отдалённых районов';

  @override
  String get wizardMapFeature4 =>
      'Рисование фигур и обмен тактической информацией';

  @override
  String get viewWelcomeTutorial => 'Просмотреть обучение';

  @override
  String get allTeamContacts => 'Все контакты команды';

  @override
  String directMessagesInfo(int count) {
    return 'Личные сообщения с подтверждением. Отправлено $count членам команды.';
  }

  @override
  String sarMarkerSentToContacts(int count) {
    return 'Маркер SAR отправлен $count контактам';
  }

  @override
  String get noContactsAvailable => 'Нет доступных контактов команды';

  @override
  String get reply => 'Ответить';

  @override
  String get technicalDetails => 'Технические детали';

  @override
  String get messageTechnicalDetails => 'Технические детали сообщения';

  @override
  String get linkQuality => 'Качество связи';

  @override
  String get delivery => 'Доставка';

  @override
  String get status => 'Статус';

  @override
  String get expectedAckTag => 'Ожидаемый тег ACK';

  @override
  String get roundTrip => 'Время отклика';

  @override
  String get retryAttempt => 'Попытка повтора';

  @override
  String get floodFallback => 'Широковещательный резерв';

  @override
  String get identity => 'Идентификатор';

  @override
  String get messageId => 'ID сообщения';

  @override
  String get sender => 'Отправитель';

  @override
  String get senderKey => 'Ключ отправителя';

  @override
  String get recipient => 'Получатель';

  @override
  String get recipientKey => 'Ключ получателя';

  @override
  String get voice => 'Голос';

  @override
  String get voiceId => 'ID голоса';

  @override
  String get envelope => 'Конверт';

  @override
  String get sessionProgress => 'Прогресс сессии';

  @override
  String get complete => 'Завершено';

  @override
  String get rawDump => 'Необработанные данные';

  @override
  String get cannotRetryMissingRecipient =>
      'Повтор невозможен: нет информации о получателе';

  @override
  String get voiceUnavailable => 'Голос сейчас недоступен';

  @override
  String get requestingVoice => 'Запрос голоса';
}
