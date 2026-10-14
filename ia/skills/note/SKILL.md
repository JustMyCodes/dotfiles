---
name: note
description: Analisa o contexto disponível (texto do usuário, conversa, commits, diffs, PRs, reuniões) e gera notas para registrar em uma issue ou item de trabalho, em três tipos — progresso, ocorrência (atividade contínua/recorrente) e entrega (fechamento). Use quando o usuário pedir para escrever, registrar ou gerar uma nota, comentário, atualização, andamento ou fechamento de uma issue/item.
user-invocable: true
disable-model-invocation: false
---

# Notas de issue

Gera notas curtas, factuais e prontas para colar como comentário em uma issue ou item de trabalho de qualquer ferramenta. A nota é um registro datado: o carimbo de data/hora da ferramenta é parte da evidência, por isso a nota descreve **o que aconteceu**, não o esforço gasto.

Os modelos exatos estão em [template.md](template.md). Em caso de divergência quanto à formatação, o template prevalece.

## Entrada

Qualquer combinação de:

- Texto bruto do usuário (anotações, resumo do dia, ata, mensagem).
- Contexto da conversa atual (trabalho feito na sessão, decisões tomadas, arquivos alterados).
- Repositório Git no diretório atual, quando existir e for relevante: `git --no-pager log`, `git --no-pager diff --stat`, branch atual, PR aberto.
- Links informados (commit, PR, wiki, documento, certificado, release).
- Descrição da issue (objetivo e critérios de aceite), se colada ou referenciada.

## Processo

1. **Coletar contexto.** Leia a entrada do usuário e a conversa. Se o usuário pedir uma nota sobre "o que fiz" sem detalhar e houver repositório Git no diretório atual, consulte commits e diff recentes da branch (somente leitura). Não consulte fontes externas sem necessidade.
2. **Classificar o tipo** da nota:

   | Tipo | Sinais no contexto | Modelo |
   |------|--------------------|--------|
   | PROGRESSO | avanço parcial, "hoje fiz", commit/PR em andamento, bloqueio, próximo passo | Nota de Progresso |
   | OCORRÊNCIA | reunião, cerimônia, treinamento, evento recorrente vinculado a item contínuo | Nota de Ocorrência |
   | ENTREGA | "terminei", "concluído", "fechar a issue", PR mergeado, certificado obtido, critérios atendidos | Nota de Entrega |

   Se o contexto indicar mais de um tipo para a mesma issue, gere uma nota por tipo, na ordem cronológica. Se for ambíguo entre PROGRESSO e ENTREGA, pergunte ao usuário com a ferramenta de perguntas — não adivinhe.
3. **Extrair fatos**: resultado obtido, próximo passo, bloqueios (e de quem dependem), referências (issues, merge request ou commit da entrega), desdobramentos, decisões técnicas (e quem decidiu).
4. **Redigir** conforme o modelo do tipo, aplicando as regras abaixo.
5. **Revisar** com a lista de verificação final.

## Regras por tipo

### Nota de Progresso

- Registrar **somente quando houver avanço real**. Se o contexto não mostrar avanço, avise o usuário em vez de produzir uma nota vazia.
- **Feitos** (primeira linha, **sem rótulo**): parágrafo único com o que avançou, numerado conforme Primeira linha. Resultado e não esforço ("Validação de CPF implementada", nunca "Trabalhei na validação"). Quando pertinente, incluir o avanço nos critérios de aceite (ex.: "CA01–CA03 atendidos, CA04 pendente"), sem marcar como atendido o que o contexto não confirma.
- **Bloqueios:** só se existir; lista de tarefas conforme Campos com rótulo. Dizer o que impede e de quem/que depende.
  - **Bloqueio externo** (outra equipe, pessoa, fornecedor, acesso, aprovação): incluir quem, desde quando (`desde dd/mm/aaaa`) e o impacto (ex.: "impacta o prazo"). Se a data de início não estiver no contexto, usar `(preencher: desde quando)`.
  - **Bloqueio pessoal** (dificuldade técnica, curva de aprendizado, dúvida em estudo): descrever sem data e sem impacto.
  - Omitir o campo se não houver bloqueio.
- **Próximo:** lista de tarefas conforme Campos com rótulo, com passos concretos e acionáveis.
- **Decisões** não têm rótulo próprio: quando houver, incorporar ao campo pertinente — nos feitos se a decisão é parte do avanço, em Próximo se define o passo seguinte — indicando quem decidiu (ex.: "- [ ] Implementar fila assíncrona, definida com *Fulano* na revisão de arquitetura.").
- Nunca reescrever nota antiga: se algo mudou, a nova nota registra a mudança.

### Nota de Ocorrência

- Para itens contínuos (reuniões recorrentes, cerimônias, capacitações periódicas). Cada ocorrência é uma nota, não um item novo.
- Uma ou duas linhas, sem rótulos:
  1. Evento/tema, terminando com `;`. Data/horário somente em registro retroativo (ver Datas).
  2. Desdobramento iniciado por `> `: o que ficou para o usuário fazer ou acompanhar; se houve decisão, quem decidiu; se gerou trabalho novo, citar a issue criada. Terminar com `;`.
- Se não houve desdobramento, omitir a segunda linha; a nota fica só com o evento.

### Nota de Entrega

- É a última nota do item.
- **Entregas** (primeira linha, **sem rótulo**): parágrafo único com a confirmação objetiva do que foi entregue, numerado conforme Primeira linha. Quando pertinente, citar os critérios de aceite atendidos; não declarar atendido o que o contexto não confirma. Se a entrega for um merge request ou commit, mencioná-lo aqui com o repositório (ex.: "merge request cadastro-fornecedores!87 integrado à `main`").
- **Desdobramento:** somente se houver algo que pode ser tratado separadamente, em outro momento, sem impedir o fechamento do item:
  - **Pendência:** o que ficou fora do entregue (ajuste, melhoria, critério não atendido e renegociado).
  - **Descoberta:** algo identificado durante o trabalho e que merece atenção própria (bug em outra parte do sistema, dívida técnica, oportunidade de melhoria, tema para estudo).

  Cada item é descrito em poucas palavras e vira uma issue nova, citada pelo número; se ainda não foi criada, usar `(preencher: issue)`. Lista de tarefas conforme Campos com rótulo. A issue atual fecha sem pendência aberta. Omitir se não houver.

## Formato de entrega

- **A nota é a única saída**: texto direto, sem título, introdução, explicações ou comentários antes ou depois.
- Entregue cada nota dentro de um bloco de código delimitado por **quatro crases** com a linguagem `markdown`, pronta para colar. Com mais de uma nota, um bloco por nota, em sequência, sem nada entre eles.
- Dado ausente ou inferido fica marcado na própria nota, com `(preencher: ...)` ou `(confirmar)`, nunca em comentário fora do bloco.
- Exceções, quando não há nota a entregar: falta de avanço real (avise em uma linha) e ambiguidade de tipo (pergunte com a ferramenta de perguntas).
- Se o usuário pedir arquivo, grave em UTF-8 sem o bloco delimitador e responda apenas com o caminho.

## Rastreabilidade

### Datas

- Por padrão, **não incluir data**: o lançamento já é datado pela ferramenta.
- Incluir data somente em **registro retroativo** (o fato ocorreu em dia diferente do lançamento) e em **bloqueio externo** (`desde`).
- Quando houver data, usar formato absoluto `dd/mm/aaaa` (ou `dd/mm` se o ano for evidente); nunca "ontem", "hoje", "semana passada".

### Referências de código

- Commits são sincronizados com a issue e podem ser conferidos na própria ferramenta; não listá-los na nota.
- Merge request ou commit só é citado quando for a própria entrega (nas entregas) ou essencial para entender a nota.
- Quando citado, usar referência permanente com o repositório: `repositorio!87` (merge request), `repositorio#87` (pull request), `repositorio@a1b2c3d` (commit). Nunca link de branch. Se o repositório não estiver no contexto e não puder ser obtido do Git local (`git remote get-url origin`), usar `(preencher: repositório)`.

## Regras de formatação

- **Primeira linha previsível**: Progresso começa direto pelos feitos e Entrega direto pelas entregas, ambos sem rótulo; Ocorrência pelo nome do evento.
- **Ordem fixa dos campos** — Progresso: feitos (sem rótulo), Bloqueios, Próximo. Entrega: entregas (sem rótulo), Desdobramento. Campos opcionais ausentes são omitidos sem alterar a ordem dos demais.
- Campos separados por **uma linha em branco**. Nunca use `\` nem dois espaços no fim da linha.

### Primeira linha (feitos e entregas)

Parágrafo único, sem rótulo. Não se aplica à Nota de Ocorrência.

- **Mais de um item:** cada item começa com o número em negrito entre colchetes, `**[1]**`, `**[2]**`... Itens separados por `; ` e o último terminado com `.`.
- **Um item só:** sem numeração; o texto termina com `.`.

### Campos com rótulo (Bloqueios, Próximo, Desdobramento)

- Rótulo em negrito com dois-pontos, sozinho na linha (`**Próximo:**`), seguido de uma linha em branco e de uma **lista de tarefas** (`- [ ] `), um item por linha, mesmo com um item só.
- Itens terminados com `;`, exceto o último, terminado com `.`.
- Sem numeração `**[n]**` nos itens da lista.

### Regras comuns

- O texto de cada item começa com **letra maiúscula**, inclusive logo após o número ou o `- [ ] `.

```markdown
**[1]** Capítulos 1 e 2 de *Linux Basics for Hackers* concluídos; **[2]** Síntese iniciada na wiki.

**Próximo:**

- [ ] Continuar a partir do capítulo 3;
- [ ] Publicar a síntese.
```
- Os colchetes `[...]` do template são placeholders: não deixe colchetes de template nem textos de exemplo na saída (colchetes que fazem parte de um título real são mantidos).
- Não use HTML.

### Destaques no texto

| Elemento | Formato | Exemplo |
|----------|---------|---------|
| Rótulo de campo | negrito | `**Próximo:**` |
| Número de item (primeira linha) | negrito, entre colchetes | `**[1]**` |
| Item de campo com rótulo | lista de tarefas | `- [ ] Publicar a síntese.` |
| Nome de arquivo, pasta ou caminho | código | `` `docs/validacoes.md` `` |
| Comando, função, classe, variável, trecho de código | código | `` `git rebase` ``, `` `validarCpf()` `` |
| Branch, tag, versão | código | `` `main` ``, `` `v1.4.0` `` |
| Pacote, biblioteca, ferramenta CLI | código | `` `vue-cli` `` |
| Host, servidor, URL sem link | código | `` `git.sof` `` |
| SHA de commit | código, curto (7 caracteres), com repositório | `` `cadastro-fornecedores@a1b2c3d` `` |
| Referência a issue | texto puro, sem formatação | `#1605` |
| Título de issue citado junto da referência | itálico, após travessão | `#1605 — *[4T/2026] Ações Institucionais e Capacitação Continuada*` |
| Título de livro, curso, vídeo, documento, evento | itálico, sem aspas | `*Linux Basics for Hackers*` |
| Termo estrangeiro não técnico | itálico | `*deadline*` |
| Nome de pessoa | itálico | `*Maria Souza*` |
| Outros nomes próprios por extenso (equipe, área, órgão, sistema, projeto, evento) | itálico | `*Infraestrutura*`, `*Secretaria de Orçamento Federal*` |
| Sigla | texto puro | SIOP, PGD |

- **Referências que a ferramenta transforma em link** (ex.: `#1605`, `repo!87`, `repo#87`) nunca vão em código nem em itálico, para não quebrar o link automático. Se a ferramenta também gera link para commit escrito sem crases (ex.: `repo@a1b2c3d`), preferir a forma sem crases.
- Citar o título da issue apenas na primeira menção e quando ajudar a entender a nota; nas demais, só `#n`.
- Usar itálico em vez de aspas para títulos. Aspas apenas para citação literal (mensagem de erro, fala).
- Não combinar negrito e itálico (`***...***`); negrito é exclusivo dos rótulos e dos números de item.
- Siglas de sistemas, produtos e órgãos (ex.: SIOP, PGD) em texto puro; o nome por extenso vai em itálico.
- Nomes próprios que já estão em código (arquivo, pacote, host) seguem a regra de código, não o itálico.

## Princípios

- **Não inventar fatos**: datas, horários, números de issue, links, nomes e resultados ausentes no contexto não aparecem. Dado necessário e ausente vira marcador `(preencher: ...)`; dado inferido recebe `(confirmar)`.
- **Resultado, não esforço**: evitar "trabalhei", "estive vendo", "dediquei X horas".
- **Brevidade**: itens curtos; a nota inteira deve ser lida em poucos segundos.
- **Linguagem objetiva e impessoal**, em português, verbos no particípio ("implementada", "corrigido", "definido").
- **Rastreabilidade**: entregas de código citam o merge request ou commit com o repositório; toda decisão registra quem decidiu.

## Lista de verificação final

- [ ] O tipo da nota corresponde ao contexto (ou o usuário confirmou).
- [ ] Progresso: há avanço real; feitos na primeira linha, sem rótulo; ordem feitos, Bloqueios, Próximo; campos opcionais omitidos se vazios.
- [ ] Primeira linha: `**[n]**` só com mais de um item; itens separados por `; `; termina com `.`.
- [ ] Campos com rótulo: rótulo sozinho na linha, linha em branco, lista `- [ ] `; itens com `;` e o último com `.`; texto começa com maiúscula.
- [ ] Bloqueio externo tem quem, `desde` e impacto; bloqueio pessoal não tem data.
- [ ] Ocorrência: sem rótulos; evento na primeira linha; desdobramento iniciado por `> ` apenas se existir.
- [ ] Entrega: entregas na primeira linha, sem rótulo; não afirma nada que o contexto não confirme; cita o merge request ou commit quando for a entrega; pendências e descobertas a tratar separadamente viraram Desdobramento com issue.
- [ ] Datas só em registro retroativo ou bloqueio externo, sempre em formato absoluto.
- [ ] Commits não são listados; referências de código, quando houver, incluem o repositório e são permanentes.
- [ ] Decisões incorporadas aos campos existentes, indicando quem decidiu.
- [ ] Nomes de pessoas e demais nomes próprios por extenso em itálico; siglas em texto puro.
- [ ] Nenhum dado foi inventado; inferências marcadas com `(confirmar)` na própria nota.
- [ ] A saída é só o bloco (ou os blocos), sem texto antes ou depois.
- [ ] Destaques conforme a tabela: código para arquivos, comandos, SHAs, branches e ferramentas; itálico para títulos de issue, livro, curso e documento; `#n` sem formatação.
- [ ] Campos separados por linha em branco; nenhuma linha termina com `\`; sem placeholders `[...]`.
