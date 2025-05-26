# 🌟 TrocaFácil

Uma aplicação móvel moderna para troca e compartilhamento de itens, focada em sustentabilidade e economia colaborativa, para utilizadores iOS e Android.

## 📱 Capturas de Ecrã

<table>
  <tr>
    <td>Tela de Login</td>
    <td>Explorar Itens</td>
    <td>Meus Itens</td>
  </tr>
</table>

## Requisitos Prévios

- Flutter SDK ≥ 3.0.0
- Dart ≥ 2.17.0
- Android Studio / Xcode
- Firebase CLI

## Instalação

1. Clone o repositório:
   ```bash
   git clone https://github.com/username/trocafacil.git
   ```

2. Instale as dependências:
   ```bash
   flutter pub get
   ```

3. Configure o Firebase:
   - Crie um projeto no Firebase Console
   - Adicione as configurações do Firebase ao projeto
   - Configure o Firestore e Authentication

## Funcionalidades Principais

### 👤 Autenticação
1. Abra a aplicação
2. Clique em "Registrar" ou "Iniciar Sessão"
3. Preencha os dados necessários

### 📦 Gestão de Itens
- Adicionar novo item: Clique no botão "+" e preencha título, descrição e imagem
- Visualizar seus itens: Acesse a aba "Meus Itens"
- Explorar itens: Navegue pela aba "Explorar" para ver itens de outros usuários

## Arquitetura

Este projeto segue uma arquitetura modular com separação clara de responsabilidades.

```mermaid
graph TD
    A[Presentation Layer (UI)] --> B[Services Layer]
    B --> C[Firebase/External Services]
```

### Estrutura de Pastas
```
lib/
├── screens/      # Telas da aplicação
├── services/     # Serviços (Auth, Imgur, etc.)
└── widgets/      # Widgets reutilizáveis
```

### Tecnologias Principais
- **Flutter**: Framework principal para desenvolvimento multiplataforma
- **Firebase**: Backend as a Service (Auth, Firestore)
- **Provider**: Para gestão de estado
- **Imgur API**: Para upload de imagens

## Autor

**Nome:** [Diogo Rodrigues, Gonçalo Marques]
**Email:** [a79299@ualg.pt, a71433@ualg.pt]

## Licença

Este projeto está licenciado sob a Licença MIT - consulte o arquivo [LICENSE.md](LICENSE.md) para detalhes.

## Referências

- [Flutter Documentation](https://docs.flutter.dev)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Imgur API Documentation](https://api.imgur.com/)