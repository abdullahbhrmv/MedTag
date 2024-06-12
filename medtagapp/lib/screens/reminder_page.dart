import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({super.key});

  @override
  _ReminderPageState createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  List<Reminder> reminders = [];

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('reminders').get();
    setState(() {
      reminders = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Reminder(
          id: doc.id,
          drugName: data['drugName'],
          morningTime: data['morningTime'] != null
              ? TimeOfDay(
                  hour: (data['morningTime'] as Map)['hour'],
                  minute: (data['morningTime'] as Map)['minute'],
                )
              : null,
          afternoonTime: data['afternoonTime'] != null
              ? TimeOfDay(
                  hour: (data['afternoonTime'] as Map)['hour'],
                  minute: (data['afternoonTime'] as Map)['minute'],
                )
              : null,
          eveningTime: data['eveningTime'] != null
              ? TimeOfDay(
                  hour: (data['eveningTime'] as Map)['hour'],
                  minute: (data['eveningTime'] as Map)['minute'],
                )
              : null,
        );
      }).toList();
    });
  }

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
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
              ),
              onPressed: () {
                _showAddReminderDialog(context);
              },
              child: const Text(
                'Hatırlatma Ekle',
                style: TextStyle(
                  fontFamily: "Brand-Regular",
                  color: Color(0xFF67b8de),
                  fontSize: 15,
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
                      title: Text(
                        reminder.drugName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: "Brand-Regular",
                        ),
                      ),
                      subtitle: Text(
                        'Sabah: ${reminder.morningTime != null ? reminder.morningTime!.format(context) : 'Yok'}\n'
                        'Öğlen: ${reminder.afternoonTime != null ? reminder.afternoonTime!.format(context) : 'Yok'}\n'
                        'Akşam: ${reminder.eveningTime != null ? reminder.eveningTime!.format(context) : 'Yok'}',
                        style: const TextStyle(fontFamily: "Brand-Regular"),
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
      backgroundColor: const Color(0xFFE8F8FF),
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
              title: const Text(
                'Hatırlatma Ekle',
                style: TextStyle(
                  fontFamily: "Brand-Regular",
                ),
              ),
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
                        labelStyle: TextStyle(
                          fontFamily: "Brand-Regular",
                        ),
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
                  child: const Text(
                    'İptal',
                    style: TextStyle(
                      fontFamily: "Brand-Regular",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    Reminder newReminder = Reminder(
                      drugName: tempDrugName,
                      morningTime: tempMorningTime,
                      afternoonTime: tempAfternoonTime,
                      eveningTime: tempEveningTime,
                    );

                    DocumentReference docRef = await FirebaseFirestore.instance
                        .collection('reminders')
                        .add(newReminder.toMap());

                    setState(() {
                      reminders.add(newReminder.copyWith(id: docRef.id));
                    });

                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Ekle',
                    style: TextStyle(
                      fontFamily: "Brand-Regular",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
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
            child: Text(
              selectedTime != null ? selectedTime.format(context) : 'Saat Seç',
              style: const TextStyle(
                fontFamily: "Brand-Regular",
              ),
            ),
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
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('reminders')
                    .doc(reminders[index].id)
                    .delete();

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
  final String? id;
  final String drugName;
  final TimeOfDay? morningTime;
  final TimeOfDay? afternoonTime;
  final TimeOfDay? eveningTime;

  Reminder({
    this.id,
    required this.drugName,
    this.morningTime,
    this.afternoonTime,
    this.eveningTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'drugName': drugName,
      'morningTime': morningTime != null
          ? {'hour': morningTime!.hour, 'minute': morningTime!.minute}
          : null,
      'afternoonTime': afternoonTime != null
          ? {'hour': afternoonTime!.hour, 'minute': afternoonTime!.minute}
          : null,
      'eveningTime': eveningTime != null
          ? {'hour': eveningTime!.hour, 'minute': eveningTime!.minute}
          : null,
    };
  }

  Reminder copyWith({String? id}) {
    return Reminder(
      id: id ?? this.id,
      drugName: this.drugName,
      morningTime: this.morningTime,
      afternoonTime: this.afternoonTime,
      eveningTime: this.eveningTime,
    );
  }
}
