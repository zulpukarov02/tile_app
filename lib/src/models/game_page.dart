import 'package:flutter/material.dart';
import 'dart:async'; // Для работы с таймером
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GamePage extends StatefulWidget {
  final int gridSize;

  const GamePage({
    super.key,
    required this.gridSize, // Добавляем обязательный параметр gridSize
  });

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late int currentGridSize;
  late List<int?> tiles; // Список числовых плиток, null для некликабельных
  int timerSeconds = 0; // Таймер в секундах (инициализируем сразу)
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    currentGridSize = widget.gridSize; // Инициализируем начальный размер сетки
    setTimerForLevel(); // Устанавливаем таймер в зависимости от уровня
    resetTiles(); // Сброс значений плиток при старте
    startTimer(); // Запуск таймера
  }

  // Метод для установки таймера в зависимости от уровня
  void setTimerForLevel() {
    if (currentGridSize == 4) {
      timerSeconds = 89; // Easy: 1 минута 29 секунд
    } else if (currentGridSize == 5) {
      timerSeconds = 149; // Medium: 2 минуты 29 секунд
    } else if (currentGridSize == 6) {
      timerSeconds = 209; // Hard: 3 минуты 29 секунд
    }
  }

  void updateGame(int newGridSize) {
    setState(() {
      currentGridSize = newGridSize; // Меняем размер сетки
      setTimerForLevel(); // Обновляем таймер
      resetTiles(); // Сбрасываем плитки
    });
  }

  double getTopPadding() {
    if (currentGridSize == 4) {
      return 180.0; // Меньшее расстояние сверху для маленького уровня
    } else if (currentGridSize == 5) {
      return 170.0.w; // Среднее расстояние сверху
    } else {
      return 140.0.w; // Большее расстояние сверху для большого уровня
    }
  }

  double getleftPadding() {
    if (currentGridSize == 4) {
      return 50.0.w; // Меньшее расстояние сверху для маленького уровня
    } else if (currentGridSize == 5) {
      return 30.0.w; // Среднее расстояние сверху
    } else {
      return 8.0.w; // Большее расстояние сверху для большого уровня
    }
  }

  double getrightPadding() {
    if (currentGridSize == 4) {
      return 79.0.w; // Меньшее расстояние сверху для маленького уровня
    } else if (currentGridSize == 5) {
      return 50.0.w; // Среднее расстояние сверху
    } else {
      return 25.0.w; // Большее расстояние сверху для большого уровня
    }
  }

  void resetTiles() {
    setState(() {
      tiles = List.generate(currentGridSize * currentGridSize, (index) {
        int row = index ~/ currentGridSize;
        int col = index % currentGridSize;

        if (index == 0 || row == 0 || col == 0) {
          return null; // Убираем плитки первого ряда и столбца, включая угловую
        } else {
          return 1; // Кликабельные плитки
        }
      });
    });
  }

  void startTimer() {
    if (_timer != null) {
      _timer!.cancel(); // Остановка предыдущего таймера
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerSeconds > 0) {
        setState(() {
          timerSeconds--;
        });
      } else {
        timer.cancel();
        resetTiles(); // Сброс игры после завершения таймера
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Отменяем таймер при выходе из экрана
    super.dispose();
  }

  void incrementTile(int index) {
    if (tiles[index] != null) {
      setState(() {
        tiles[index] = (tiles[index]! % 5) +
            1; // Увеличиваем значение и сбрасываем после 5
      });
    }
  }

  BoxDecoration getTileDecoration(int? value, int index) {
    if (value == null) {
      if (index == 0) {
        return BoxDecoration(
          color: const Color(0xffFFFCF7), // Особый цвет для угловой плитки
          borderRadius: BorderRadius.circular(8),
        );
      }
      return BoxDecoration(
        gradient: const RadialGradient(
          colors: [
            Color(0xff57EED7), // Начальный цвет
            Color(0xff10AD97), // Конечный цвет
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 65, 81, 74), // Тень снизу
            offset: const Offset(0, 6), // Смещение тени вниз
            blurRadius: 8, // Размытие тени
          ),
        ],
        borderRadius: BorderRadius.circular(8),
      );
    }

    switch (value) {
      case 1:
        return BoxDecoration(
          color: const Color(0xff74BD3E), // Основной цвет плитки
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.green.shade900, // Тень снизу
              offset: const Offset(0, 6), // Смещение тени вниз
              blurRadius: 8, // Размытие тени
            ),
          ],
        );
      case 2:
        return BoxDecoration(
          color: const Color(0xff3E4DBD), // Основной цвет плитки
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.shade900, // Тень снизу
              offset: const Offset(0, 6), // Смещение тени вниз
              blurRadius: 8, // Размытие тени
            ),
          ],
        );
      case 3:
        return BoxDecoration(
          color: const Color(0xff8617AB), // Основной цвет плитки
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.shade900, // Тень снизу
              offset: const Offset(0, 6), // Смещение тени вниз
              blurRadius: 8, // Размытие тени
            ),
          ],
        );
      case 4:
        return BoxDecoration(
          color: const Color(0xffFF8531), // Основной цвет плитки
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.shade900, // Тень снизу
              offset: const Offset(0, 6), // Смещение тени вниз
              blurRadius: 8, // Размытие тени
            ),
          ],
        );
      case 5:
        return BoxDecoration(
          color: const Color(0xffDE1717), // Основной цвет плитки
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.red.shade900, // Тень снизу
              offset: const Offset(0, 6), // Смещение тени вниз
              blurRadius: 8, // Размытие тени
            ),
          ],
        );
      default:
        return BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade900, // Тень для пустых клеток
              offset: const Offset(0, 6), // Смещение тени вниз
              blurRadius: 8, // Размытие тени
            ),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFCF7),
      body: Stack(
        children: [
          Positioned(
            bottom: 655.h,
            child: Image.asset(
              'assets/images/image_smallbg.png',
              width: 375.w,
            ),
          ),

          // Игровое поле
          Padding(
            padding: EdgeInsets.only(
                top: getTopPadding(),
                left: getleftPadding(),
                right: getrightPadding()),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: currentGridSize,
              ),
              itemCount: tiles.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => incrementTile(index),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 22.h, 0.w, 0),
                    child: Container(
                      width: 42.w,
                      height: 44.h,
                      alignment: Alignment.center,
                      decoration: getTileDecoration(tiles[index], index),
                      child: tiles[index] != null
                          ? Transform.translate(
                              offset: const Offset(0, -3),
                              child: Text(
                                tiles[index].toString(),
                                style: TextStyle(
                                    fontSize: 30.sp,
                                    color: Colors.white,
                                    fontFamily: 'Share',
                                    fontWeight: FontWeight.w700),
                              ),
                            )
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),

          Positioned(
            top: 655.h,
            child: Image.asset(
              'assets/images/image_smallbg2.png',
              width: 375.w,
            ),
          ),

          Positioned(
            top: 683.h,
            left: 16.w,
            child: Row(
              children: [
                // Таймер
                Container(
                  width: 149.w,
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: const Color(0xffCC620C),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(14.w, 6.5.h, 9.w, 6.5.h),
                    child: Row(
                      children: [
                        Text(
                          'timer',
                          style: TextStyle(
                            fontSize: 18,
                            color: const Color(0xffFFFFFF).withOpacity(0.6),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 30.w),
                        Text(
                          '${timerSeconds ~/ 60}:${(timerSeconds % 60).toString().padLeft(2, '0')}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Color(0xffFFFFFF),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 25.w),
                // Кнопка "Рестарт"
                GestureDetector(
                  onTap: resetTiles,
                  child: Image.asset(
                    'assets/images/button_restart.png',
                    width: 179.w,
                    height: 44.h,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 735.h,
            left: 18.w,
            right: 20.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    backgroundColor: const Color(0xff9BD652),
                  ),
                  onPressed: () {
                    updateGame(4); // Смена уровня на Easy (3x3)
                  },
                  child: const Text(
                    "level 1",
                    style: TextStyle(
                      fontFamily: 'Share',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    backgroundColor: const Color(0xff9BD652),
                  ),
                  onPressed: () {
                    updateGame(5); // Смена уровня на Medium (4x4)
                  },
                  child: const Text(
                    "level 2",
                    style: TextStyle(
                      fontFamily: 'Share',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    backgroundColor: const Color(0xff9BD652),
                  ),
                  onPressed: () {
                    updateGame(6); // Смена уровня на Hard (5x5)
                  },
                  child: const Text(
                    "level 3",
                    style: TextStyle(
                      fontFamily: 'Share',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
