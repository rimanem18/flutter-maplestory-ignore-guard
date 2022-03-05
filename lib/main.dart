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
  final TextEditingController _ignoreValueController = TextEditingController();

  double _damage = 0;
  double _ignoreValue = 0.5;
  double _mobGuard = 0.5;
  double _pressureValue = 0.3;
  bool _isCoreUpgrade = false;
  bool _isPressure = false;
  bool _isPressureEnhance = false;

  void _damageCalc(String ignoreValue) {
    // 入力値が空欄の場合、0 として扱う
    if (ignoreValue == "") {
      _ignoreValue = 0;
    } else {
      _ignoreValue = double.parse(ignoreValue) / 100;
    }

    double mobGuard = _mobGuard;
    if (_isPressure) {
      mobGuard = mobGuard - _pressureValue;
    }

    // 与えられるダメージ
    if (_isCoreUpgrade) {
      _damage = 1 - mobGuard * (1 - _ignoreValue) * (1 - 0.2);
    } else {
      _damage = 1 - mobGuard * (1 - _ignoreValue);
    }

    // 計算結果がマイナスなら0
    if (_damage * 100 < 0) {
      _damage = 0;
    }
    // 計算結果を切り捨ててセット
    _damage = _damage * 100;

    setState(() {
      _damage = _damage.floor() as double;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SizedBox(
          width: 390,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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
                        _pressureValue = 0.3;
                        _damageCalc(_ignoreValueController.text);
                      }
                    });
                  }),
              CheckboxListTile(
                  value: _isPressureEnhance,
                  title: const Text('ハイパースキル プレッシャー - エンハンス'),
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (value) {
                    setState(() {
                      if (value != null) {
                        _isPressureEnhance = value;
                        _pressureValue = 0.5;
                        _damageCalc(_ignoreValueController.text);
                      }
                    });
                  }),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _ignoreValueController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          suffixText: '%',
                          label: Text(
                            '自分の防御率無視',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        onChanged: (ignoreValue) => _damageCalc(ignoreValue),
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '防御率 $_mobGuard の敵に通るダメージ',
              ),
              Text(
                '$_damage %',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
