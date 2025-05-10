import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pizza_rush/map_screen.dart';

// URL do servidor local
const String apiUrl =
    'http://192.168.0.19:4242'; // Use 10.0.2.2 para Android emulator

class PaymentScreen extends StatelessWidget {
  final double totalPrice;
  final List<Map<String, dynamic>> orderItems;
  final List<Map<String, dynamic>> orderBeverages;
  final String observations;
  final String crustType;
  final String size;

  PaymentScreen({
    Key? key,
    required this.totalPrice,
    required this.orderItems,
    required this.orderBeverages,
    required this.observations,
    required this.crustType,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _PaymentScreen(
      totalPrice: totalPrice,
      orderItems: orderItems,
      orderBeverages: orderBeverages,
      observations: observations,
      crustType: crustType,
      size: size,
    );
  }
}

class _PaymentScreen extends StatefulWidget {
  final double totalPrice;
  final List<Map<String, dynamic>> orderItems;
  final List<Map<String, dynamic>> orderBeverages;
  final String observations;
  final String crustType;
  final String size;

  _PaymentScreen({
    required this.totalPrice,
    required this.orderItems,
    required this.orderBeverages,
    required this.observations,
    required this.crustType,
    required this.size,
  });

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<_PaymentScreen> {
  // Variáveis para controlar o estado de pagamento
  bool _isLoading = false;
  String _paymentMethod = 'Cartão de Crédito';
  bool _isPaymentSuccessful = false;
  String _errorMessage = '';

  // String chave API Stripe
  final String _stripePublishableKey =
      'pk_test_51RKTqQGdX2861DLQEnFTJ31HtmKYew42HqsuF0CwNCtpXhcYmkAM3AqIRVCLfmG8S8uOcCAe7B9a7R9nftwVOsmz00Kh1nzjiw';

  // Controladores para os campos do formulário de entrega
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  // Controladores para os campos de cartão separados
  final TextEditingController _cardHolderController = TextEditingController();

  // Variáveis para o Stripe
  bool _isCardFormValid = false;
  stripe.CardFormEditController _cardFormController =
      stripe.CardFormEditController();

  @override
  void initState() {
    super.initState();
    // Inicialize o Stripe SDK
    initializeStripe();

    _cardFormController.addListener(updateCardFormValidStatus);
  }

  // Atualiza o status de validade do formulário do cartão
  void updateCardFormValidStatus() {
    setState(() {
      _isCardFormValid = _cardFormController.details.complete;
    });
  }

  // Inicializa o Stripe SDK com a chave publishable
  Future<void> initializeStripe() async {
    stripe.Stripe.publishableKey = _stripePublishableKey;
    await stripe.Stripe.instance.applySettings();
  }

  // Função para formatar o valor monetário
  String formatCurrency(double amount) {
    final formatCurrency = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    );
    return formatCurrency.format(amount);
  }

  // Função para processar o pagamento com Stripe
  Future<void> processPayment() async {
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _addressController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor, preencha todos os campos.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    if (_paymentMethod == 'Cartão de Crédito') {
      try {
        if (!_isCardFormValid) {
          setState(() {
            _isLoading = false;
            _errorMessage =
                'Por favor, preencha os dados do cartão corretamente.';
          });
          return;
        }

        // Etapa 1: Criar intent de pagamento no servidor
        final paymentIntentResult = await _createPaymentIntent();

        // Etapa 2: Preparar os dados de cobrança
        final billingDetails = stripe.BillingDetails(
          name:
              _cardHolderController.text.isNotEmpty
                  ? _cardHolderController.text
                  : _nameController.text,
          phone: _phoneController.text,
          address: stripe.Address(
            line1: _addressController.text,
            line2: '',
            city: 'Belo Horizonte',
            state: 'Minas Gerais',
            postalCode: '00000-000',
            country: 'BR',
          ),
        );

        // Etapa 3: Confirmar o pagamento com o Stripe SDK
        await stripe.Stripe.instance.confirmPayment(
          paymentIntentClientSecret: paymentIntentResult['clientSecret'],
          data: stripe.PaymentMethodParams.card(
            paymentMethodData: stripe.PaymentMethodData(
              billingDetails: billingDetails,
            ),
          ),
        );

        // Se chegou até aqui sem exceções, o pagamento foi bem-sucedido
        await _saveOrderToDatabase();

        setState(() {
          _isPaymentSuccessful = true;
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Erro no pagamento: ${e.toString()}';
        });
      }
    } else if (_paymentMethod == 'Pix' || _paymentMethod == 'Dinheiro') {
      // Para simplificar, consideramos os pagamentos Pix/Dinheiro como já aprovados
      try {
        await _saveOrderToDatabase();
        setState(() {
          _isPaymentSuccessful = true;
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Erro ao registrar pedido: ${e.toString()}';
        });
      }
    }
  }

  // Criar intent de pagamento no nosso servidor
  Future<Map<String, dynamic>> _createPaymentIntent() async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/create-payment-intent'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'amount': widget.totalPrice, 'currency': 'brl'}),
      );

      if (response.statusCode != 200) {
        throw Exception('Erro no servidor: ${response.body}');
      }

      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Erro na comunicação com servidor: ${e.toString()}');
    }
  }

  // Salvar detalhes do pedido no banco de dados
  Future<void> _saveOrderToDatabase() async {
    final orderDetails = {
      'customer_name': _nameController.text,
      'customer_phone': _phoneController.text,
      'delivery_address': _addressController.text,
      'total_price': widget.totalPrice,
      'items': widget.orderItems,
      'observations': widget.observations,
      'crust_type': widget.crustType,
      'size': widget.size,
      'payment_method': _paymentMethod,
      'order_date': DateTime.now().toIso8601String(),
      'status': _paymentMethod == 'Dinheiro' ? 'pending_payment' : 'paid',
    };

    try {
      final response = await http.post(
        Uri.parse('$apiUrl/save-order'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(orderDetails),
      );

      if (response.statusCode != 200) {
        throw Exception('Falha ao salvar o pedido');
      }

      // Pedido salvo com sucesso
      return;
    } catch (e) {
      throw Exception('Erro ao salvar pedido: ${e.toString()}');
    }
  }

  // Diálogo de confirmação de pagamento bem-sucedido
  void _showPaymentSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: Text('Pagamento Concluído'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 64),
                SizedBox(height: 16),
                Text('Seu pagamento foi processado com sucesso!'),
                SizedBox(height: 8),
                Text('O seu pedido está sendo preparado.'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // Voltar para a tela principal
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: Text('Voltar ao Menu Principal'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pagamento')),
      body:
          _isPaymentSuccessful
              ? _buildPaymentSuccessfulView()
              : _buildPaymentFormView(),
    );
  }

  // Widget para mostrar o formulário de pagamento
  Widget _buildPaymentFormView() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Resumo do pedido
          _buildOrderSummary(),

          SizedBox(height: 24),

          // Informações de entrega
          Text(
            'Informações para Entrega',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),

          // Nome
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Nome',
              labelStyle: TextStyle(color: Colors.black),
              border: OutlineInputBorder(),
              prefixIcon: Icon(
                  Icons.person,
                  color: Colors.red,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
            cursorColor: Colors.red,
          ),
          SizedBox(height: 12),

          // Telefone
          TextField(
            controller: _phoneController,
            decoration: InputDecoration(
              labelText: 'Telefone',
              labelStyle: TextStyle(color: Colors.black),
              border: OutlineInputBorder(),
              prefixIcon: Icon(
                Icons.phone,
                color: Colors.red,),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
            cursorColor: Colors.red,
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 12),

          // Endereço
          TextField(
            controller: _addressController,
            decoration: InputDecoration(
              labelText: 'Endereço Completo',
              labelStyle: TextStyle(color: Colors.black),
              border: OutlineInputBorder(),
              prefixIcon: Icon(
                  Icons.home,
                  color: Colors.red,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
            cursorColor: Colors.red,
            maxLines: 2,
          ),
          SizedBox(height: 24),

          // Método de pagamento
          Text(
            'Método de Pagamento',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),

          // Opções de pagamento
          _buildPaymentOptions(),

          if (_errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(_errorMessage, style: TextStyle(color: Colors.red)),
            ),

          SizedBox(height: 24),

          // Botão de pagamento
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isLoading ? null : processPayment,
              child:
                  _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                        'Finalizar Pagamento - ${formatCurrency(widget.totalPrice)}',
                        style: TextStyle(fontSize: 16),
                      ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget para exibir as opções de pagamento
  Widget _buildPaymentOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RadioListTile<String>(
          activeColor: Colors.red,
          title: Text('Cartão de Crédito'),
          value: 'Cartão de Crédito',
          groupValue: _paymentMethod,
          onChanged: (value) {
            setState(() {
              _paymentMethod = value!;
            });
          },
        ),

        // Campos de cartão de crédito - aparecem apenas quando "Cartão de Crédito" está selecionado
        if (_paymentMethod == 'Cartão de Crédito')
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dados do Cartão',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 12),

                // Usando CardFormField para campos separados
                stripe.CardFormField(
                  controller: _cardFormController,
                  style: stripe.CardFormStyle(
                    borderRadius: 8,
                    borderWidth: 1,
                    borderColor: Colors.grey.shade400,
                    textColor: Colors.black,
                    fontSize: 16,
                    placeholderColor: Colors.grey,
                    backgroundColor: Colors.white,
                    cursorColor: Colors.red,
                  ),
                ),

                // Mensagem sobre cartões de teste
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Para testes, utilize:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('Número: 4242 4242 4242 4242'),
                      Text('Validade: qualquer data futura'),
                      Text('CVC: qualquer 3 dígitos'),
                      Text('CEP: qualquer 5 dígitos'),
                    ],
                  ),
                ),
              ],
            ),
          ),

        RadioListTile<String>(
          activeColor: Colors.red,
          title: Text('Dinheiro'),
          value: 'Dinheiro',
          groupValue: _paymentMethod,
          onChanged: (value) {
            setState(() {
              _paymentMethod = value!;
            });
          },
        ),
        RadioListTile<String>(
          activeColor: Colors.red,
          title: Text('Pix'),
          value: 'Pix',
          groupValue: _paymentMethod,
          onChanged: (value) {
            setState(() {
              _paymentMethod = value!;
            });
          },
        ),

        // Exibir QR Code quando Pix estiver selecionado
        if (_paymentMethod == 'Pix')
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(
                  'Escaneie o QR Code para pagar',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 16),
                Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.qr_code_2, size: 100),
                        SizedBox(height: 8),
                        Text('QR Code PIX'),
                        Text(
                          '(Simulação)',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Após o pagamento, clique em finalizar para confirmar seu pedido.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
      ],
    );
  }

  // Widget para mostrar o resumo do pedido
  Widget _buildOrderSummary() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resumo do Pedido',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(),

            // Lista de itens do pedido
            ...widget.orderItems.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item['nome']),
                    Text(formatCurrency(item['preco'])),
                  ],
                ),
              ),
            ),

            Divider(),

            // Detalhes do tamanho e borda
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Row(
                children: [
                  Text(
                    'Tamanho: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(_getSizeText(widget.size)),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Row(
                children: [
                  Text(
                    'Borda: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(widget.crustType),
                ],
              ),
            ),

            if(widget.orderBeverages.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  children: [
                    Text(
                      'Bebidas: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ...widget.orderBeverages.map(
                    (item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if(item['quantidade'] >= 1)
                        Text('${item['quantidade'].toString()}x ${item['nome']}'),
                      //Text(item['nome']),
                      Text(formatCurrency(item['preco'])),
                    ],
                  ),
                ),
            ),
            // Observações, se houver
            if (widget.observations.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Observações: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(widget.observations),
                  ],
                ),
              ),

            Divider(),

            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  formatCurrency(widget.totalPrice),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget para mostrar a tela de pagamento bem-sucedido
  Widget _buildPaymentSuccessfulView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 100),
          SizedBox(height: 16),
          Text(
            'Pagamento Realizado com Sucesso!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'O seu pedido está sendo preparado.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MapScreen()),
              );
            },
            child: Text('Acompanhar Pedido'),
          ),
        ],
      ),
    );
  }

  // Função auxiliar para obter o texto do tamanho da pizza
  String _getSizeText(String size) {
    switch (size) {
      case 'P':
        return 'Pequena';
      case 'M':
        return 'Média';
      case 'G':
        return 'Grande';
      default:
        return size;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cardHolderController.dispose();
    _cardFormController.removeListener(updateCardFormValidStatus);
    _cardFormController.dispose();
    super.dispose();
  }
}
