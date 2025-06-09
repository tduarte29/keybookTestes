import 'package:flutter/material.dart';

void main() {
  runApp(KeybookApp());
}

class KeybookApp extends StatelessWidget {
  const KeybookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              'Lista de Chaves',
              style: TextStyle(color: Colors.white, fontSize: 25.0),
            ),
          ),
          backgroundColor: Colors.grey.shade900,
        ),
        backgroundColor: Colors.grey.shade900,
        bottomNavigationBar: BottomAppBar(
          color: Colors.black45,
          child: Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Icon(Icons.home, color: Colors.white),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Icon(Icons.list_alt, color: Colors.white),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Icon(Icons.inbox, color: Colors.white),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: SafeArea(child: HomePage()),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Expanded(
                //   child: TextField(
                //     decoration: InputDecoration(
                //       prefixIcon: Icon(Icons.search, color: Colors.white,),
                //       suffixIcon: Icon(Icons.clear, color: Colors.white,),
                //       labelText: 'Nome da Tabela',
                //       labelStyle: TextStyle(color: Colors.grey),
                //       hintText: 'hint text',
                //       helperText: 'supporting text',
                //       filled: true,
                //       fillColor: Colors.grey.shade800,
                //       border: OutlineInputBorder(),
                //     ),
                //     style: TextStyle(
                //       color: Colors.white,
                //     ),
                //   ),
                // ),
                SizedBox(width: 8.0),

                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    'adicionar tabela',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),

            //Fim da primeira linha ------------------------------------------------------------
            SizedBox(height: 20.0),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: TextButton(
                        onPressed: () {},
                        child: Icon(Icons.search, color: Colors.white),
                      ),
                      suffixIcon: TextButton(
                        onPressed: () {},
                        child: Icon(Icons.clear, color: Colors.white),
                      ),
                      labelText: 'Pesquisar Itens',
                      labelStyle: TextStyle(color: Colors.grey),
                      hintText: 'hint text',
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey.shade800,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 8.0,
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                SizedBox(width: 8.0),

                Container(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextButton(
                    onPressed: () {},
                    child: Icon(Icons.filter_alt_sharp, color: Colors.white),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20.0),

            //Gemini aqui
            Column(
              children: [
                // Exemplo de dados para as tabelas
                _buildTableItem(
                  context,
                  tableName: 'Ford',
                  itemCount: 12,
                  keys: [
                    {
                      'name': 'Chave Fusion',
                      'brand': 'Ford',
                      'price': 'R\$ 250,00',
                    },
                    {
                      'name': 'Chave Focus',
                      'brand': 'Ford',
                      'price': 'R\$ 180,00',
                    },
                    {
                      'name': 'Chave Ranger',
                      'brand': 'Ford',
                      'price': 'R\$ 300,00',
                    },
                  ],
                ),
                _buildTableItem(
                  context,
                  tableName: 'Chevrolet',
                  itemCount: 8,
                  keys: [
                    {
                      'name': 'Chave Onix',
                      'brand': 'Chevrolet',
                      'price': 'R\$ 200,00',
                    },
                    {
                      'name': 'Chave Cruze',
                      'brand': 'Chevrolet',
                      'price': 'R\$ 280,00',
                    },
                  ],
                ),
                _buildTableItem(
                  context,
                  tableName: 'Volkswagen',
                  itemCount: 15,
                  keys: [
                    {
                      'name': 'Chave Gol',
                      'brand': 'Volkswagen',
                      'price': 'R\$ 150,00',
                    },
                    {
                      'name': 'Chave Jetta',
                      'brand': 'Volkswagen',
                      'price': 'R\$ 320,00',
                    },
                    {
                      'name': 'Chave Amarok',
                      'brand': 'Volkswagen',
                      'price': 'R\$ 350,00',
                    },
                    {
                      'name': 'Chave Virtus',
                      'brand': 'Volkswagen',
                      'price': 'R\$ 260,00',
                    },
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableItem(
    BuildContext context, {
    required String tableName,
    required int itemCount,
    required List<Map<String, String>> keys,
  }) {
    return InkWell(
      onTap: () {
        _showKeysModal(context, tableName, keys);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              tableName,
              style: TextStyle(color: Colors.white, fontSize: 18.0),
            ),
            Text(
              '$itemCount itens',
              style: TextStyle(color: Colors.grey, fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }

  void _showKeysModal(
    BuildContext context,
    String tableName,
    List<Map<String, String>> keys,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height:
              MediaQuery.of(context).size.height *
              0.75, // 75% da altura da tela
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Chaves da Tabela: $tableName',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: keys.length,
                  itemBuilder: (context, index) {
                    final key = keys[index];
                    return Card(
                      margin: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      color: Colors.grey.shade800,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nome: ${key['name']}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              'Marca: ${key['brand']}',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 16.0,
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              'Preço: ${key['price']}',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 12.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    'Fechar',
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
