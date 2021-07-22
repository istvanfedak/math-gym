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

class Board extends StatelessWidget {
  Board({
    Key? key, 
    this.squares, 
    this.onPressed,
    this.onEnter, 
    this.onReset,
    this.curValue,
    this.curMathProblem
  }): super(key: key);

  final curValue;
  final squares;
  final onPressed;
  final onEnter;
  final onReset;
  final curMathProblem;


  Widget renderSquare(int i) => Square(
    value: squares[i], 
    onPressed: ()=>this.onPressed(i),
  );

  Widget renderEnterButton() => Square(
      icon: Icon(Icons.arrow_forward_ios),
      onPressed: ()=>this.onEnter(),
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
          row.add(this.renderEnterButton());
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

    return Column (
      mainAxisAlignment: MainAxisAlignment.center,
      children: rows
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var squares;
  var maxSize;
  var curValue;
  var mathProblems;
  var curMathProblem;
  var problemNumber;
  var dificulty;
  final random = Random();

  @override
  initState() {
    super.initState();
    this.squares = ['7','8','9','4','5','6','1','2','3','reset','0','enter'];
    this.maxSize = 14;
    this.curValue = "";
    this.dificulty = 6;
    this.mathProblems = createShuffledMathProblems(this.dificulty);
    this.problemNumber = 0;
  }

  bool validate(){
    return (int.parse(this.curValue) == this.mathProblems[this.problemNumber][2]);
  }

  handleClick(int i) {
    
    if (this.curValue.length + 1 >= this.maxSize) return;
    setState(() {
      this.curValue += squares[i];
    });
    if (this.validate())
      this.handleEnter();
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

  List<List<int>> createShuffledMathProblems(largestMult) {
    // create math problems
    List<List<int>> problems = [];
    for(int i = 2; i < largestMult+1; i ++) {
      for(int j = 2; j < 10; j ++) {
        List<int> problem = [i, j, i * j];
        problems.add(problem);
      }
    }

    // shuffle
    for(int i = problems.length-1; i > 0; i--){
      var j = random.nextInt(i+1);
      List<int> temp = problems[i];
      problems[i] = problems[j];
      problems[j] = temp;
    }

    return problems;
  }

  @override
  Widget build(BuildContext context) {
    this.curMathProblem = '${mathProblems[problemNumber][0]} x ${mathProblems[problemNumber][1]}';
    return Scaffold(
      appBar: AppBar(title: Text("MathGym"),),
      body: Center(child: Board(
        squares: this.squares,
        onPressed: (i)=>this.handleClick(i),
        onEnter: ()=>this.handleEnter(),
        onReset: ()=>this.handleReset(),
        curValue: this.curValue,
        curMathProblem: this.curMathProblem
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {this.handleDificultyIncrease();},
        tooltip: 'Increment',
        child: Text(dificulty.toString()),
      ),
    );
  }
}