# PizzaRush

Aplicativo de entrega de pizzas desenvolvido com Flutter, incluindo funcionalidades de pedidos, pagamentos via Stripe, histórico de pedidos e integração com mapas para entrega.

## Requisitos

- Flutter SDK v3.7.2 ou superior
- Node.js v14 ou superior
- Conta Stripe (para processamento de pagamentos)

## Configuração Inicial

### 1. Configuração do ambiente Flutter

Certifique-se de ter o Flutter instalado e configurado corretamente:

```bash
flutter doctor
```

Instale todas as dependências do projeto:

```bash
flutter pub get
```

### 2. Configurando o Endereço IP do Servidor

Para que o aplicativo se comunique corretamente com o servidor, é necessário configurar o endereço IP local da sua máquina nos arquivos do projeto.

#### 2.1 Descobrindo seu endereço IP local

**Windows:**
1. Abra o Prompt de Comando (cmd) ou PowerShell
2. Execute o comando: `ipconfig`
3. Procure por "IPv4 Address" ou "Endereço IPv4" na seção da sua rede ativa (geralmente Ethernet ou Wi-Fi)
4. Anote o endereço IP (formato: 192.168.x.x)

**macOS / Linux:**
1. Abra o Terminal
2. Execute o comando: `ifconfig` (Linux/macOS mais antigo) ou `ip addr` (Linux mais recente)
3. Procure pelo endereço IP da sua interface de rede ativa (geralmente en0 ou wlan0)
4. Anote o endereço IP (formato: 192.168.x.x)

#### 2.2 Atualizando os arquivos do aplicativo

Após descobrir seu endereço IP local, você precisa atualizá-lo em dois arquivos:

**1. No arquivo `lib/map_screen.dart`:**

Localize a linha e substitua pelo seu IP:
```dart
final String apiUrl = 'http://SEU_IP_AQUI:4242';
```

**2. No arquivo `lib/payment_screen.dart`:**

Localize a linha e substitua pelo seu IP:
```dart
const String apiUrl = 'http://SEU_IP_AQUI:4242';
```

**Observação importante:** 
- Se estiver usando um emulador Android, você pode precisar usar `10.0.2.2` em vez do seu IP para acessar o localhost.
- Se estiver usando um dispositivo físico, certifique-se que ele esteja conectado na mesma rede Wi-Fi que seu computador.

### 3. Configuração do Servidor

O aplicativo utiliza um servidor Node.js para processar pagamentos via Stripe e gerenciar pedidos.

1. Navegue até a pasta do servidor:
   ```bash
   cd server
   ```

2. Instale as dependências:
   ```bash
   npm install
   ```

3. Configure as variáveis de ambiente criando um arquivo `.env` na pasta `server`:
   ```
   STRIPE_SECRET_KEY=sua_chave_secreta_do_stripe
   ```

### 4. Iniciando o Servidor

Após configurar o IP nos arquivos do aplicativo, você deve iniciar o servidor:

1. Navegue até a pasta do servidor:
   ```bash
   cd server
   ```

2. Inicie o servidor:
   ```bash
   node server.js
   ```

   Você deverá ver uma mensagem confirmando que o servidor está rodando em `http://localhost:4242`.

3. Mantenha o terminal com o servidor aberto enquanto estiver usando o aplicativo.

## Executando a Aplicação

### 1. Executando o Aplicativo Flutter

Com o servidor já em execução, execute o aplicativo em um emulador ou dispositivo físico:

```bash
flutter run
```

## Recursos e Funcionalidades

- Cardápio de pizzas com opções de personalização
- Carrinho de compras
- Processamento de pagamentos via Stripe
- Histórico de pedidos
- Rastreamento de entrega com integração de mapas
- Perfil de usuário e endereços salvos

## Estrutura do Projeto

- `lib/`: Código-fonte principal do Flutter
- `server/`: Servidor Node.js para processamento de pagamentos e gerenciamento de pedidos
- `database/`: Serviços e definições para banco de dados local
- `assets/`: Imagens e recursos estáticos

## Solução de Problemas

### Problemas de Conexão com o Servidor

- **Erro de conexão recusada**: Verifique se o servidor está em execução e se o IP está configurado corretamente nos arquivos do aplicativo.
- **Servidor não inicia**: Verifique se a porta 4242 está disponível e se as dependências foram instaladas corretamente.

### Problemas com o servidor

Se o servidor não iniciar corretamente:
- Verifique se a porta 4242 está disponível
- Certifique-se que as variáveis de ambiente estão configuradas corretamente
- Confirme que as dependências foram instaladas com `npm install`

### Problemas com a integração do Stripe

- Verifique se a chave secreta do Stripe está configurada corretamente no servidor

## Licença

Este projeto está licenciado sob a licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.
