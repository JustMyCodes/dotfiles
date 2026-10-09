---
name: commit
description: Analisa o contexto disponível (alterações staged/unstaged do Git, diff, conversa, texto do usuário) e sugere a mensagem de commit conforme a especificação Conventional Commits 1.0.0. Use quando o usuário pedir para escrever, sugerir, gerar ou revisar uma mensagem de commit. Com `-m` ou pedido de mensagem curta, entrega só o comando `git commit -m`. Quando o usuário pede para salvar a mensagem em algum destino (padrão `.git/COMMIT_SUGGESTION`), grava o arquivo para abrir no editor no próximo `git commit`.
user-invocable: true
disable-model-invocation: false
---

# Mensagem de commit (Conventional Commits)

Sugere uma mensagem de commit factual, concisa e aderente à especificação [Conventional Commits 1.0.0](https://www.conventionalcommits.org/pt-br/v1.0.0/). A skill **apenas sugere**: nunca executa `git add`, `git commit` ou qualquer comando que altere o repositório, a menos que o usuário peça explicitamente. A única escrita permitida é o arquivo de sugestão no modo Editor.

## Modos

| Modo | Quando | Saída |
|------|--------|-------|
| Padrão | `commit`, sem outra indicação | Mensagem completa: cabeçalho + corpo (quando agrega valor) + rodapé (quando houver), em bloco `text`. |
| Mensagem | `commit -m` ou pedido de mensagem curta, simples ou pequena | Somente o cabeçalho, uma linha, dentro de `git commit -m "..."` em bloco `shell`. Sem corpo nem rodapé. Se houver *breaking change*, usar `!` no cabeçalho. |
| Editor | Pedido para salvar a mensagem em algum destino (ex.: `commit Salve a mensagem em .git/COMMIT_SUGGESTION.`) | Mensagem completa (mesmas regras do modo padrão) gravada no destino, sem exibi-la na tela. Destino padrão: `.git/COMMIT_SUGGESTION`, que o hook `prepare-commit-msg` carrega no editor no próximo `git commit` (ver Modo Editor). |

Qualquer texto adicional após `commit` ou `commit -m` é contexto do usuário (ex.: `commit -m corrige timeout do login`) e tem prioridade sobre o que for inferido do diff.
## Entrada

Qualquer combinação de:

- Texto do usuário descrevendo a mudança.
- Contexto da conversa atual (o que foi alterado na sessão e por quê).
- Repositório Git no diretório atual (somente leitura):
  - `git --no-pager diff --staged --stat` e `git --no-pager diff --staged`
  - Se não houver nada staged: `git --no-pager diff --stat` e `git --no-pager diff` (avise que a sugestão considera alterações não staged).
  - `git --no-pager log -n 15 --pretty=format:%s` para identificar idioma, escopos e convenções já usados no repositório.
  - `git branch --show-current` para extrair possível número de issue (ex.: `feature/1605-login` → `#1605`).

Para diffs grandes, leia primeiro o `--stat` e depois apenas os trechos necessários para entender a intenção.

## Processo

1. **Coletar contexto** conforme a seção Entrada. Se não houver repositório nem descrição suficiente, peça ao usuário um resumo da mudança.
2. **Verificar coesão.** Se as alterações misturam mudanças independentes (ex.: correção de bug + refatoração não relacionada + atualização de dependência), avise e sugira dividir em commits separados, com uma mensagem para cada grupo de arquivos.
3. **Classificar o tipo** pela intenção principal da mudança:

   | Tipo | Quando usar |
   |------|-------------|
   | `feat` | Nova funcionalidade para o usuário/consumidor (gera MINOR no SemVer). |
   | `fix` | Correção de bug (gera PATCH no SemVer). |
   | `docs` | Somente documentação. |
   | `style` | Formatação, espaços, ponto e vírgula; sem mudança de comportamento. |
   | `refactor` | Reestruturação de código sem corrigir bug nem adicionar funcionalidade. |
   | `perf` | Melhoria de desempenho. |
   | `test` | Adição ou correção de testes. |
   | `build` | Sistema de build ou dependências (`package.json`, `pom.xml`, `.csproj`, etc.). |
   | `ci` | Configuração de integração contínua (pipelines, workflows). |
   | `chore` | Manutenção que não altera código de produção nem testes. |
   | `revert` | Reversão de commit anterior. |

   Se o repositório já usa outros tipos de forma consistente no histórico, siga o histórico.
4. **Definir o escopo** (opcional): módulo, pacote ou área afetada, em minúsculas e curto (ex.: `auth`, `api`, `login`). Prefira escopos já usados no histórico. Omita se a mudança for transversal ou se não houver escopo claro.
5. **Detectar *breaking change***: remoção/renomeação de API pública, mudança de contrato, de esquema de banco ou de configuração obrigatória. Se houver, usar `!` antes dos dois-pontos e, nos modos padrão e Editor, o rodapé `BREAKING CHANGE: ...`.
6. **Redigir** conforme o formato abaixo e **revisar** com a lista de verificação.

## Formato

```
<tipo>[(escopo)][!]: <descrição>

[corpo]

[rodapé(s)]
```

### Cabeçalho (descrição)

- Até **72 caracteres** no total (ideal: até 50).
- Verbo no **imperativo** ou presente, descrevendo o que o commit faz: em português, `adiciona`, `corrige`, `remove`, `atualiza`; em inglês, `add`, `fix`, `remove`, `update`.
- Primeira letra minúscula, sem ponto final.
- Descreve **o quê**, não o como. Evite termos vagos (`ajustes`, `melhorias`, `alterações`, `wip`).
- Não repetir literalmente o tipo na descrição (`fix: fix ...`).

### Corpo (modos padrão e Editor)

- Separado do cabeçalho por uma linha em branco; linhas com até 72 caracteres.
- Explica **o porquê** e o contexto relevante (motivo, comportamento anterior x novo, decisões). Não liste arquivos alterados nem repita o diff.
- Omitir quando o cabeçalho já for autoexplicativo.
- Use tópicos com `-` quando houver mais de um ponto.

### Rodapé (modos padrão e Editor)

- Formato `Token: valor` ou `Token #valor`, um por linha.
- `BREAKING CHANGE: <descrição do impacto e da migração>` quando aplicável.
- Referência a issue no formato `refs #1605` (minúsculo, sem dois-pontos), o mesmo usado pelo hook `prepare-commit-msg`. Não usar `Closes`, `Fixes` ou `Resolves`.
- O hook acrescenta automaticamente `refs #<n>` com o primeiro número do nome da branch, sem duplicar se já estiver presente. Por isso:
  - **Omita** a referência quando a issue for a mesma indicada pela branch.
  - **Inclua** `refs #<n>` apenas quando a issue for diferente da branch, houver issues adicionais ou a branch não tiver número.
- Não inventar números de issue. Se o usuário pedir referência e ela não estiver no contexto nem na branch, usar `refs #(preencher: issue)`.

## Idioma

- Siga o idioma predominante nos commits recentes do repositório.
- Sem histórico ou histórico misto: use **português**.
- Tipos, escopo e o token `BREAKING CHANGE` permanecem sempre conforme a especificação (`feat`, `fix`...).

## Formato de entrega

Texto direto, sem explicações: a resposta é só o bloco (ou a linha do modo Editor).

- **Modo padrão:** entregue a mensagem em um bloco de código `text`, pronta para colar no editor do `git commit`:

  ```text
  fix(api): corrige timeout na consulta de fornecedores

  A consulta sem paginação excedia 30 s em bases grandes. Adicionada
  paginação de 500 registros.
  ```

- **Modo Mensagem:** entregue um bloco de código `shell` com o comando pronto:

  ```shell
  git commit -m "feat(auth): adiciona login com certificado digital"
  ```

  Escape aspas duplas internas.
- **Modo Editor:** não exiba a mensagem. Grave-a e responda em uma linha (ver Modo Editor).
- Se a mudança precisar ser dividida, entregue um bloco por commit, cada um precedido de uma linha com os arquivos do grupo (no modo Mensagem, o `git add` correspondente dentro do próprio bloco).
- Dado ausente que o usuário pediu (ex.: número de issue) vai como marcador na própria mensagem, `refs #(preencher: issue)`, sem comentário fora do bloco.

## Modo Editor

Fluxo: a skill grava a sugestão → o usuário (ou o comando `ia commit`) roda `git commit` no terminal → o hook `prepare-commit-msg` substitui o template pela sugestão, acrescenta `refs #<n>` da branch (sem duplicar) e apaga o arquivo → o editor abre com a mensagem pronta para revisão.

1. Exige repositório Git. Sem repositório, informe e entregue no modo padrão.
2. Se não houver nada staged, não grave o arquivo: avise que é preciso rodar `git add` antes e entregue no modo padrão.
3. Se as alterações precisarem ser divididas em mais de um commit, não grave o arquivo: entregue no modo padrão com a sugestão de divisão.
4. Destino: o caminho indicado pelo usuário. Se for `.git/COMMIT_SUGGESTION` ou não for informado, obtenha o caminho com `git rev-parse --git-path COMMIT_SUGGESTION` (funciona também em *worktrees*). Somente esse destino é carregado pelo hook.
5. Grave a mensagem em **UTF-8 sem BOM**, com quebras de linha **LF** e uma quebra de linha final, sem blocos de código, sem comentários `#` e sem marcadores de template. Sobrescreva sugestão anterior, se existir, avisando o usuário.
6. Responda apenas com uma linha:

   ```text
   Sugestão salva em .git/COMMIT_SUGGESTION. Rode `git commit` para revisar no editor.
   ```

- Nunca execute `git commit` neste modo: o shell do agente não é interativo e o editor travaria a execução.
- Sem o hook ajustado, o usuário pode usar `git commit -e -F .git/COMMIT_SUGGESTION` (nesse caso, o arquivo não é apagado automaticamente).
## Princípios

- **Não inventar fatos**: descrição baseada no diff e no contexto; números de issue, nomes e motivos ausentes não aparecem.
- **Intenção, não mecânica**: "corrige cálculo de juros em parcelas atrasadas", nunca "altera linha 42 de `juros.ts`".
- **Um commit, uma intenção**: se não couber em um cabeçalho honesto, provavelmente são dois commits.
- **Somente leitura**: nada é commitado sem pedido explícito do usuário; a única escrita é o arquivo de sugestão no modo Editor.

## Lista de verificação final

- [ ] Tipo corresponde à intenção principal; escopo curto, minúsculo e coerente com o histórico (ou omitido).
- [ ] Cabeçalho com até 72 caracteres, imperativo/presente, minúscula inicial, sem ponto final, sem termos vagos.
- [ ] *Breaking change* sinalizado com `!` (e rodapé `BREAKING CHANGE:` nos modos padrão e Editor).
- [ ] Modo Mensagem: apenas uma linha, dentro de `git commit -m "..."` em bloco `shell`, aspas escapadas.
- [ ] Modo padrão: só o bloco `text`, sem explicações; corpo explica o porquê (ou foi omitido); linha em branco entre cabeçalho, corpo e rodapé.
- [ ] Referência no formato `refs #n`, omitida quando igual à issue da branch (o hook acrescenta).
- [ ] Modo Editor: arquivo gravado no destino pedido (padrão `.git/COMMIT_SUGGESTION`) em UTF-8 sem BOM e LF, somente com a mensagem; resposta em uma linha; `git commit` não executado.
- [ ] Idioma segue o histórico do repositório (ou português).
- [ ] Mudanças não relacionadas foram apontadas com sugestão de divisão.
- [ ] Nenhum dado inventado; dado ausente como `(preencher: ...)` na própria mensagem.
