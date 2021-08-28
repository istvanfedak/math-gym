import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class Square extends StatelessWidget {
  Square({
    Key? key, 
    this.value, 
    this.onPressed, 
    this.icon
  }): super(key: key);

  final value;
  final onPressed;
  final icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: 
          MaterialStateProperty.all<Color>(Colors.blue),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          )
        )
      ),
      onPressed: onPressed,
      child: this.icon != null?
        this.icon:
        Text(
          value,
          style:TextStyle(
            color: Colors.white,
            fontSize: 23.0,
            fontWeight: FontWeight.bold
          ),
        ),
    );
  }
}

class SettingsItem extends StatelessWidget {
  SettingsItem({
    Key? key,
    this.text,
    this.value,
    this.onPressed,
    this.icon
  }): super(key: key);

  final text;
  final value;
  final onPressed;
  final icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 251,
      padding: const EdgeInsets.only(
        top: 20.0, 
        bottom: 20.0, 
        left: 20.0, 
        right: 20.0
      ),
      child: Row(
        children: [
          Text(
            this.text,
            style:TextStyle(
              color: Colors.black,
              fontSize: 23.0,
              fontWeight: FontWeight.bold
            ),
          ),
          Expanded(
            child: Container(),
          ),
          Square(
            value: this.value,
            icon: this.icon,
            onPressed: ()=>onPressed(),
          ),
        ],
      ),
    );
  }
}

class Settings extends StatelessWidget {
  Settings({
    Key? key,
    this.difficultyValue,
    this.difficultyHandler,
    this.arithmeticValue,
    this.arithmeticHandler,
  }): super(key: key);

  final difficultyValue;
  final difficultyHandler;
  final arithmeticValue; // '+', '-', 'x', '÷';
  final arithmeticHandler;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SettingsItem(
            text: 'Difficulty',
            value: this.difficultyValue,
            onPressed: ()=>this.difficultyHandler(),
          ),
          SettingsItem(
            text: 'Arithmetic',
            value: this.arithmeticValue,
            onPressed: ()=>this.arithmeticHandler(),
          ),
        ],
      )
    );
  }
}

class Board extends StatelessWidget {
  Board({
    Key? key, 
    this.squares, 
    this.onPressed,
    this.onDelete, 
    this.onReset,
    this.curValue,
    this.curMathProblem
  }): super(key: key);

  final curValue;
  final squares;
  final onPressed;
  final onDelete;
  final onReset;
  final curMathProblem;


  Widget renderSquare(int i) => Square(
    value: squares[i], 
    onPressed: ()=>this.onPressed(i),
  );

  Widget renderDeleteButton() => Square(
      icon: Icon(Icons.arrow_back_ios_new_rounded),
      onPressed: ()=>this.onDelete(),
  );

  Widget renderResetButton() => Square(
      icon: Icon(Icons.refresh),
      onPressed: ()=>this.onReset(),
  );

  Widget renderCurMathProblem() => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          //color: Colors.black,
          margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
          width: 200,
          height: 40,
          child: Center(
            child: Text(
              this.curMathProblem,
              style: TextStyle(
                color: Colors.black,
                fontSize: 23.0,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        )
      ]
    );

  Widget renderCurValue() => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          //color: Colors.black,
          margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
          width: 200,
          height: 40,
          child: Center(
            child: Text(
              this.curValue,
              style: TextStyle(
                color: Colors.white,
                fontSize: 23.0,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            color: Colors.grey,
          ),
        )
      ]
    );

  @override
  Widget build(BuildContext context) {

    List<Widget> rows = [];
    rows.add(renderCurMathProblem());
    rows.add(renderCurValue());
    
    for(int i = 0; i < 4; i++) {
      List<Widget> row = [];
      for(int j = 0; j < 3; j++) {
        if(i==3 && j==0)
          row.add(this.renderResetButton());
        else if(i==3 && j==2)
          row.add(this.renderDeleteButton());
        else 
          row.add(this.renderSquare((i*3)+j));
        
        if(j != 2) row.add(Padding(padding: const EdgeInsets.all(8.0),));
      }
      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: row,
      ));
      rows.add(Padding(padding: const EdgeInsets.all(8.0),));
    }

    return Center( 
      child: Column (
        mainAxisAlignment: MainAxisAlignment.center,
        children: rows,
      )
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final squares = ['7','8','9','4','5','6','1','2','3','reset','0','enter'];
  final maxSize = 14;
  var curValue = '';
  var mathProblems;
  var curMathProblem;
  var problemNumber = 0;
  var dificulty = 6;
  var settingsMenuIsOpen = false;
  final arithmeticOperators = ['+', '-', 'x', '÷'];
  var curOperator = 2;
  final random = Random();

  @override
  initState() {
    super.initState();
    this.mathProblems = createShuffledMathProblems(this.dificulty);
  }

  bool validate(){
    return (int.parse(this.curValue) == this.mathProblems[this.problemNumber][1]);
  }

  handleClick(int i) {
    
    if (this.curValue.length + 1 >= this.maxSize) return;
    setState(() {
      this.curValue += squares[i];
      this.handleEnter();
    });
  }

  handleEnter() {
    if (!this.validate()) return;
    setState(() {
      this.curValue = "";
      if (this.problemNumber + 1 == this.mathProblems.length){
        this.mathProblems = this.createShuffledMathProblems(this.dificulty);
        this.problemNumber = 0;
      } else {
        this.problemNumber += 1;
      }
    });
  }

  handleDelete() {
    if (this.curValue.length <= 0) return;
    setState(() {
      this.curValue = this.curValue.substring(0, this.curValue.length - 1);;
    });
  }

  handleReset() {
    setState(() {
      this.curValue = "";
    });
  }

  handleDificultyIncrease () {
    setState(() {
      if (this.dificulty + 1 == 11) {
        this.dificulty = 2;
      } else {
        this.dificulty += 1;
      }
      this.mathProblems = this.createShuffledMathProblems(this.dificulty);
      this.problemNumber = 0;
    });
  }

  handleArithmeticOperatorChange () {
    setState(() {
      if (this.curOperator + 1 == this.arithmeticOperators.length) {
        this.curOperator = 0;
      } else {
        this.curOperator += 1;
      }
      this.mathProblems = this.createShuffledMathProblems(this.dificulty);
      this.problemNumber = 0;
    });
  }

  handleSettingsMenu() {
    setState(() {
      this.settingsMenuIsOpen = ! this.settingsMenuIsOpen;
    });
  }

  List createProblem(int i, int j) {
    if (this.arithmeticOperators[this.curOperator] == '+') {
      return ['$i + $j', i+j];
    }
    else if (this.arithmeticOperators[this.curOperator] == '-') {
      if (i > j)
        return ['$i - $j', i - j];
      else
        return ['$j - $i', j - i];
    }
    else if (this.arithmeticOperators[this.curOperator] == 'x') {
      return ['$i x $j', i * j];
    } 
    else if (this.arithmeticOperators[this.curOperator] == '÷') {
      return ['${i*j} ÷ $i', j];
    }
    else {
      return ['Error', 0];
    }
  }

  List<List> createShuffledMathProblems(largestMult) {
    // create math problems
    List<List> problems = [];
    for(int i = 2; i < largestMult+1; i ++)
      for(int j = 2; j < 10; j ++)
        problems.add(createProblem(i, j));

    // shuffle
    for(int i = problems.length-1; i > 0; i--){
      var j = random.nextInt(i+1);
      List temp = problems[i];
      problems[i] = problems[j];
      problems[j] = temp;
    }

    return problems;
  }

  @override
  Widget build(BuildContext context) {
    this.curMathProblem = mathProblems[problemNumber][0];
    var settingsPage = Settings(
      difficultyValue: dificulty.toString(),
      difficultyHandler: ()=>this.handleDificultyIncrease(),
      arithmeticValue: this.arithmeticOperators[this.curOperator],
      arithmeticHandler: ()=>handleArithmeticOperatorChange(),
    );
    var boardPage = Board(
      squares: this.squares,
      onPressed: (i)=>this.handleClick(i),
      onDelete: ()=>this.handleDelete(),
      onReset: ()=>this.handleReset(),
      curValue: this.curValue,
      curMathProblem: this.curMathProblem
    );

    return Scaffold(
      appBar: AppBar(title: Text("MathGym"),),
      body: (this.settingsMenuIsOpen)? settingsPage: boardPage,
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>this.handleSettingsMenu(),
        tooltip: 'Settings',
        child: (this.settingsMenuIsOpen)? Icon(Icons.clear): Icon(Icons.settings),
      ),
    );
  }
}