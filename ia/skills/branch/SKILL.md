---
name: branch
description: Analisa o contexto disponível (texto do usuário, issue, conversa, alterações no repositório) e sugere o nome da branch no padrão `feature/[tipo/]<issue>-<descricao>`, com tipos no estilo Conventional Commits (`fix`, `refactor`, `chore`, `perf`, `test`, `docs`, `hotfix`). Use quando o usuário pedir para sugerir, gerar, nomear ou revisar o nome de uma branch.
user-invocable: true
disable-model-invocation: false
---

# Nome de branch

Sugere um nome de branch curto, objetivo e compatível com a arquitetura atual do repositório. A skill **apenas sugere**: nunca cria, renomeia ou remove branches, a menos que o usuário peça explicitamente.

Qualquer texto após `branch` é contexto do usuário (ex.: `branch 1605 paginação na consulta de fornecedores`) e tem prioridade sobre o que for inferido.

## Padrão

Toda branch começa com `feature/`, seguida do número da issue e de uma descrição objetiva:

| Natureza da mudança | Formato | Exemplo |
|---------------------|---------|---------|
| Funcionalidade nova | `feature/<issue>-<descricao>` | `feature/1605-paginacao-fornecedores` |
| Demais tipos | `feature/<tipo>/<issue>-<descricao>` | `feature/fix/1234-timeout-consulta-empenho`, `feature/refactor/1234-extrai-repositorio` |

O tipo é sempre um nível hierárquico próprio, separado por barra (`feature/fix/...`), nunca prefixo com hífen (`feature/fix-1234-...`).

- Para funcionalidade nova, **não** usar `feature/feat/...`: é redundante.
- Tipos permitidos (estilo Conventional Commits):

  | Tipo | Quando usar |
  |------|-------------|
  | `fix` | Correção de bug. |
  | `hotfix` | Correção urgente para produção, fora do fluxo normal de entrega. |
  | `refactor` | Reestruturação sem mudar comportamento. |
  | `perf` | Melhoria de desempenho. |
  | `test` | Somente testes. |
  | `docs` | Somente documentação. |
  | `chore` | Manutenção, build, dependências, CI, configuração. |

  Não use outros tipos (`style`, `build`, `ci`, etc.); mapeie-os para `chore` ou para o tipo mais próximo.

## Entrada

Qualquer combinação de:

- Texto do usuário (número e título da issue, descrição da demanda).
- Descrição da issue colada ou referenciada.
- Contexto da conversa atual.
- Repositório Git no diretório atual (somente leitura):
  - `git branch --show-current` e `git --no-pager diff --stat` para inferir a natureza da mudança, se já houver trabalho iniciado.
  - `git branch -a --list "feature/*"` para seguir as convenções existentes e evitar conflito de nomes (ver Cuidados).

## Processo

1. **Coletar contexto** conforme a seção Entrada.
2. **Obter o número da issue.** É obrigatório. Se não estiver no contexto, pergunte ao usuário com a ferramenta de perguntas; se ele não souber, use `<issue>` como marcador na sugestão e avise. Nunca invente o número.
3. **Classificar o tipo** pela intenção principal. Funcionalidade nova → sem tipo. Ambiguidade relevante (ex.: `fix` x `hotfix`, funcionalidade x `refactor`) → entregue a melhor opção e mencione a alternativa.
4. **Redigir a descrição** (slug) conforme as regras abaixo.
5. **Validar** o tamanho e os conflitos (ver Cuidados) e revisar com a lista de verificação.

## Descrição (slug)

- Somente letras minúsculas `a-z`, dígitos `0-9` e hífen `-`. Sem acentos, cedilha, espaços, `_`, `.` ou outros símbolos (`ç` → `c`, `ã` → `a`).
- Sem hífens duplicados nem hífen no início ou no fim.
- **2 a 5 palavras**, focadas no essencial: o assunto e, quando ajudar, a ação ou o alvo (`paginacao-fornecedores`, `timeout-login`, `atualiza-spring-boot-3`).
- Remova artigos e preposições sem valor (`o`, `a`, `de`, `da`, `do`, `para`, `com`), desde que o sentido se mantenha.
- Não repita o tipo na descrição (`feature/fix/1612-corrige-timeout` → `feature/fix/1612-timeout-login`).
- Idioma: siga o predominante nas branches existentes; sem histórico, use **português**.

## Cuidados

- **Tamanho:** o slug da branch (ex.: `CI_COMMIT_REF_SLUG` no GitLab, usado em ambientes e URLs) é cortado em **63 caracteres**. O nome completo da branch, incluindo `feature/` e o tipo, deve ter **no máximo 63 caracteres**; prefira bem menos (ideal até 40). Se passar do limite, encurte a descrição.
- **Conflito de refs:** o Git trata as barras como diretórios, então não podem coexistir `feature/fix` e `feature/fix/123-...`. Se `git branch -a` mostrar uma branch chamada exatamente `feature/<tipo>` (ex.: `feature/fix`), avise o usuário de que a sugestão não poderá ser criada enquanto ela existir.
- **Duplicidade:** se já existir branch com o mesmo número de issue, informe-a; o usuário pode querer reutilizá-la em vez de criar outra.

## Formato de entrega

- Um bloco de código `shell` com o comando pronto:

  ```shell
  git switch -c feature/fix/1612-timeout-login
  ```

- Após o bloco, em até 3 bullets e somente se aplicável: alternativa de tipo, dado inferido a confirmar (número da issue, tipo), alerta de conflito, duplicidade ou tamanho. Se nada se aplica, não escreva nada além do bloco.

## Exemplos

| Contexto | Branch |
|----------|--------|
| #1605 — adicionar paginação na consulta de fornecedores | `feature/1605-paginacao-fornecedores` |
| #1612 — login dá timeout após 30 s | `feature/fix/1612-timeout-login` |
| #1620 — erro 500 em produção na emissão de nota | `feature/hotfix/1620-erro-emissao-nota` |
| #1234 — consulta de empenho estoura o tempo limite | `feature/fix/1234-timeout-consulta-empenho` |
| #1234 — extrair acesso a dados para repositório | `feature/refactor/1234-extrai-repositorio` |
| #1631 — extrair validação de CPF para serviço próprio | `feature/refactor/1631-servico-validacao-cpf` |
| #1640 — atualizar Spring Boot para 3.3 | `feature/chore/1640-spring-boot-3-3` |
| #1645 — documentar API de fornecedores | `feature/docs/1645-api-fornecedores` |

## Princípios

- **Não inventar fatos**: número de issue ausente vira `<issue>` e é confirmado com o usuário.
- **Curto e objetivo**: o nome identifica o trabalho de relance; detalhes ficam na issue e no merge request.
- **Somente leitura**: nada é criado sem pedido explícito do usuário.

## Lista de verificação final

- [ ] Começa com `feature/`; funcionalidade nova sem tipo; demais com um tipo permitido.
- [ ] Número da issue presente (ou marcador `<issue>` sinalizado ao usuário).
- [ ] Descrição com 2 a 5 palavras, minúsculas, sem acentos, só `a-z`, `0-9` e `-`, sem repetir o tipo.
- [ ] Nome completo com no máximo 63 caracteres.
- [ ] Sem conflito com branch `feature/<tipo>` existente; duplicidade de issue informada.
