import 'package:flutter/material.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({Key? key}) : super(key: key);

  @override
  _ReminderPageState createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  List<Reminder> reminders = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hatırlatıcı',
          style: TextStyle(
            fontFamily: "Brand-Regular",
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF67b8de),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                _showAddReminderDialog(context);
              },
              child: const Text(
                'Hatırlatma Ekle',
                style: TextStyle(
                  fontFamily: "Brand-Regular",
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: reminders.length,
                itemBuilder: (context, index) {
                  final reminder = reminders[index];
                  return Card(
                    child: ListTile(
                      title: Text(reminder.drugName),
                      subtitle: Text(
                        'Sabah: ${reminder.morningTime != null ? reminder.morningTime!.format(context) : 'Yok'}\n'
                        'Öğlen: ${reminder.afternoonTime != null ? reminder.afternoonTime!.format(context) : 'Yok'}\n'
                        'Akşam: ${reminder.eveningTime != null ? reminder.eveningTime!.format(context) : 'Yok'}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _showDeleteConfirmationDialog(context, index);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddReminderDialog(BuildContext context) {
    String tempDrugName = '';
    TimeOfDay? tempMorningTime;
    TimeOfDay? tempAfternoonTime;
    TimeOfDay? tempEveningTime;
    bool isMorningSelected = true;
    bool isAfternoonSelected = true;
    bool isEveningSelected = true;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Hatırlatma Ekle'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      onChanged: (value) {
                        tempDrugName = value;
                      },
                      decoration: const InputDecoration(
                        labelText: 'İlaç İsmi',
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildTimePicker(
                        'Sabah',
                        tempMorningTime,
                        (time) {
                          setState(() {
                            tempMorningTime = time;
                          });
                        },
                        isMorningSelected,
                        (value) {
                          setState(() {
                            isMorningSelected = value;
                            if (!value) tempMorningTime = null;
                          });
                        }),
                    _buildTimePicker(
                        'Öğlen',
                        tempAfternoonTime,
                        (time) {
                          setState(() {
                            tempAfternoonTime = time;
                          });
                        },
                        isAfternoonSelected,
                        (value) {
                          setState(() {
                            isAfternoonSelected = value;
                            if (!value) tempAfternoonTime = null;
                          });
                        }),
                    _buildTimePicker(
                        'Akşam',
                        tempEveningTime,
                        (time) {
                          setState(() {
                            tempEveningTime = time;
                          });
                        },
                        isEveningSelected,
                        (value) {
                          setState(() {
                            isEveningSelected = value;
                            if (!value) tempEveningTime = null;
                          });
                        }),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('İptal'),
                ),
                TextButton(
                  onPressed: () {
                    // This `setState` updates the state in the dialog, not in the parent widget
                    setState(() {
                      reminders.add(Reminder(
                        drugName: tempDrugName,
                        morningTime: tempMorningTime,
                        afternoonTime: tempAfternoonTime,
                        eveningTime: tempEveningTime,
                      ));
                    });
                    Navigator.of(context).pop(); // Close the dialog
                    // Use `setState` in the parent widget to update the UI
                    setState(() {});
                  },
                  child: const Text('Ekle'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildTimePicker(
      String label,
      TimeOfDay? selectedTime,
      Function(TimeOfDay) onTimeChanged,
      bool isSelected,
      Function(bool) onSelectionChanged) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: "Brand-Regular",
                ),
              ),
            ),
            Switch(
              value: isSelected,
              onChanged: onSelectionChanged,
            ),
          ],
        ),
        if (isSelected)
          ElevatedButton(
            onPressed: () async {
              final TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: selectedTime ?? TimeOfDay.now(),
              );
              if (pickedTime != null) {
                onTimeChanged(pickedTime);
              }
            },
            child: Text(selectedTime != null
                ? selectedTime.format(context)
                : 'Saat Seç'),
          ),
      ],
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Silme Onayı',
            style: TextStyle(
              fontFamily: "Brand-Regular",
              fontWeight: FontWeight.w300,
              color: Color(0xFF67b8de),
            ),
          ),
          content: const Text(
            'Bu hatırlatıcıyı silmek istediğinizden emin misiniz?',
            style: TextStyle(
              fontFamily: "Brand-Regular",
              fontSize: 15,
              color: Color(0xFF67b8de),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'İptal',
                style: TextStyle(
                  fontFamily: "Brand-Regular",
                  color: Color(0xFF67b8de),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  reminders.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: const Text(
                'Sil',
                style: TextStyle(
                  fontFamily: "Brand-Regular",
                  color: Color(0xFF67b8de),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class Reminder {
  final String drugName;
  final TimeOfDay? morningTime;
  final TimeOfDay? afternoonTime;
  final TimeOfDay? eveningTime;

  Reminder({
    required this.drugName,
    this.morningTime,
    this.afternoonTime,
    this.eveningTime,
  });
}
