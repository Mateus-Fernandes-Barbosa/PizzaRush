const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const stripe = require('stripe');

// Configuração
dotenv.config();
const app = express();
const port = process.env.PORT || 4242;
const stripeClient = stripe(process.env.STRIPE_SECRET_KEY);

// Variável para armazenar o último pedido
let lastOrder = null;

// Middleware
app.use(express.json());
app.use(cors());

// Rotas
app.get('/', (req, res) => {
  res.send('API do Stripe para PizzaRush está funcionando!');
});

// Endpoint para criar um Payment Intent
app.post('/create-payment-intent', async (req, res) => {
  try {
    const { amount, currency = 'brl' } = req.body;
    
    // Valida o valor
    if (!amount || amount <= 0) {
      return res.status(400).json({ error: 'Valor inválido' });
    }
    
    // Cria o Payment Intent no Stripe
    const paymentIntent = await stripeClient.paymentIntents.create({
      amount: Math.round(amount * 100), // O Stripe espera o valor em centavos
      currency: currency,
      automatic_payment_methods: {
        enabled: true,
      },
    });
    
    // Retorna o client_secret para o cliente
    return res.json({
      clientSecret: paymentIntent.client_secret,
      id: paymentIntent.id,
      amount: amount
    });
  } catch (error) {
    console.error('Erro ao criar Payment Intent:', error);
    return res.status(500).json({ error: error.message });
  }
});

// Endpoint para salvar o pedido (simulado)
app.post('/save-order', async (req, res) => {
  try {
    const orderDetails = req.body;

    // Salva os detalhes do pedido na variável
    lastOrder = orderDetails;

    console.log('Pedido recebido:', orderDetails);

    // Simulando sucesso
    return res.json({
      success: true,
      message: 'Pedido salvo com sucesso!',
      orderId: `ORDER-${Date.now()}`
    });
  } catch (error) {
    console.error('Erro ao salvar pedido:', error);
    return res.status(500).json({ error: error.message });
  }
});

// Rota para obter o último pedido
app.get('/last-order', (req, res) => {
  if (lastOrder) {
    return res.json({
      success: true,
      lastOrder
    });
  } else {
    return res.status(404).json({
      success: false,
      message: 'Nenhum pedido encontrado.'
    });
  }
});

// Inicia o servidor
app.listen(port, () => {
  console.log(`Servidor rodando em http://localhost:${port}`);
});