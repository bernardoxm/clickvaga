# 🚗 Aplicativo de Gestão de Estacionamento para Sr. João

## 📌 Cenário Atual

O Sr. João gerencia um estacionamento e atualmente controla a entrada e saída de caminhões utilizando um caderno físico. Ele registra manualmente quais vagas estão ocupadas e quais estão livres, o que pode gerar erros e dificultar a gestão.

## 🎯 Necessidade

Para modernizar a administração do estacionamento, o aplicativo deverá permitir:

- ✅ **Registro de entrada e saída** dos caminhões.
- ✅ **Monitoramento em tempo real** das vagas ocupadas e disponíveis.
- ✅ **Histórico de movimentações** para facilitar o fechamento diário.
- ✅ **Interface simples e intuitiva**, focada na facilidade de uso para o Sr. João.

## ⚙️ Expectativas para o Desenvolvimento

### 📂 Arquitetura
O desenvolvedor pode escolher a arquitetura que preferir, desde que siga boas práticas de organização e estruturação.

### 💡 Boas Práticas
O código deve ser desenvolvido seguindo princípios como:
- **SOLID**
- **DRY**
- **Clean Code**

### ✅ Testes Automatizados
- Implementação de **testes unitários** e **testes de widgets** para garantir a confiabilidade da aplicação.

### 🎨 Interface Amigável
- Layout **simples e intuitivo**, focado na usabilidade para que o Sr. João possa operar sem dificuldades.

## 💻 Tecnologia Sugerida
- Desenvolvimento com **Flutter**, garantindo compatibilidade multiplataforma e boa performance.

## 📌 Conclusão
O objetivo do projeto é substituir o caderno físico do Sr. João por um aplicativo eficiente e fácil de usar, ajudando na gestão do estacionamento de forma moderna e prática.

-------------------------------------------------------------------------


# Parking Spot Manager

## Descrição

Este é um aplicativo Flutter para gerenciamento de vagas de estacionamento. Ele permite registrar, filtrar e visualizar histórico de ocupação de vagas.

## Tecnologias Utilizadas

- **Flutter**: Framework para desenvolvimento de aplicativos multiplataforma.
- **Dart**: Linguagem de programação utilizada no Flutter.
- **BLoC (Business Logic Component)**: Gerenciamento de estado.
- **SharedPreferences**: Armazenamento local de preferências do usuário.
- **Testes Unitários**: Implementados para garantir a qualidade do código.

## Estrutura do Projeto

```
lib/
├── main.dart                 # Ponto de entrada do aplicativo
├── repository/               # Classes para acesso a dados e lógica de repositório
├── models/                   # Estruturas de dados do aplicativo
├── data/                     # Funções auxiliares e banco de dados local
├── pages/                    # Telas do aplicativo (histórico, vagas, etc.)
├── widgets/                  # Componentes reutilizáveis (cards, diálogos)
└── bloc/                     # Gerenciamento de estado usando BLoC

test/                         # Testes unitários para os repositórios e blocos
```

## Como Executar o Projeto

1. Certifique-se de ter o [Flutter](https://flutter.dev/docs/get-started/install) instalado.
2. Clone o repositório:
   ```sh
   git clone https://github.com/seu-usuario/seu-repositorio.git
   ```
3. Acesse o diretório do projeto:
   ```sh
   cd seu-repositorio
   ```
4. Instale as dependências:
   ```sh
   flutter pub get
   ```
5. Execute o aplicativo:
   ```sh
   flutter run
   ```

## Testes

Para executar os testes, utilize o seguinte comando:

```sh
flutter test
```

## Contribuição

Se deseja contribuir, siga os passos:

1. Fork o repositório.
2. Crie uma nova branch.
3. Implemente sua melhoria ou correção.
4. Envie um pull request.

## Imagens do Projeto

| Tela 1 | Tela 2 | Tela 3 |
|--------|--------|--------|
| ![Imagem 1](https://github.com/user-attachments/assets/14d94b71-f733-48e1-b7a9-e6a12638d8d0) | ![Imagem 2](https://github.com/user-attachments/assets/86fa493f-e25a-46af-b04d-2291bf9689b9) | ![Imagem 3](https://github.com/user-attachments/assets/d0248bee-1b83-499a-a76f-74cd44ab556f) |
| Tela 4 | Tela 5 | Tela 6 |
|--------|--------|--------|
| ![Imagem 4](https://github.com/user-attachments/assets/005ed124-417a-437a-8abe-f50bf512e8d6) | ![Imagem 5](https://github.com/user-attachments/assets/6d7144fd-d2dc-4e11-8c33-71777fb3aa47) | ![Imagem 6](https://github.com/user-attachments/assets/a6b14906-8e41-44f9-9645-756ca6b7a7b5) |

## Licença

Este projeto está sob a licença MIT. Consulte o arquivo `LICENSE` para mais informações.

