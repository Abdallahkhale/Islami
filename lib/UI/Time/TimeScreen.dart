import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:islami/Core/Assets/ImagesPath.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:islami/UI/Time/PrayerTimeData.dart';

class Timescreen extends StatefulWidget {
  const Timescreen({super.key});

  @override
  State<Timescreen> createState() => _TimescreenState();
}

class _TimescreenState extends State<Timescreen> {
  int _currentIndex = 2; 
  bool _isLoading = true;
  String _error = '';
  
  List<PrayerTime> prayerTimes = [];
  String gregorianDate = '';
  String hijriDate = '';
  String weekday = '';
  String nextPrayerTime = '';

  @override
  void initState() {
    super.initState();
    _fetchPrayerTimes();
  }

  Future<void> _fetchPrayerTimes() async {
    try {
      setState(() {
        _isLoading = true;
        _error = '';
      });

      final now = DateTime.now();
      final dateString = '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}';
      
      final url = 'https://api.aladhan.com/v1/timingsByCity/$dateString?city=cairo&country=egypt';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['code'] == 200) {
          _parsePrayerData(data['data']);
        } else {
          setState(() {
            _error = 'Failed to load prayer times';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _error = 'Network error occurred';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  void _parsePrayerData(Map<String, dynamic> data) {
    final timings = data['timings'] as Map<String, dynamic>?;
    final dateInfo = data['date'] as Map<String, dynamic>?;
    
    if (timings == null || dateInfo == null) {
      setState(() {
        _error = 'Invalid data received from API';
        _isLoading = false;
      });
      return;
    }
    


    final List<PrayerTime> prayers = [
      PrayerTime(
        name: 'Fajr', 
        time: _formatTime(timings['Fajr']?.toString() ?? '04:00'), 
        period: _getPeriod(timings['Fajr']?.toString() ?? '04:00')
      ),
      PrayerTime(
        name: 'Dhuhr', 
        time: _formatTime(timings['Dhuhr']?.toString() ?? '12:00'), 
        period: _getPeriod(timings['Dhuhr']?.toString() ?? '12:00')
      ),
      PrayerTime(
        name: 'ASR', 
        time: _formatTime(timings['Asr']?.toString() ?? '16:00'), 
        period: _getPeriod(timings['Asr']?.toString() ?? '16:00'),
        isActive: true
      ),
      PrayerTime(
        name: 'Maghrib', 
        time: _formatTime(timings['Maghrib']?.toString() ?? '19:00'), 
        period: _getPeriod(timings['Maghrib']?.toString() ?? '19:00')
      ),
      PrayerTime(
        name: 'Isha', 
        time: _formatTime(timings['Isha']?.toString() ?? '21:00'), 
        period: _getPeriod(timings['Isha']?.toString() ?? '21:00')
      ),
    ];



    final gregorian = dateInfo['gregorian'] as Map<String, dynamic>?;
    final hijri = dateInfo['hijri'] as Map<String, dynamic>?;
    
    setState(() {
      prayerTimes = prayers;
      gregorianDate = gregorian?['readable']?.toString() ?? 'Date not available';
      hijriDate = hijri != null 
          ? '${hijri['day']?.toString() ?? ''} ${hijri['month']?['en']?.toString() ?? ''}, ${hijri['year']?.toString() ?? ''}'
          : 'Hijri date not available';
      weekday = gregorian?['weekday']?['en']?.toString() ?? 'Day not available';
      nextPrayerTime = _calculateNextPrayer();
      _isLoading = false;
    });
  }

  String _formatTime(String time24) {
    try {

      final parts = time24.split(':');
      if (parts.length < 2) return time24; 
      
      int hour = int.tryParse(parts[0]) ?? 0;
      final minute = parts[1];
      
      if (hour == 0) {
        return '12:$minute';
      } else if (hour <= 12) {
        return '${hour.toString().padLeft(2, '0')}:$minute';
      } else {
        return '${(hour - 12).toString().padLeft(2, '0')}:$minute';
      }
    } catch (e) {
      return time24; 
    }
  }

  String _getPeriod(String time24) {
    try {
      final hour = int.tryParse(time24.split(':')[0]) ?? 0;
      return hour < 12 ? 'AM' : 'PM';
    } catch (e) {
      return 'AM'; 
    }
  }

  String _calculateNextPrayer() {
    if (prayerTimes.isEmpty) return '00:00';
    
    try {
      final now = DateTime.now();
      final currentTime = (now.hour +1) * 60 + now.minute ;
      
      for (final prayer in prayerTimes) {
        final prayerTime = _parseTimeToMinutes(prayer.time, prayer.period);
        if (prayerTime > currentTime) {
          final diff = prayerTime - currentTime;
          final hours = diff ~/ 60;
          final minutes = diff % 60;
          return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
        }
      }

      
      final fajrTime = _parseTimeToMinutes(prayerTimes[0].time, prayerTimes[0].period);
      final diff = (24 * 60) - currentTime + fajrTime;
      final hours = diff ~/ 60;
      final minutes = diff % 60;
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
    } catch (e) {
      return '00:00'; 

    }
  }

  int _parseTimeToMinutes(String time, String period) {
    try {
      final parts = time.split(':');
      if (parts.length < 2) return 0;
      
      int hour = int.tryParse(parts[0]) ?? 0;
      final minute = int.tryParse(parts[1]) ?? 0;
      
      if (period == 'PM' && hour != 12) {
        hour += 12;
      } else if (period == 'AM' && hour == 12) {
        hour = 0;
      }
      
      return hour * 60 + minute;
    } catch (e) {
      return 0; 
    }
  }

  

  String _formatDisplayYear(String date) {
    try {
      final parts = date.split(' ');
      if (parts.length >= 3) {
        return parts[2];
      }
      return '';
    } catch (e) {
      return '';
    }
  }

  String _formatHijriDate(String hijriDate) {
    try {

      final parts = hijriDate.split(' ');
      if (parts.length >= 2) {
        final month = parts[1].replaceAll(',', '');
        final monthShort = month.length > 3 ? month.substring(0, 3) : month;
        return '${parts[0]} $monthShort,';
      }
      return hijriDate;
    } catch (e) {
      return hijriDate;
    }
  }

  String _formatHijriYear(String hijriDate) {
    try {
      final parts = hijriDate.split(' ');
      if (parts.length >= 3) {
        return parts[2];
      }
      return '';
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImagesPath.TimeShadow),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          children: [
            Image.asset(ImagesPath.logo, height: 130, width: 220),
            const SizedBox(height: 20),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFE2BE7F), 
                      Color(0xFFB8563F), 
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : _error.isNotEmpty
                        ? Column(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 48,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                _error,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: _fetchPrayerTimes,
                                child: const Text('Retry'),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                    
                                      Text(
                                       '',
                                        style: const TextStyle(
                                          color: Colors.black87,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const Text(
                                        'Pray Time',
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        weekday,
                                        style: const TextStyle(
                                          color: Colors.black87,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        _formatHijriDate(hijriDate),
                                        style: const TextStyle(
                                          color: Colors.black87,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        _formatHijriYear(hijriDate),
                                        style: const TextStyle(
                                          color: Colors.black87,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              
                              CarouselSlider.builder(
                                itemCount: prayerTimes.length,
                                options: CarouselOptions(
                                  height: 150,
                                  viewportFraction: 0.4,
                                  enlargeCenterPage: true,
                                  initialPage: _currentIndex,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      _currentIndex = index;
                                    });
                                  },
                                ),
                                itemBuilder: (context, index, realIndex) {
                                  final prayer = prayerTimes[index];

                                  return Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 1),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFFB19768),
                                          Color(0xFF102020),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          prayer.name,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          prayer.time,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          prayer.period,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              
                              const SizedBox(height: 20),
                              
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Next Pray - ',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    nextPrayerTime,
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Icon(
                                    Icons.volume_up,
                                    color: Colors.black87,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ],
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

