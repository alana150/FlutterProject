import 'package:flutter/material.dart';

final Color accent = Color(0xFFFADFAD);
final Color bgTop = Color(0xFF8487A2);
final Color bgBottom = Color(0xFF5D6284);
final Color searchFieldColor = Color(0xFF0A214C);

final List<PlanModel> plans = [
  PlanModel(
    title: 'Поездка в Цей',
    date: '12 июля',
    category: 'Горы',
    description: 'Подняться к леднику.',
    isDone: false,
  ),
  PlanModel(
    title: 'Голубые горы',
    date: '20 августа',
    category: 'Горы',
    description: 'Сфотографировать Эхо Поинт.',
    isDone: false,
  ),
  PlanModel(
    title: 'Рисовые террасы',
    date: '5 сентября',
    category: 'Природа',
    description: 'Посмотреть террасы в тумане.',
    isDone: true,
  ),
];

const List<BottomBarModel> navItems = [
  BottomBarModel(icon: Icons.explore_outlined, label: 'План', isSelected: true),
  BottomBarModel(icon: Icons.favorite_border, label: 'Избранное'),
  BottomBarModel(icon: Icons.check_circle_outline, label: 'Готово'),
  BottomBarModel(icon: Icons.account_circle_outlined, label: 'Профиль'),
];

void main() {
  runApp(
    MaterialApp(
      title: 'Планер',
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
    ),
  );
}

class SplashPage extends StatefulWidget {
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _goToHomeAfterDelay();
  }

  Future<void> _goToHomeAfterDelay() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: accent,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Icon(Icons.event_note, color: bgTop, size: 80),
          ),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 160,
              height: 160,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(bgTop),
                strokeWidth: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bgTop,
        iconTheme: IconThemeData(color: accent),
        title: Center(
          child: Icon(Icons.event_note, color: accent),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [bgTop, bgBottom],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                HeaderWidget(),
                Expanded(child: PlanListView()),
                BottomBarWidget(),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 200,
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        accent.withOpacity(0.35),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 30, left: 30, right: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Твои планы',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                '${plans.length} плана · не забудь про ближайший',
                style: TextStyle(
                  color: accent,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 30, right: 30),
          child: Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: searchFieldColor,
            ),
            margin: EdgeInsets.only(top: 20, bottom: 20),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.grey),
                SizedBox(width: 10),
                Text('Поиск', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class PlanListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      itemCount: plans.length,
      itemBuilder: (context, index) {
        final currentPlan = plans[index];
        return PlanCard(planModel: currentPlan);
      },
    );
  }
}

class PlanCard extends StatelessWidget {
  final PlanModel planModel;

  const PlanCard({super.key, required this.planModel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DetailsPage(selectedModel: planModel),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(
              planModel.isDone
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: planModel.isDone ? accent : Colors.white.withOpacity(0.5),
              size: 30,
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    planModel.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '${planModel.category} · ${planModel.date}',
                    style: TextStyle(color: accent, fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.5)),
          ],
        ),
      ),
    );
  }
}

class BottomBarWidget extends StatefulWidget {
  @override
  State<BottomBarWidget> createState() => BottomBarWidgetState();
}

class BottomBarWidgetState extends State<BottomBarWidget> {
  late List<BottomBarModel> _items;

  @override
  void initState() {
    super.initState();
    _items = List.from(navItems);
  }

  void _selectItem(int index) {
    setState(() {
      for (var i = 0; i < _items.length; i++) {
        _items[i] = _items[i].copyWith(isSelected: i == index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 20, left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_items.length, (index) {
          final item = _items[index];
          return IconButton(
            tooltip: item.label,
            icon: Icon(
              item.icon,
              color: item.isSelected ? accent : Colors.grey,
            ),
            onPressed: () => _selectItem(index),
          );
        }),
      ),
    );
  }
}

class DetailsPage extends StatelessWidget {
  final PlanModel selectedModel;

  const DetailsPage({super.key, required this.selectedModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgTop,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bgTop,
        iconTheme: IconThemeData(color: accent),
        leading: BackButton(color: accent),
        title: Center(
          child: Icon(Icons.event_note, color: accent),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  selectedModel.isDone
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: selectedModel.isDone ? accent : Colors.white,
                  size: 30,
                ),
                SizedBox(width: 10),
                Text(
                  selectedModel.isDone ? 'Выполнено' : 'В планах',
                  style: TextStyle(color: accent, fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              selectedModel.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '${selectedModel.category} · ${selectedModel.date}',
              style: TextStyle(color: accent, fontSize: 16),
            ),
            SizedBox(height: 30),
            Text(
              selectedModel.description,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 16,
                height: 1.5,
              ),
            ),
            SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Material(
                  color: accent,
                  child: InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Статус изменён')),
                      );
                    },
                    splashColor: Colors.black.withOpacity(0.15),
                    highlightColor: Colors.black.withOpacity(0.2),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        selectedModel.isDone
                            ? 'Вернуть в план'
                            : 'Отметить выполненным',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlanModel {
  final String title;
  final String date;
  final String category;
  final String description;
  final bool isDone;

  const PlanModel({
    required this.title,
    required this.date,
    required this.category,
    required this.description,
    this.isDone = false,
  });
}

class BottomBarModel {
  final IconData icon;
  final String label;
  final bool isSelected;

  const BottomBarModel({
    required this.icon,
    required this.label,
    this.isSelected = false,
  });

  BottomBarModel copyWith({bool? isSelected}) {
    return BottomBarModel(
      icon: icon,
      label: label,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
