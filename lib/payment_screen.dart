import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class PaymentScreen extends StatelessWidget {
  final double totalPrice;
  final List<Map<String, dynamic>> orderItems;
  final String observations;
  final String crustType;
  final String size;

  PaymentScreen({
    Key? key,
    required this.totalPrice,
    required this.orderItems,
    required this.observations,
    required this.crustType,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _PaymentScreen(
      totalPrice: totalPrice,
      orderItems: orderItems,
      observations: observations,
      crustType: crustType,
      size: size,
    );
  }
}

class _PaymentScreen extends StatefulWidget {
  final double totalPrice;
  final List<Map<String, dynamic>> orderItems;
  final String observations;
  final String crustType;
  final String size;

  _PaymentScreen({
    required this.totalPrice,
    required this.orderItems,
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
  
  // String chave API Stripe (substitua pela sua chave quando for usar em produção)
  final String _stripePublishableKey = 'pk_test_51RKTqQGdX2861DLQEnFTJ31HtmKYew42HqsuF0CwNCtpXhcYmkAM3AqIRVCLfmG8S8uOcCAe7B9a7R9nftwVOsmz00Kh1nzjiw';
  
  // Controladores para os campos do formulário
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  
  // Controladores para os campos de cartão de crédito
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardExpiryController = TextEditingController();
  final TextEditingController _cardCvvController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Inicialize o Stripe SDK
    initializeStripe();
  }

  // Inicializa o Stripe SDK com a chave publishable
  Future<void> initializeStripe() async {
    stripe.Stripe.publishableKey = _stripePublishableKey;
    await stripe.Stripe.instance.applySettings();
  }

  // Função para formatar o valor monetário
  String formatCurrency(double amount) {
    final formatCurrency = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
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

    try {
      // Etapa 1: Criar intent de pagamento no servidor (normalmente feito no backend)
      final paymentIntentResult = await _createPaymentIntent();
      
      // Etapa 2: Confirmar o pagamento com o Stripe SDK
      await _confirmPayment(paymentIntentResult['client_secret']);

      // Se chegou até aqui sem exceções, o pagamento foi bem-sucedido
      setState(() {
        _isPaymentSuccessful = true;
        _isLoading = false;
      });
      
      // Exibir confirmação de pagamento
      _showPaymentSuccessDialog();
      
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Erro no pagamento: ${e.toString()}';
      });
    }
  }

  // Criar intent de pagamento (normalmente feito no backend)
  Future<Map<String, dynamic>> _createPaymentIntent() async {
    // Idealmente, esta chamada seria para o seu próprio backend que se comunicaria com a API do Stripe
    // Aqui, estamos simulando uma resposta do servidor para fins de demonstração
    
    // Em um cenário real, você faria algo como:
    /*
    final response = await http.post(
      Uri.parse('https://your-backend-url.com/create-payment-intent'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'amount': (widget.totalPrice * 100).toInt(), // O valor deve estar em centavos
        'currency': 'brl',
      }),
    );
    return jsonDecode(response.body);
    */
    
    // Para fins de demonstração, simulamos uma resposta
    return {
      'id': 'mock_payment_intent_id',
      'client_secret': 'mock_client_secret',
      'amount': (widget.totalPrice * 100).toInt(),
      'status': 'requires_payment_method',
    };
  }

  // Confirmar pagamento com o Stripe SDK
  Future<void> _confirmPayment(String clientSecret) async {
    // Em um app real, você usaria algo como:
    /*
    final paymentMethod = await Stripe.instance.createPaymentMethod(
      params: PaymentMethodParams.card(
        paymentMethodData: PaymentMethodData(),
      ),
    );
    
    await Stripe.instance.confirmPayment(
      paymentIntentClientSecret: clientSecret,
      data: PaymentMethodParams.card(
        paymentMethodData: PaymentMethodData(
          billingDetails: BillingDetails(
            name: _nameController.text,
            phone: _phoneController.text,
            address: Address(
              line1: _addressController.text,
              country: 'BR',
            ),
          ),
        ),
      ),
    );
    */
    
    // Para fins de demonstração, apenas simulamos um pagamento bem-sucedido após um atraso
    await Future.delayed(const Duration(seconds: 2));
    
    // Em um cenário real, a confirmação seria retornada pelo método acima
    // Se o método não lançar uma exceção, o pagamento foi bem-sucedido
  }

  // Salvar detalhes do pedido no banco de dados
  Future<void> _saveOrderToDatabase() async {
    // Aqui você normalmente enviaria os detalhes do pedido para seu backend
    // Esta é uma simulação para fins de demonstração
    
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
      'status': 'paid',
    };
    
    // Em um app real, você faria algo como:
    /*
    final response = await http.post(
      Uri.parse('https://your-backend-url.com/save-order'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(orderDetails),
    );
    
    if (response.statusCode != 200) {
      throw Exception('Falha ao salvar o pedido');
    }
    */
    
    // Para fins de demonstração, apenas imprimimos os detalhes no console
    debugPrint('Detalhes do pedido: $orderDetails');
  }

  // Diálogo de confirmação de pagamento bem-sucedido
  void _showPaymentSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
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
              // Salvar os detalhes do pedido (em um cenário real)
              _saveOrderToDatabase();
              
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
      appBar: AppBar(
        title: Text('Pagamento'),
      ),
      body: _isPaymentSuccessful
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
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
          ),
          SizedBox(height: 12),
          
          // Telefone
          TextField(
            controller: _phoneController,
            decoration: InputDecoration(
              labelText: 'Telefone',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.phone),
            ),
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 12),
          
          // Endereço
          TextField(
            controller: _addressController,
            decoration: InputDecoration(
              labelText: 'Endereço Completo',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.home),
            ),
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
              child: Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            ),
          
          SizedBox(height: 24),
          
          // Botão de pagamento
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isLoading ? null : processPayment,
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                      'Finalizar Pagamento - ${formatCurrency(widget.totalPrice)}',
                      style: TextStyle(fontSize: 16),
                    ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
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
              color: Colors.grey.shade100,
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
                
                // Nome no cartão
                TextField(
                  controller: _cardHolderController,
                  decoration: InputDecoration(
                    labelText: 'Nome no cartão',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                SizedBox(height: 12),
                
                // Número do cartão
                TextField(
                  controller: _cardNumberController,
                  decoration: InputDecoration(
                    labelText: 'Número do cartão',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.credit_card),
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 19,
                  onChanged: (value) {
                    // Formatar o número do cartão em grupos de 4 dígitos
                    if (value.length > 0 && !value.contains(' ')) {
                      final formattedValue = value.replaceAllMapped(
                        RegExp(r".{4}"),
                        (match) => "${match.group(0)} ",
                      );
                      _cardNumberController.value = TextEditingValue(
                        text: formattedValue.trim(),
                        selection: TextSelection.collapsed(offset: formattedValue.length),
                      );
                    }
                  },
                ),
                SizedBox(height: 12),
                
                // Layout de duas colunas para validade e CVV
                Row(
                  children: [
                    // Data de validade
                    Expanded(
                      child: TextField(
                        controller: _cardExpiryController,
                        decoration: InputDecoration(
                          labelText: 'Validade (MM/AA)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.date_range),
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 5,
                        onChanged: (value) {
                          // Formatar a data de validade como MM/AA
                          if (value.length == 2 && !value.contains('/')) {
                            _cardExpiryController.text = '$value/';
                            _cardExpiryController.selection = TextSelection.fromPosition(
                              TextPosition(offset: _cardExpiryController.text.length),
                            );
                          }
                        },
                      ),
                    ),
                    SizedBox(width: 12),
                    // CVV
                    Expanded(
                      child: TextField(
                        controller: _cardCvvController,
                        decoration: InputDecoration(
                          labelText: 'CVV',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.security),
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 3,
                        obscureText: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
        RadioListTile<String>(
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
                        Text('(Simulação)', style: TextStyle(color: Colors.grey)),
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
            ...widget.orderItems.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item['nome']),
                  Text(formatCurrency(item['preco'])),
                ],
              ),
            )),
            
            Divider(),
            
            // Detalhes do tamanho e borda
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Row(
                children: [
                  Text('Tamanho: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(_getSizeText(widget.size)),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Row(
                children: [
                  Text('Borda: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.crustType),
                ],
              ),
            ),
            
            // Observações, se houver
            if (widget.observations.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Observações: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(widget.observations),
                  ],
                ),
              ),
              
            Divider(),
            
            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'O seu pedido está sendo preparado.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: Text('Voltar ao Menu Principal'),
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
    _cardNumberController.dispose();
    _cardExpiryController.dispose();
    _cardCvvController.dispose();
    _cardHolderController.dispose();
    super.dispose();
  }
}