# 📒 Minha Agenda

## 🔍 Sobre o Projeto  
**Minha Agenda** é um aplicativo de gerenciamento de contatos que permite aos usuários **armazenar, visualizar, editar e excluir** informações de contatos. Conta ainda com funcionalidades extras como **ordenação alfabética** e **integração com mapas** para exibir a localização dos contatos.

---

## 🚀 Funcionalidades  

### 📱 Gerenciamento de Contatos  
- ✅ Adicionar, editar e excluir contatos  
- 👁️ Visualizar detalhes completos de cada contato  

### 🔡 Ordenação  
- 🔼 A-Z  
- 🔽 Z-A  

### 🗽 Integração com Mapas  
- 📍 Exibir a localização dos contatos  
- 📌 Permitir acesso à localização atual do usuário  

### 👤 Gerenciamento de Conta  
- 🧹 Apagar conta com confirmação de senha  
- 🚪 Logout com redirecionamento para tela inicial  

---

## 🧰 Tecnologias Utilizadas  

| Tecnologia            | Finalidade                              |
|-----------------------|------------------------------------------|
| **Flutter 3.29.2**    | Desenvolvimento do app                   |
| **Dart 3.7.2**        | Linguagem de programação                 |
| **ChangeNotifier**    | Gerenciamento de estado                  |
| **Flutter Map**       | Exibição de mapas e marcadores           |
| **Sembast + LocalStorage** | Armazenamento local dos dados      |

---

## 📁 Estrutura do Projeto

```plaintext
lib/
└── src/
    ├── models/
    │   └── contato_model.dart          # Modelo de dados para contatos
    ├── modules/
    │   ├── auth/
    │   │   └── presentation/
    │   │       └── auth_page.dart      # Tela de autenticação
    │   └── contacts/
    │       ├── presentation/
    │       │   ├── contact_page.dart   # Tela principal de contatos
    │       │   └── contact_store.dart  # Estado dos contatos
    │       └── widgets/
    │           └── contato_widget.dart # Widget de exibição
    └── utils/
        └── validators.dart             # Validações de entrada (CPF, e-mail)
```

---

## ⚙️ Configuração do Ambiente

### Pré-requisitos
- ✅ Flutter SDK instalado ([guia de instalação](https://docs.flutter.dev/get-started/install))
- ✅ Google Chrome ou outro navegador moderno

### Passos

1. **Clone o repositório:**
   ```bash
   git clone https://github.com/seu-usuario/minha-agenda.git
   cd minha-agenda
   ```

2. **Instale as dependências:**
   ```bash
   flutter pub get
   ```

3. **Execute o projeto:**
   ```bash
   flutter run -d web-server
   ```

---

## 👨‍💼 Autor

Desenvolvido por **Jefferson Rodrigues**  
📧 E-mail: [jdp.jeffersondavid@gmail.com](mailto:jdp.jeffersondavid@gmail.com)  
🐝 GitHub: [rodriguesjeff](https://github.com/rodriguesjeff)  
💼 LinkedIn: [Jefferson Rodrigues](https://www.linkedin.com/in/rodriguesjeffdev/)