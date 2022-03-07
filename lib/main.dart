import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  final String _title = 'MapleStory 防御率無視簡易計算ツール';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "Noto Sans JP",
      ),
      home: MyHomePage(title: _title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController _ignoreValueController = TextEditingController();

  num _damage = 0;
  num _ignoreValue = 0.5;
  num _mobGuard = 3;
  num _pressureValue = 0.3;
  bool _isCoreUpgrade = false;
  bool _isPressure = false;
  bool _isPressureEnhance = false;

  final List<DropdownMenuItem<double>> _mobList = [];

  @override
  void initState() {
    super.initState();
    setMobList();
    setIgnoreValue();
    _mobGuard = _mobList[0].value!;
  }

  void setIgnoreValue() {
    _ignoreValueController = TextEditingController(text: '0');
  }

  void setMobList() {
    _mobList
      ..add(createItem('防御率 300% の MOB', 3.0))
      ..add(createItem('カオスピンクビーン', 1.8))
      ..add(createItem('カオスピンクビーンの石像', 1.6))
      ..add(createItem('ハードマグナス', 1.2))
      ..add(createItem('ノーマルシグナス', 1.0))
      ..add(createItem('アカイラム', 0.9))
      ..add(createItem('カオスピエール', 0.8))
      ..add(createItem('ノーマルマグナス', 0.5))
      ..add(createItem('カオスホーンテイル', 0.25));
  }

  DropdownMenuItem<double> createItem(String mob, double guard) {
    num viewGuard = (guard * 100).floor();
    String viewDisplay = '$mob （$viewGuard %）';

    if (guard == 3) {
      viewDisplay = mob;
    }
    return DropdownMenuItem(
      child: Text(
        viewDisplay,
        style: const TextStyle(fontSize: 18.0),
      ),
      value: guard,
    );
  }

  void _damageCalc(String ignoreValue) {
    // 入力値が空欄の場合、0 として扱う
    if (ignoreValue == "") {
      _ignoreValue = 0;
    } else {
      _ignoreValue = double.parse(ignoreValue) / 100;
    }
    num damage = 0;

    num mobGuard = _mobGuard;
    if (_isPressure && _isPressureEnhance) {
      _pressureValue = 0.5;
    } else if (_isPressure) {
      _pressureValue = 0.3;
    } else {
      _pressureValue = 0;
    }

    mobGuard = mobGuard - _pressureValue;

    // 与えられるダメージ
    if (_isCoreUpgrade) {
      damage = 1 - mobGuard * (1 - _ignoreValue) * (1 - 0.2);
    } else {
      damage = 1 - mobGuard * (1 - _ignoreValue);
    }

    // 計算結果がマイナスなら0
    if (damage * 100 < 0) {
      damage = 0;
    }

    setState(() {
      // 計算結果を切り捨ててセット
      _damage = (damage * 100).floor();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: ListView(
            children: <Widget>[
              const Center(
                child: Text(
                  '攻撃対象',
                  style: TextStyle(fontSize: 22, color: Colors.blue),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.security),
                  ),
                  DropdownButton(
                    items: _mobList,
                    value: _mobGuard,
                    onChanged: (value) => {
                      setState(() {
                        _mobGuard = value as num;
                        _damageCalc(_ignoreValueController.text);
                      }),
                    },
                  ),
                ],
              ),
              CheckboxListTile(
                  value: _isCoreUpgrade,
                  title: const Text('強化コアの防御率無視20%増加'),
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (value) {
                    setState(() {
                      if (value != null) {
                        _isCoreUpgrade = value;
                        _damageCalc(_ignoreValueController.text);
                      }
                    });
                  }),
              CheckboxListTile(
                  value: _isPressure,
                  title: const Text('プレッシャーのデバフ'),
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (value) {
                    setState(() {
                      if (value != null) {
                        _isPressure = value;
                        if (value == false) {
                          _isPressureEnhance = false;
                        }
                        _damageCalc(_ignoreValueController.text);
                      }
                    });
                  }),
              CheckboxListTile(
                  value: _isPressureEnhance,
                  title: Row(
                    children: const <Widget>[
                      Text('プレッシャー - エンハンス'),
                      Icon(Icons.h_plus_mobiledata),
                    ],
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (value) {
                    setState(() {
                      if (value != null) {
                        _isPressureEnhance = value;
                        _damageCalc(_ignoreValueController.text);
                      }
                    });
                  }),
              Container(
                padding: const EdgeInsets.all(8.0),
                width: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _ignoreValueController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.admin_panel_settings),
                          suffixText: '%',
                          label: Text(
                            '自分の防御率無視',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        onChanged: (ignoreValue) => _damageCalc(ignoreValue),
                        style: const TextStyle(fontSize: 30),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: <Widget>[
                    const Text(
                      '対象に通るダメージ',
                      style: TextStyle(fontSize: 22, color: Colors.blue),
                    ),
                    Text(
                      '$_damage %',
                      style: const TextStyle(fontSize: 26),
                    ),
                  ],
                ),
              ),
              const Card(
                child: ListTile(
                  leading: Icon(Icons.warning_amber_outlined),
                  contentPadding: EdgeInsets.all(20.0),
                  title: Text(
                      '通るダメージは切り捨てで計算しており、実際のダメージと異なる場合があります。\nこのツールは MapleStory プレイヤーのひとりに過ぎない一個人が開発したものであり、MapleStory を運営している NEXON とは無関係です。\n利用によって何かしらの損害が生じても、いかなる責任も負いません。'),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Icon(Icons.copyright_outlined),
                  Text(' 2020 Rimane.'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
