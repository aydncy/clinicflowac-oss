class TimeSlot {
  final String slotId;
  final DateTime startTime;
  final DateTime endTime;
  final String doctorId;
  final bool available;
  final String? appointmentId;

  TimeSlot({
    required this.slotId,
    required this.startTime,
    required this.endTime,
    required this.doctorId,
    required this.available,
    this.appointmentId,
  });

  Duration get duration => endTime.difference(startTime);

  bool overlaps(TimeSlot other) {
    return startTime.isBefore(other.endTime) && 
           endTime.isAfter(other.startTime);
  }

  Map<String, dynamic> toJson() => {
    'slotId': slotId,
    'startTime': startTime.toIso8601String(),
    'endTime': endTime.toIso8601String(),
    'doctorId': doctorId,
    'available': available,
    'duration': '${duration.inMinutes} minutes',
    'appointmentId': appointmentId,
  };
}

class DoctorAvailability {
  final String doctorId;
  final Map<DateTime, List<TimeSlot>> schedule = {};
  final List<String> unavailableDates = [];
  final Duration defaultSlotDuration;

  DoctorAvailability({
    required this.doctorId,
    this.defaultSlotDuration = const Duration(minutes: 30),
  });

  void addAvailableHours(DateTime date, TimeOfDay startTime, TimeOfDay endTime) {
    final startDateTime = DateTime(date.year, date.month, date.day, startTime.hour, startTime.minute);
    final endDateTime = DateTime(date.year, date.month, date.day, endTime.hour, endTime.minute);

    final slots = <TimeSlot>[];
    var current = startDateTime;

    while (current.isBefore(endDateTime)) {
      final slotEnd = current.add(defaultSlotDuration);
      slots.add(TimeSlot(
        slotId: '${doctorId}_${current.millisecondsSinceEpoch}',
        startTime: current,
        endTime: slotEnd,
        doctorId: doctorId,
        available: true,
      ));
      current = slotEnd;
    }

    schedule[date] = slots;
    print('✅ Availability added for Dr. $doctorId on $date');
  }

  void markUnavailable(DateTime date) {
    unavailableDates.add(date.toString().split(' ')[0]);
    schedule.remove(date);
    print('⛔ Dr. $doctorId marked unavailable on $date');
  }

  List<TimeSlot> getAvailableSlots(DateTime date) {
    return schedule[date]?.where((slot) => slot.available).toList() ?? [];
  }

  Map<String, dynamic> toJson() => {
    'doctorId': doctorId,
    'schedule': {
      for (var entry in schedule.entries)
        entry.key.toString(): entry.value.map((s) => s.toJson()).toList(),
    },
    'unavailableDates': unavailableDates,
  };
}

class TimeOfDay {
  final int hour;
  final int minute;

  TimeOfDay({required this.hour, required this.minute});
}

class SchedulingEngine {
  final Map<String, DoctorAvailability> _doctorSchedules = {};
  final Map<String, TimeSlot> _bookedSlots = {};

  void registerDoctor(String doctorId) {
    _doctorSchedules[doctorId] = DoctorAvailability(doctorId: doctorId);
    print('✅ Doctor registered: $doctorId');
  }

  void setDoctorAvailability(
    String doctorId,
    DateTime date,
    TimeOfDay startTime,
    TimeOfDay endTime,
  ) {
    final availability = _doctorSchedules[doctorId];
    if (availability == null) {
      throw Exception('Doctor not found: $doctorId');
    }
    availability.addAvailableHours(date, startTime, endTime);
  }

  List<TimeSlot> getAvailableSlots(String doctorId, DateTime date) {
    final availability = _doctorSchedules[doctorId];
    if (availability == null) return [];
    return availability.getAvailableSlots(date);
  }

  bool bookSlot(String slotId, String appointmentId) {
    // Find slot across all doctors
    for (var availability in _doctorSchedules.values) {
      for (var dateSlots in availability.schedule.values) {
        final slot = dateSlots.firstWhere(
          (s) => s.slotId == slotId,
          orElse: () => TimeSlot(
            slotId: '',
            startTime: DateTime.now(),
            endTime: DateTime.now(),
            doctorId: '',
            available: false,
          ),
        );

        if (slot.slotId.isNotEmpty && slot.available) {
          final bookedSlot = TimeSlot(
            slotId: slot.slotId,
            startTime: slot.startTime,
            endTime: slot.endTime,
            doctorId: slot.doctorId,
            available: false,
            appointmentId: appointmentId,
          );
          _bookedSlots[slotId] = bookedSlot;
          print('✅ Slot booked: $slotId for appointment $appointmentId');
          return true;
        }
      }
    }
    return false;
  }

  bool cancelSlot(String slotId) {
    if (_bookedSlots.containsKey(slotId)) {
      _bookedSlots.remove(slotId);
      print('✅ Slot cancelled: $slotId');
      return true;
    }
    return false;
  }

  Map<String, dynamic> getScheduleStats() {
    int totalSlots = 0;
    int bookedSlots = 0;
    int availableSlots = 0;

    for (var availability in _doctorSchedules.values) {
      for (var dateSlots in availability.schedule.values) {
        totalSlots += dateSlots.length;
        bookedSlots += dateSlots.where((s) => !s.available).length;
        availableSlots += dateSlots.where((s) => s.available).length;
      }
    }

    return {
      'totalSlots': totalSlots,
      'bookedSlots': bookedSlots,
      'availableSlots': availableSlots,
      'utilizationRate': totalSlots == 0 
        ? 0 
        : '${((bookedSlots / totalSlots) * 100).toStringAsFixed(2)}%',
      'doctors': _doctorSchedules.length,
    };
  }

  Map<String, dynamic> getScheduleForDoctor(String doctorId) {
    final availability = _doctorSchedules[doctorId];
    if (availability == null) return {};
    return availability.toJson();
  }
}
