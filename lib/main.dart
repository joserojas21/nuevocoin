import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>
      MyHomePage();

}

class MyHomePage extends State<MyApp> {

  var list;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    refreshListCoin();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'COIN TRACKER',
      theme: ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(title: Text('COIN TRACKER')),
        body: Center(
          child: RefreshIndicator(
            key: refreshKey,
              child: FutureBuilder<List<CoinMarket>>(
                future: list,
                builder: (context,snapshot){
                  if(snapshot.hasData){

                    List<CoinMarket> coins = snapshot.data;

                    //Mostrar lista

                    return ListView(
                      children: coins.map((coin)=> Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[

                          //fila principal

                          Row(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    //Botones alcolchados
                                    padding: const EdgeInsets.only(left: 8.0,bottom: 8.0),
                                    child: Image.network(src),
                                    width: 56.0,
                                    height: 56.0,
                                  )
                                ],
                              )
                            ],
                          )

                        ],
                      )).toList(),
                    );

                  }
                  else if(snapshot.hasError){

                    Text('Error while loading Coin list: ${snapshot.error}');
                  }

                  return new CircularProgressIndicator();
                },
              ),
              onRefresh: null),
        ),
      ),
    );

  }


  Future<Null> refreshListCoin(){
    refreshKey.currentState?.show(atTop: false);


    setState(()  {
      list = fetchListCoin();
    });

    return null;

  }

}


/*
class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
*/
Future<List<CoinMarket>> fetchListCoin()async{
  final api_endpoint =
      await http.get('https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest?CMC_PRO_API_KEY=00280d57-72e8-4d65-b9dd-d5a4410dec58');

  if(api_endpoint.statusCode == 200)
  {
    List coins = json.decode(api_endpoint.body);
    return coins.map((coin) =>
    new CoinMarket.fromJson(coin)).toList();
  }

  else
    throw Exception('Failed to load Coin list');
}

class CoinMarket{
  final int id;
  final String name;
  final String symbol;
  final double price_usd;
  final double percent_change_1h;
  final double percent_change_24h;
  final double percent_change_7d;

  CoinMarket({
    this.id,
    this.name,
    this.symbol,
    this.price_usd,
    this.percent_change_1h,
    this.percent_change_24h,
    this.percent_change_7d
});

  factory CoinMarket.fromJson(Map<String,dynamic>json){
    return CoinMarket(
      id: json['id'],
      name: json['name'],
      symbol: json['symbol'],
      price_usd: json['price_usd'],
      percent_change_1h: json['percent_change_1h'],
      percent_change_24h: json['percent_change_24h'],
      percent_change_7d: json['percent_change_7d'],

    );
  }

}


/*
public class Status
{
    public DateTime timestamp { get; set; }
    public int error_code { get; set; }
    public object error_message { get; set; }
    public int elapsed { get; set; }
    public int credit_count { get; set; }
    public object notice { get; set; }
}

public class USD
{
    public double price { get; set; }
    public double volume_24h { get; set; }
    public double percent_change_1h { get; set; }
    public double percent_change_24h { get; set; }
    public double percent_change_7d { get; set; }
    public double market_cap { get; set; }
    public DateTime last_updated { get; set; }
}

public class Quote
{
    public USD USD { get; set; }
}

public class Datum
{
    public int id { get; set; }
    public string name { get; set; }
    public string symbol { get; set; }
    public string slug { get; set; }
    public int num_market_pairs { get; set; }
    public DateTime date_added { get; set; }
    public List<string> tags { get; set; }
    public int? max_supply { get; set; }
    public double circulating_supply { get; set; }
    public double total_supply { get; set; }
    public object platform { get; set; }
    public int cmc_rank { get; set; }
    public DateTime last_updated { get; set; }
    public Quote quote { get; set; }
}

public class RootObject
{
    public Status status { get; set; }
    public List<Datum> data { get; set; }
}
 */