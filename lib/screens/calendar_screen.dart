import 'package:flutter/material.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key, required void Function(Locale locale) onLocaleChange, required void Function() onThemeToggle});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  int _selectedIndex = 3; // Calendar tab selected
  DateTime selectedDate = DateTime.now();
  DateTime currentMonth = DateTime.now();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate based on selected index
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/chats');
        break;
      case 2:
        Navigator.pushNamed(context, '/institutions'); // ✅ NUEVO - Navega a instituciones
        break;
      case 3:
      // Already on calendar screen
        break;
      case 4:
        Navigator.pushNamed(context, '/settings');
        break;
    }
  }

  // Sample events data
  Map<DateTime, List<CalendarEvent>> events = {
    DateTime(2025, 5, 30): [
      CalendarEvent("Reunión de equipo", "10:00 AM", Colors.blue),
      CalendarEvent("Presentación cliente", "2:30 PM", Colors.green),
    ],
    DateTime(2025, 5, 31): [
      CalendarEvent("Entrevista", "9:00 AM", Colors.orange),
    ],
    DateTime(2025, 6, 1): [
      CalendarEvent("Workshop SmartSys", "11:00 AM", Colors.purple),
    ],
    DateTime(2025, 6, 3): [
      CalendarEvent("Revisión proyecto", "3:00 PM", Colors.red),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with centered logo and notification bell (igual que en home)
              Padding(
                padding: const EdgeInsets.only(left: 0, right: 0, top: 8.0, bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Empty container for spacing
                    const SizedBox(width: 24),
                    // Centered logo only
                    Image.asset(
                      'assets/logo.png',
                      width: 130,
                      height: 130,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.star_outline,
                          size: 130,
                          color: Color(0xFF41277A),
                        );
                      },
                    ),
                    // Notification bell with red dot
                    Stack(
                      children: [
                        const Icon(
                          Icons.notifications_outlined,
                          size: 24,
                          color: Colors.black54,
                        ),
                        Positioned(
                          right: 3,
                          top: 3,
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12), // Mismo espaciado que en home

              // Title and current date
              Text(
                "Calendario",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _getFormattedDate(DateTime.now()),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),

              // Calendar widget
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Month navigation
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              currentMonth = DateTime(currentMonth.year, currentMonth.month - 1);
                            });
                          },
                          icon: Icon(Icons.chevron_left, color: Color(0xFF41277A)),
                        ),
                        Text(
                          _getMonthYearString(currentMonth),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              currentMonth = DateTime(currentMonth.year, currentMonth.month + 1);
                            });
                          },
                          icon: Icon(Icons.chevron_right, color: Color(0xFF41277A)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Days of week header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom']
                          .map((day) => Text(
                        day,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      ))
                          .toList(),
                    ),
                    const SizedBox(height: 16),

                    // Calendar grid
                    _buildCalendarGrid(),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Today's events
              Text(
                "Eventos de hoy",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Events list
              Expanded(
                child: _buildEventsList(),
              ),
            ],
          ),
        ),
      ),

      // Floating action button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddEventDialog();
        },
        backgroundColor: const Color(0xFF41277A),
        child: const Icon(Icons.add, color: Colors.white),
      ),

      // Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF41277A),
        unselectedItemColor: Colors.grey[400],
        onTap: _onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final lastDayOfMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0);
    final firstDayOfWeek = firstDayOfMonth.weekday;
    final daysInMonth = lastDayOfMonth.day;

    List<Widget> dayWidgets = [];

    // Add empty cells for days before the first day of the month
    for (int i = 1; i < firstDayOfWeek; i++) {
      dayWidgets.add(Container());
    }

    // Add day cells
    for (int day = 1; day <= daysInMonth; day++) {
      final currentDate = DateTime(currentMonth.year, currentMonth.month, day);
      final hasEvents = events.containsKey(currentDate);
      final isSelected = _isSameDay(currentDate, selectedDate);
      final isToday = _isSameDay(currentDate, DateTime.now());

      dayWidgets.add(
        GestureDetector(
          onTap: () {
            setState(() {
              selectedDate = currentDate;
            });
          },
          child: Container(
            margin: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isSelected
                  ? Color(0xFF41277A)
                  : isToday
                  ? Color(0xFF41277A).withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  day.toString(),
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : isToday
                        ? Color(0xFF41277A)
                        : Colors.black,
                    fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                if (hasEvents)
                  Container(
                    width: 6,
                    height: 6,
                    margin: EdgeInsets.only(top: 2),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Color(0xFF41277A),
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: dayWidgets,
    );
  }

  Widget _buildEventsList() {
    final todayEvents = events[_getDateOnly(selectedDate)] ?? [];

    if (todayEvents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_note,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              "No hay eventos para este día",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: todayEvents.length,
      itemBuilder: (context, index) {
        final event = todayEvents[index];
        return Container(
          margin: EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
          child: ListTile(
            leading: Container(
              width: 4,
              height: 40,
              decoration: BoxDecoration(
                color: event.color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            title: Text(
              event.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              event.time,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
            ),
            onTap: () {
              // Handle event tap
            },
          ),
        );
      },
    );
  }

  void _showAddEventDialog() {
    final titleController = TextEditingController();
    final timeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Agregar Evento"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "Título del evento",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: timeController,
              decoration: InputDecoration(
                labelText: "Hora (ej: 10:00 AM)",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty && timeController.text.isNotEmpty) {
                setState(() {
                  final dateKey = _getDateOnly(selectedDate);
                  if (events[dateKey] == null) {
                    events[dateKey] = [];
                  }
                  events[dateKey]!.add(
                    CalendarEvent(
                      titleController.text,
                      timeController.text,
                      Colors.blue,
                    ),
                  );
                });
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF41277A),
              foregroundColor: Colors.white,
            ),
            child: Text("Agregar"),
          ),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  DateTime _getDateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  String _getFormattedDate(DateTime date) {
    final months = [
      'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
    ];
    return '${date.day} de ${months[date.month - 1]}, ${date.year}';
  }

  String _getMonthYearString(DateTime date) {
    final months = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}

// Event model class
class CalendarEvent {
  final String title;
  final String time;
  final Color color;

  CalendarEvent(this.title, this.time, this.color);
}