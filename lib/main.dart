import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const SurvivalGameApp());
}

class SurvivalGameApp extends StatelessWidget {
  const SurvivalGameApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Survival Game - BOABCA AZEDDIN',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF111111),
        primaryColor: Colors.redAccent,
      ),
      home: const GameRulesScreen(),
    );
  }
}

class Player {
  String name;
  int losses;
  int score;
  bool active;
  int currentChoice;
  bool isHidden;

  Player({
    required this.name,
    this.losses = 0,
    this.score = 0,
    this.active = true,
    this.currentChoice = 0,
    this.isHidden = true,
  });
}

// ==========================================
// شاشة عرض القواعد أولاً (للقراءة قبل البدء)
// ==========================================
class GameRulesScreen extends StatelessWidget {
  const GameRulesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("قواعد لعبة البقاء - BOABCA AZEDDIN"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              "📜 دستور وقواعد اللعبة:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.amber),
            ),
            const SizedBox(height: 10),
            const Text(
              "1. تخصيص الأعضاء: يمكنك إضافة من 2 إلى 30 عضواً وتغيير أسمائهم بحرية.\n"
              "2. طريقة اللعب: يختار كل لاعب سراً رقماً من 0 إلى 100 مع زر إخفاء الرقم لضمان السرية.\n"
              "3. المعيار الأساسي: يُحسب المتوسط ويُضرب في 0.8 للوصول إلى الناتج المستهدف.\n"
              "4. عقوبة التطابق: إذا تطابق رقمان، يعاقب أصحابهما بـ سالب 1 (-1) وتظهر باللون الأحمر 🔴.\n"
              "5. مفارقة 0 و 100: من يختار 0 والآخر 100 يفوز بـ (+2) تظهر باللون الأزرق 🔵.\n"
              "6. الاقتراب الشديد: من يقترب بفرق أقل من 1.5 يحصل على (+2) باللون الأزرق 🔵، والأقرب عموماً يحصل على (+1) بالأخضر 🟢.\n"
              "7. الإقصاء: كل من تبلغ خسائره 5 يتم إقصاؤه نهائياً.\n",
              style: TextStyle(fontSize: 14, color: Colors.white70, height: 1.5),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SetupPlayersScreen()),
                );
              },
              child: const Text(
                "التالي: إعداد الأسماء والأعضاء",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// شاشة إعداد اللاعبين (إضافة وتعديل الأسماء من 2 إلى 30)
// ==========================================
class SetupPlayersScreen extends StatefulWidget {
  const SetupPlayersScreen({Key? key}) : super(key: key);

  @override
  _SetupPlayersScreenState createState() => _SetupPlayersScreenState();
}

class _SetupPlayersScreenState extends State<SetupPlayersScreen> {
  final List<TextEditingController> _controllers = [
    TextEditingController(text: "أحمد (أنا)"),
    TextEditingController(text: "Shunsui"),
    TextEditingController(text: "Dustin"),
    TextEditingController(text: "Ayanokoji"),
  ];

  void addPlayer() {
    if (_controllers.length < 30) {
      setState(() {
        _controllers.add(TextEditingController(text: "عضو ${_controllers.length + 1}"));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("الحد الأقصى هو 30 عضواً!")),
      );
    }
  }

  void removePlayer(int index) {
    if (_controllers.length > 2) {
      setState(() {
        _controllers.removeAt(index);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("الحد الأدنى هو عضوين!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تخصيص المشاركين (من 2 إلى 30)"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _controllers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Row(
                      children: [
                        Text("${index + 1}.", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _controllers[index],
                            decoration: InputDecoration(
                              labelText: "اسم العضو",
                              filled: true,
                              fillColor: Colors.grey[900],
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () => removePlayer(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey).wrap(
                    ElevatedButton(
                      onPressed: addPlayer,
                      child: const Text("إضافة عضو +"),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, padding: const EdgeInsets.all(14)),
                    onPressed: () {
                      List<Player> initializedPlayers = _controllers
                          .map((c) => Player(name: c.text.isEmpty ? "مجهول" : c.text))
                          .toList();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GameDashboardScreen(playersList: initializedPlayers),
                        ),
                      );
                    },
                    child: const Text("بدء المعركة 🚀", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// امتداد مساعد لتنسيق زر الإضافة
extension on ButtonStyle {
  Widget wrap(Widget child) => child;
}

// ==========================================
// شاشة لوحة اللعب الرئيسية وإدارة الجولات
// ==========================================
class GameDashboardScreen extends StatefulWidget {
  final List<Player> playersList;
  const GameDashboardScreen({Key? key, required this.playersList}) : super(key: key);

  @override
  _GameDashboardScreenState createState() => _GameDashboardScreenState();
}

class _GameDashboardScreenState extends State<GameDashboardScreen> {
  int currentRound = 1;
  late List<Player> players;
  String lastRoundLog = "ابدأ الجولة الأولى لاختبار الأرقام...";

  @override
  void initState() {
    super.initState();
    players = widget.playersList;
  }

  void openNumberSelector(Player player) {
    int selectedNum = player.currentChoice;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text("اختر رقماً لـ ${player.name}"),
          content: SizedBox(
            width: 300,
            height: 350,
            child: Column(
              children: [
                Text(
                  "الرقم: ${player.isHidden ? '****' : selectedNum}",
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.amber),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("إخفاء الرقم سراً: "),
                    Checkbox(
                      value: player.isHidden,
                      onChanged: (val) {
                        setDialogState(() {
                          player.isHidden = val ?? true;
                        });
                      },
                    ),
                  ],
                ),
                const Divider(),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      childAspectRatio: 1.5,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    itemCount: 101,
                    itemBuilder: (context, index) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: selectedNum == index ? Colors.redAccent : Colors.grey[800],
                        ),
                        onPressed: () {
                          setDialogState(() {
                            selectedNum = index;
                          });
                        },
                        child: Text("$index", style: const TextStyle(fontSize: 12, color: Colors.white)),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  player.currentChoice = selectedNum;
                });
                Navigator.pop(context);
              },
              child: const Text("تأكيد وحفظ"),
            ),
          ],
        ),
      ),
    );
  }

  void processRound() {
    List<Player> activePlayers = players.where((p) => p.active).toList();

    if (activePlayers.length <= 1) {
      String winner = activePlayers.isNotEmpty ? activePlayers[0].name : "لا يوجد";
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("انتهت المعركة"),
          content: Text("الفائز الأوحد بالعرش هو: $winner\nالمبرمج: BOABCA AZEDDIN"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("إغلاق"),
            ),
          ],
        ),
      );
      return;
    }

    Map<String, int> choices = {for (var p in activePlayers) p.name: p.currentChoice};
    int totalSum = choices.values.reduce((a, b) => a + b);
    double avg = totalSum / activePlayers.length;
    double target = avg * 0.8;

    String roundLog = choices.entries.map((e) => "👤 ${e.key} : [${e.value}]").join("\n");
    roundLog += "\n\nالمجموع: $totalSum | المتوسط: ${avg.toStringAsFixed(2)}\nالناتج المستهدف (×0.8): ${target.toStringAsFixed(2)}\n\n";

    List<int> chosenNumbers = choices.values.toList();
    List<String> zeroPlayers = choices.entries.where((e) => e.value == 0).map((e) => e.key).toList();
    bool hasHundred = choices.containsValue(100);

    if (zeroPlayers.length >= 2) {
      roundLog += "🔥 تطابق صفرين (+1 نقطة خضراء 🟢)!\n";
      for (var p in players) {
        if (zeroPlayers.contains(p.name)) {
          p.score += 1;
        } else if (p.active) {
          p.losses += 1;
        }
      }
    } else if (zeroPlayers.isNotEmpty && hasHundred) {
      roundLog += "⚡ مفارقة 0 و 100 (+2 نقطة زرقاء 🔵)!\n";
      for (var entry in choices.entries) {
        if (entry.value == 100) {
          players.firstWhere((p) => p.name == entry.key).score += 2;
        } else if (entry.value != 0) {
          players.firstWhere((p) => p.name == entry.key).losses += 1;
        }
      }
    } else {
      Map<int, int> counts = {};
      for (var num in chosenNumbers) {
        counts[num] = (counts[num] ?? 0) + 1;
      }
      List<int> matchedNums = counts.entries.where((e) => e.value > 1).map((e) => e.key).toList();
      
      if (matchedNums.isNotEmpty) {
        roundLog += "⚠️ تطابق أرقام (-1 خسارة حمراء 🔴)!\n";
        for (var entry in choices.entries) {
          if (matchedNums.contains(entry.value)) {
            players.firstWhere((p) => p.name == entry.key).losses += 1;
          }
        }
      }

      String closestName = "";
      double minDiff = 999.0;
      choices.forEach((name, num) {
        double diff = (num - target).abs();
        if (diff < minDiff) {
          minDiff = diff;
          closestName = name;
        }
      });

      if (minDiff <= 1.5) {
        roundLog += "🎯 $closestName اقترب بفرق ${minDiff.toStringAsFixed(2)} وحصل على (+2 نقطة زرقاء 🔵)!\n";
        players.firstWhere((p) => p.name == closestName).score += 2;
      } else {
        roundLog += "👑 $closestName كان الأقرب وحصل على (+1 نقطة خضراء 🟢)!\n";
        players.firstWhere((p) => p.name == closestName).score += 1;
        for (var p in activePlayers) {
          if (p.name != closestName) {
            p.losses += 1;
          }
        }
      }
    }

    for (var p in players) {
      if (p.losses >= 5 && p.active) {
        p.active = false;
        roundLog += "\n💀 تم إقصاء اللاعب ${p.name} لتجاوزه 5 خسائر!\n";
      }
    }

    setState(() {
      lastRoundLog = roundLog;
      currentRound++;
      for (var p in players) {
        p.isHidden = true;
        p.currentChoice = 0;
      }
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("نتيجة الجولة السابقة"),
        content: SingleChildScrollView(child: Text(roundLog)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("حسناً"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("الجولة $currentRound - لوحة التحكم"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const Text(
              "المبرمج: BOABCA AZEDDIN",
              style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: players.length,
                itemBuilder: (context, index) {
                  var p = players[index];
                  return Card(
                    color: p.active ? const Color(0xFF1E1E1E) : Colors.red.withOpacity(0.2),
                    child: ListTile(
                      title: Text(p.name, style: TextStyle(fontWeight: FontWeight.bold, color: p.active ? Colors.white : Colors.grey)),
                      subtitle: Text(
                        "الخسائر: ${p.losses}/5 | النقاط: ${p.score} | الرقم: ${p.isHidden ? '🔒 مخفي' : '${p.currentChoice}'}",
                        style: TextStyle(
                          color: p.score > 0 ? Colors.greenAccent : (p.losses > 0 ? Colors.redAccent : Colors.white70),
                        ),
                      ),
                      trailing: p.active
                          ? ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                              onPressed: () => openNumberSelector(p),
                              child: const Text("اختر رقم"),
                            )
                          : const Text("مقصي ❌", style: TextStyle(color: Colors.red)),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: processRound,
              child: const Text(
                "تأكيد وبدء حساب الجولة",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
