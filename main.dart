import 'package:yaru/yaru.dart';
import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';

int hours_set = 0;
int minutes_set = 0;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setWindowMinSize(const Size(800, 400));
  setWindowMaxSize(const Size(800, 400));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return YaruTheme(
      builder: (context, yaru, child) {
        return MaterialApp(
          theme: yaru.theme,
          darkTheme: yaru.darkTheme,
          home: const HomePage(),
        );
      },
    );
  }
}

class CronEntryWidget extends StatelessWidget {
  final String command;
  final String cronCommand;

  const CronEntryWidget({
    Key? key,
    required this.command,
    required this.cronCommand,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              command,
              style: const TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Text(
              cronCommand,
              style: TextStyle(color: Colors.grey[700]),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                print('Bearbeiten');
              },
              child: const Text('Bearbeiten'),
            ),
          ),
          const SizedBox(width: 3),
          Expanded(
            child: TextButton(
              onPressed: () {
                print('Löschen');
              },
              child: const Text('Löschen'),
            ),
          ),
        ],
      ),
    );
  }
}

class Start_Tab extends StatelessWidget {
  const Start_Tab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                spacing: 5,
                children: List.generate(
                  8,
                  (index) => CronEntryWidget(
                    command: "./backup.sh",
                    cronCommand: "@reboot",
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      print("+");
                    },
                    child: const Text("+"),
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

class Admin_Tab extends StatelessWidget {
  const Admin_Tab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              print("Hallo Welt!");
            },
            child: const Text("Test2"),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              print("Hallo Welt!");
            },
            child: const Text("Test2"),
          ),
        ),
      ],
    );
  }
}

class Add_Tab extends StatefulWidget {
  const Add_Tab({super.key});

  @override
  State<Add_Tab> createState() => _Add_TabState();
}

class _Add_TabState extends State<Add_Tab> {
  String? selectedFrequency;
  final customRuleController = TextEditingController();
  final dayOfMonthController = TextEditingController();

  bool isButtonEnabled = false; // Variable to control button state

  late final Map<String, List<Widget Function()>> frequencyBuilders = {
    "x time": [
      () => const SizedBox(height: 15),
      _buildTimePickerButton,
      () => const SizedBox(height: 5),
    ],
    "dayly": [
      () => const SizedBox(height: 15),
      _buildTimePickerButton,
      () => const SizedBox(height: 5),
    ],
    "weekly": [
      () => const SizedBox(height: 15),
      _buildWeekdayDropdown,
      () => const SizedBox(height: 5),
      _buildTimePickerButton,
      () => const SizedBox(height: 5),
    ],
    "monthly": [
      () => const SizedBox(height: 15),
      _buildDayOfMonthField,
      () => const SizedBox(height: 5),
      _buildTimePickerButton,
      () => const SizedBox(height: 5),
    ],
    "self": [
      () => const SizedBox(height: 15),
      _buildCustomRuleField,
      () => const SizedBox(height: 5),
    ],
    "boot": [() => const SizedBox(height: 15)],
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextField(decoration: InputDecoration(labelText: "Befehl:")),
          const SizedBox(height: 5),
          DropdownMenu<String>(
            width: double.infinity,
            label: const Text("Frequenz:"),
            initialSelection: selectedFrequency,
            onSelected: (value) {
              setState(() {
                selectedFrequency = value;
                _checkFields(); // Check fields when frequency is selected
              });
            },
            dropdownMenuEntries: const [
              DropdownMenuEntry(value: "x time", label: "x Zeit"),
              DropdownMenuEntry(value: "dayly", label: "Täglich"),
              DropdownMenuEntry(value: "weekly", label: "Wöchentlich"),
              DropdownMenuEntry(value: "monthly", label: "Monatlich"),
              DropdownMenuEntry(value: "self", label: "Eigene Regel"),
              DropdownMenuEntry(
                value: "boot",
                label: "Nach jedem Start des Systems",
              ),
            ],
          ),
          ...((frequencyBuilders[selectedFrequency] ?? []).map(
            (builder) => builder(),
          )),
          Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  isButtonEnabled
                      ? () {
                        print("Speichern!");
                      }
                      : null, // Disable the button if not enabled
              child: const Text("Speichern"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimePickerButton() => SizedBox(
    width: double.infinity,
    child: OutlinedButton(
      onPressed: () => showCustomTimePickerDialog(context),
      child: const Text("Uhrzeit wählen"),
    ),
  );

  Widget _buildWeekdayDropdown() => DropdownMenu<String>(
    width: double.infinity,
    label: const Text("Wochentag:"),
    dropdownMenuEntries: const [
      DropdownMenuEntry(value: "monday", label: "Montag"),
      DropdownMenuEntry(value: "tuesday", label: "Dienstag"),
      DropdownMenuEntry(value: "wednesday", label: "Mittwoch"),
      DropdownMenuEntry(value: "thursday", label: "Donnerstag"),
      DropdownMenuEntry(value: "friday", label: "Freitag"),
      DropdownMenuEntry(value: "saturday", label: "Samstag"),
      DropdownMenuEntry(value: "sunday", label: "Sonntag"),
    ],
  );

  Widget _buildCustomRuleField() => TextField(
    controller: customRuleController,
    decoration: const InputDecoration(labelText: "Eigene Regel:"),
    keyboardType: TextInputType.text,
    onChanged: (value) {
      _checkFields();
    },
  );

  Widget _buildDayOfMonthField() => TextField(
    controller: dayOfMonthController,
    decoration: const InputDecoration(labelText: "Tag des Monats:"),
    keyboardType: TextInputType.number,
    onChanged: (value) {
      _checkFields();
    },
  );

  void _checkFields() {
    // Check if all necessary fields are filled
    bool commandFilled = customRuleController.text.isNotEmpty;
    bool frequencySelected = selectedFrequency != null;
    bool timeSet = hours_set != 0 && minutes_set != 0; // Ensure the time is set

    setState(() {
      isButtonEnabled = commandFilled && frequencySelected && timeSet;
    });
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const TabBar(
            tabs: [
              Tab(text: "Benutzer"),
              Tab(text: "Administrator"),
              Tab(text: "Hinzufügen"),
            ],
          ),
        ),
        body: const TabBarView(children: [Start_Tab(), Admin_Tab(), Add_Tab()]),
      ),
    );
  }
}

void showCustomTimePickerDialog(BuildContext context) {
  final hourController = TextEditingController();
  final minuteController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Uhrzeit wählen"),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 50,
              child: TextField(
                controller: hourController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: "HH"),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(":", style: TextStyle(fontSize: 20)),
            ),
            SizedBox(
              width: 50,
              child: TextField(
                controller: minuteController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: "MM"),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Abbrechen"),
          ),
          ElevatedButton(
            onPressed: () {
              hours_set = int.tryParse(hourController.text) ?? 0;
              minutes_set = int.tryParse(minuteController.text) ?? 0;
              print("Uhrzeit: $hours_set:$minutes_set");
              Navigator.of(context).pop();
              if (hours_set == 0 || minutes_set == 0) {
                // Show Toast message
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Fehler"),
                      content: const Text(
                        "Bitte geben Sie eine gültige Uhrzeit ein.",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("Abbrechen"),
                        ),
                        TextButton(
                          onPressed: () {
                            // restart the dialog
                            Navigator.of(context).pop();
                            showCustomTimePickerDialog(context);
                          },
                          child: const Text("OK"),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            child: const Text("OK"),
          ),
        ],
      );
    },
  );
}
