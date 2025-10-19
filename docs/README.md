# Documentação Nexa App

> **Central de documentação técnica do projeto**

---

## 📚 Guias Disponíveis

| Documento                                    | Descrição                            | Quando Consultar                              |
| -------------------------------------------- | ------------------------------------ | --------------------------------------------- |
| **[ARCHITECTURE.md](ARCHITECTURE.md)**       | Arquitetura completa em camadas      | Entender estrutura geral, criar novos módulos |
| **[STYLE_GUIDE.md](STYLE_GUIDE.md)**         | Padrões de código e convenções       | Code review, desenvolvimento diário           |
| **[MODULE_TEMPLATE.md](MODULE_TEMPLATE.md)** | Templates prontos para copiar        | Criar nova feature/módulo                     |
| **[MIGRATION_GUIDE.md](MIGRATION_GUIDE.md)** | Guia de migração para nova estrutura | Executar refatoração de arquitetura           |
| **[DIAGRAMS.md](DIAGRAMS.md)**               | Diagramas visuais da arquitetura     | Onboarding, apresentações                     |

---

## 🎯 Guia Rápido por Persona

### 👨‍💻 **Novo Desenvolvedor**

Leia nesta ordem:

1. [ARCHITECTURE.md](ARCHITECTURE.md) - Entender a estrutura
2. [DIAGRAMS.md](DIAGRAMS.md) - Visualizar fluxos
3. [STYLE_GUIDE.md](STYLE_GUIDE.md) - Aprender padrões
4. [MODULE_TEMPLATE.md](MODULE_TEMPLATE.md) - Ver exemplos

### 🏗️ **Criando Nova Feature**

Siga este fluxo:

1. [MODULE_TEMPLATE.md](MODULE_TEMPLATE.md) - Copiar templates
2. [ARCHITECTURE.md](ARCHITECTURE.md) - Verificar onde criar
3. [STYLE_GUIDE.md](STYLE_GUIDE.md) - Seguir convenções
4. Criar PR para review

### 🔍 **Code Review**

Use este checklist:

1. [STYLE_GUIDE.md](STYLE_GUIDE.md) - Verificar padrões
2. [ARCHITECTURE.md](ARCHITECTURE.md) - Validar estrutura
3. Aprovar ou solicitar mudanças

### 🔄 **Refatoração de Arquitetura**

Execute nesta ordem:

1. [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md) - Plano completo
2. Executar migração incremental
3. Atualizar documentação se necessário

---

## 📁 Estrutura de Pastas (Resumo)

```
lib/
├── app/                # Config, rotas
├── core/               # Database, network, utils
├── data/               # DAOs, DTOs, Repositories
├── domain/             # Entities, Interfaces, UseCases
├── presentation/       # Módulos (controller + page + binding)
│   ├── turno/         # Módulo completo
│   ├── home/
│   ├── login/
│   └── splash/
└── shared/             # Widgets, middlewares globais
```

> 📖 Detalhes completos em [ARCHITECTURE.md](ARCHITECTURE.md)

---

## 🎯 Princípios do Projeto

1. **Separação de Responsabilidades**

   - Cada camada tem um papel específico
   - Domain é independente de tudo

2. **Organização por Módulos**

   - Código relacionado fica junto
   - Fácil encontrar e manter

3. **Testabilidade**

   - Injeção de dependências
   - Código desacoplado

4. **Performance**

   - Obx granulares
   - Const widgets
   - Cache inteligente

5. **Qualidade**
   - Null safety
   - Logs detalhados
   - Documentação completa

---

## 🛠️ Ferramentas

### Desenvolvimento

```bash
# Análise de código
flutter analyze

# Formatação
dart format .

# Testes
flutter test

# Coverage
flutter test --coverage

# Build
flutter build apk
```

### Geração de Código

```bash
# Drift (database)
dart run build_runner build --delete-conflicting-outputs

# Watch mode
dart run build_runner watch
```

---

## 📊 Status do Projeto

| Aspecto          | Status           | Progresso |
| ---------------- | ---------------- | --------- |
| **Arquitetura**  | 🟡 Em migração   | 50%       |
| **Documentação** | ✅ Completa      | 100%      |
| **Testes**       | 🔴 Insuficientes | 20%       |
| **Performance**  | ✅ Otimizada     | 90%       |
| **Null Safety**  | ✅ Completo      | 100%      |

---

## 🎓 Recursos Externos

- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [GetX Documentation](https://github.com/jonataslaw/getx)
- [Drift Documentation](https://drift.simonbinder.eu/)
- [Flutter Best Practices](https://flutter.dev/docs/development/best-practices)
- [Effective Dart](https://dart.dev/guides/language/effective-dart)

---

## 👥 Contribuindo

1. Fork o projeto
2. Crie uma branch (`git checkout -b feature/nova-feature`)
3. Siga os guias de [ARCHITECTURE.md](ARCHITECTURE.md) e [STYLE_GUIDE.md](STYLE_GUIDE.md)
4. Commit suas mudanças (`git commit -m 'feat: adiciona nova feature'`)
5. Push para a branch (`git push origin feature/nova-feature`)
6. Abra um Pull Request

---

## 📞 Suporte

- **Documentação:** Veja [`docs/`](.)
- **Issues:** [GitHub Issues](link-do-repo)
- **Time:** Equipe Nexa

---

**Última atualização:** Outubro 2025  
**Versão:** 2.0
