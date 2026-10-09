---
name: merge
description: Analisa o contexto disponível (commits e diff da branch em relação à branch de destino, conversa, texto do usuário, issue relacionada) e sugere título e descrição de merge request (ou pull request), com título no padrão Conventional Commits e descrição seguindo boas práticas de revisão de código. Use quando o usuário pedir para escrever, sugerir, gerar ou revisar o título ou a descrição de um merge request/pull request.
user-invocable: true
disable-model-invocation: false
---

# Merge request

Sugere título e descrição de merge request (MR) objetivos, prontos para colar. A descrição explica **por que** a mudança existe e **o que** o revisor precisa saber para avaliar, testar e implantar com segurança. Não repete o que o diff já mostra.

A skill **apenas sugere**: nunca cria, atualiza ou faz merge de MR (`glab`, `gh`, API) nem altera o repositório, a menos que o usuário peça explicitamente.

Qualquer texto após `merge` é contexto do usuário (ex.: `merge destino develop, issue 1605`) e tem prioridade sobre o que for inferido.

## Entrada

Qualquer combinação de:

- Texto do usuário descrevendo a mudança, a motivação ou a issue.
- Contexto da conversa atual (o que foi feito na sessão, decisões, testes executados).
- Descrição da issue relacionada (objetivo e critérios de aceite), se colada ou referenciada.
- Repositório Git no diretório atual (somente leitura):
  - Branch atual: `git branch --show-current`. Extrair possível número de issue do nome (ex.: `feature/1605-paginacao` → `#1605`).
  - Branch de destino: a informada pelo usuário; senão, a padrão do remoto (`git symbolic-ref refs/remotes/origin/HEAD`); senão, `main` ou `master`, o que existir. Informar qual foi usada.
  - Commits da branch: `git --no-pager log --pretty=format:"%s%n%b" <destino>..HEAD`.
  - Alterações: `git --no-pager diff --stat <destino>...HEAD` e, conforme necessário, trechos de `git --no-pager diff <destino>...HEAD`.
  - Convenções do repositório: títulos recentes (`git --no-pager log -n 20 --pretty=format:%s <destino>`) e template de MR, se existir (`.gitlab/merge_request_templates/`, `.github/pull_request_template.md`, `docs/`). **Se houver template no repositório, ele prevalece** sobre o formato desta skill; preencha-o aplicando as mesmas regras de conteúdo.

Para diffs grandes, leia primeiro o `--stat` e os commits, e depois apenas os trechos necessários para entender a intenção, os riscos e o modo de testar.

## Processo

1. **Coletar contexto** conforme a seção Entrada. Se não houver repositório nem descrição suficiente, peça ao usuário um resumo da mudança.
2. **Verificar coesão.** Se a branch mistura mudanças independentes (ex.: funcionalidade + refatoração não relacionada + atualização de dependências), avise e sugira dividir em MRs separados. Mesmo assim, entregue a sugestão para o conjunto atual.
3. **Definir o título** (ver Título).
4. **Redigir a descrição** (ver Descrição), incluindo somente as seções que têm conteúdo real.
5. **Revisar** com a lista de verificação final.

## Título

Segue o padrão Conventional Commits, pois costuma virar a mensagem do commit no *squash merge*:

```
<tipo>[(escopo)][!]: <descrição>
```

- Tipos: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`. O tipo reflete a **intenção principal** do MR como um todo, não do último commit.
- Escopo opcional, curto e minúsculo, coerente com o histórico do repositório; omitir se a mudança for transversal.
- `!` antes dos dois-pontos quando houver *breaking change*.
- Até **72 caracteres**, verbo no imperativo/presente (`adiciona`, `corrige`, `remove`), minúscula inicial, sem ponto final, sem termos vagos (`ajustes`, `melhorias`, `wip`).
- Não incluir número de issue no título; a referência vai na descrição.
- Se o repositório usa outro padrão de título de forma consistente, siga o histórico.

## Descrição

Ordem fixa das seções; seções opcionais sem conteúdo são omitidas sem alterar a ordem das demais.

### 1. Abertura (obrigatória, sem cabeçalho)

- Começa direto no texto, **sem cabeçalho** como "Contexto" ou "Resumo".
- Um parágrafo curto (1 a 3 frases) com o **problema ou a motivação** e o resultado esperado. Quando possível, cite números concretos (tempo, volume, erro).
- Na linha seguinte, a referência à issue: `refs #1605`. Com mais de uma: `refs #1605, #1610`.
  - **Não usar** `Closes`, `Fixes` ou `Resolves`. O padrão é sempre `refs #n` (minúsculo, sem dois-pontos), o mesmo dos commits.
  - Não inventar números de issue. Se não houver issue no contexto nem na branch, omitir a linha; se o usuário pedir a referência, usar `refs #(preencher: issue)`.

### 2. `## O que mudou` (obrigatória)

- Tópicos com `-`, um por mudança relevante, descrevendo **comportamento e decisões**, não arquivos.
- Agrupe por intenção, não por commit. Não liste commits nem arquivos alterados.
- Inclua decisões técnicas não óbvias e o motivo (ex.: "paginação por *offset*, pois o volume não justifica *cursor*").

### 3. `## Como testar` (obrigatória quando houver comportamento verificável)

- Passos numerados e reproduzíveis pelo revisor: preparação (migração, variáveis, dados), ação e **resultado esperado**.
- Pode incluir comandos (`npm test`, chamadas HTTP) em código.
- Omitir apenas em mudanças sem efeito verificável (ex.: só documentação); nesse caso, nada no lugar.

### 4. `## Impacto e riscos` (opcional)

Incluir somente se houver:

- **Breaking change**: o que quebra, quem é afetado e como migrar.
- Migração de banco, nova variável de ambiente ou configuração, mudança de permissão.
- Cuidados de implantação (ordem de deploy, janela, *feature flag*, rollback).
- Dependências de outros MRs ou sistemas.

### 5. `## Evidências` (opcional)

- Prints, GIFs, tabelas antes/depois ou medições, apenas quando o usuário fornecer ou o contexto contiver os dados. Para imagens não disponíveis, usar `(preencher: print da tela X)` somente se o usuário indicar que haverá evidência visual.

### O que não incluir

- Checklist.
- Lista de arquivos ou commits.
- Cabeçalho de abertura ("Contexto", "Resumo", "Descrição").
- Seções vazias ou com "N/A".
- HTML.

## Exemplo

**Título**

```text
feat(fornecedores): adiciona paginação na consulta de fornecedores
```

**Descrição**

````markdown
A consulta de fornecedores carregava todos os registros de uma vez. Em bases com mais de 50 mil fornecedores, a resposta passava de 30 s e causava *timeout* no *gateway*.

refs #1605

## O que mudou

- `GET /api/fornecedores` passa a aceitar `page` e `size` (padrão 50, máximo 500).
- A resposta inclui `total`, `page` e `size` para a navegação no front-end.
- A tela de listagem passa a usar o componente de paginação existente.
- Índice criado em `fornecedor.razao_social` para a ordenação padrão.

## Como testar

1. Rode a migração: `npm run db:migrate`.
2. Acesse **Cadastros > Fornecedores**.
3. Confirme que a lista exibe 50 itens e que a navegação entre as páginas funciona.
4. Chame `GET /api/fornecedores?page=2&size=10` e confirme a resposta com 10 itens e o `total` correto.

## Impacto e riscos

- **Breaking change:** consumidores da API que esperavam um *array* agora recebem um objeto `{ items, total, page, size }`. O *Portal de Compras* precisa de ajuste (#1610).
- A migração cria um índice; em produção, execute fora do horário de pico.

## Evidências

| Cenário | Antes | Depois |
|---------|-------|--------|
| 50 mil registros | 32 s | 180 ms |
````

Neste exemplo, por haver *breaking change*, o título correto seria `feat(fornecedores)!: adiciona paginação na consulta de fornecedores`.

## Idioma

- Siga o idioma predominante nos títulos e MRs recentes do repositório.
- Sem histórico ou histórico misto: use **português**.
- Tipos, escopo e o termo *breaking change* do título permanecem conforme a especificação Conventional Commits.

## Formato de entrega

1. Uma linha `**Título**` seguida de um bloco de código `text` com o título.
2. Uma linha `**Descrição**` seguida de um bloco de código delimitado por **quatro crases** com a linguagem `markdown`, pronto para colar.
3. Após os blocos, em até 3 bullets: a branch de destino usada (se inferida) e o que o usuário deve confirmar (escopo, issue, *breaking change*, passos de teste inferidos). Se nada foi inferido, não escreva nada além dos blocos.

- Se houver ambiguidade relevante no tipo (ex.: `feat` x `fix`), entregue a melhor opção e mencione a alternativa em um dos bullets.
- Se o usuário pedir arquivo, grave em UTF-8 com o título na primeira linha, uma linha em branco e a descrição, sem os blocos delimitadores, e responda apenas com o caminho.

## Regras de formatação

- Destaques: código para arquivos, caminhos, comandos, endpoints, funções, variáveis, branches, versões e pacotes; itálico para termos estrangeiros não técnicos e nomes próprios por extenso (sistemas, equipes, pessoas); negrito apenas para rótulos dentro de tópicos (ex.: `**Breaking change:**`) e para caminhos de menu da interface.
- Referências a issues e MRs (`#1605`, `!87`, `repo!87`) em texto puro, nunca em código, para não quebrar o link automático.
- Linguagem objetiva e impessoal, frases curtas.

## Princípios

- **Não inventar fatos**: motivações, números, métricas, issues, passos de teste e impactos ausentes no contexto não aparecem. Dado necessário e ausente vira `(preencher: ...)`; dado inferido recebe `(confirmar)`.
- **O porquê antes do quê**: o revisor entende o problema antes de ler o diff.
- **Escrito para o revisor**: tudo o que ajuda a revisar, testar e implantar; nada que o diff já mostre.
- **Um MR, uma intenção**: mudanças independentes são apontadas com sugestão de divisão.
- **Somente leitura**: nada é criado ou alterado sem pedido explícito do usuário.

## Lista de verificação final

- [ ] Título no padrão Conventional Commits, com até 72 caracteres, imperativo/presente, minúscula inicial, sem ponto final, sem número de issue; `!` se houver *breaking change*.
- [ ] Descrição começa direto no texto, sem cabeçalho, explicando o problema ou a motivação.
- [ ] Referência à issue com `refs #n` (nunca `Closes`/`Fixes`/`Resolves`), sem números inventados.
- [ ] "O que mudou" descreve comportamento e decisões, sem listar arquivos ou commits.
- [ ] "Como testar" tem passos reproduzíveis com resultado esperado (ou foi omitido por não se aplicar).
- [ ] Seções opcionais só aparecem com conteúdo real; sem checklist; ordem fixa respeitada.
- [ ] Template do repositório, se existir, foi respeitado.
- [ ] Mudanças não relacionadas foram apontadas com sugestão de divisão.
- [ ] Nenhum dado inventado; inferências marcadas e listadas após os blocos.
