---
name: requisitos
description: Transforma um texto bruto (anotações, e-mail, transcrição de reunião, chamado, conversa) na descrição estruturada de um item de trabalho (issue) para desenvolvimento, com contexto, requisitos funcionais, regras de negócio, requisitos não funcionais, critérios de aceite em Dado/Quando/Então, dependências, riscos e pendências. Use quando o usuário pedir para escrever, especificar, refinar ou gerar a descrição de uma issue, história, item de trabalho ou demanda a partir de um texto.
user-invocable: true
disable-model-invocation: false
---

# Especificar item de trabalho

Converte um texto bruto em uma especificação de item de trabalho enxuta, verificável e rastreável, adequada a times ágeis. O vocabulário segue a engenharia de requisitos (Pressman): requisito funcional, requisito não funcional, regra de negócio, critério de aceite (validação), dependência, pendência.

## Entrada

Texto bruto fornecido pelo usuário (colado ou anexado). Pode conter ruído, repetição, opiniões, soluções técnicas misturadas a necessidades e lacunas.

## Saída

Um título sugerido e um único documento Markdown seguindo **exatamente** a estrutura, a ordem de seções e a formatação de [template.md](template.md). Entregue em português. Em caso de divergência entre este arquivo e o template quanto à formatação, o template prevalece.

### Formato de entrega

- **Título sugerido:** antes do documento, escreva uma única linha `**Título sugerido:** [título]` — fora do bloco de código, pois o título vai no campo de título da issue, não na descrição. O título é curto (até ~80 caracteres), começa com verbo no infinitivo ou substantivo de ação e descreve o resultado (ex.: "Exportar atendimentos filtrados em CSV").
- **Padrão (copiar e colar):** após o título, entregue o documento inteiro dentro de um único bloco de código delimitado por **quatro crases** com a linguagem `markdown` (` ````markdown ` … ` ```` `). Não escreva nenhum outro texto antes ou depois — salvo, após o bloco, um aviso de no máximo duas linhas se houver pendências bloqueantes.
- **Arquivo:** se o usuário pedir arquivo (ou informar um caminho), grave o documento sem o bloco de código delimitador, em UTF-8, com a ferramenta de criação de arquivo. Nome padrão: `<pasta-atual>\<slug-do-titulo>.md` (minúsculas, sem acentos, palavras separadas por hífen). Responda apenas com o título sugerido, o caminho gerado e o eventual aviso de pendências bloqueantes.
- **Entrega parcial:** se o usuário pedir apenas parte do documento (ex.: uma seção ou alguns CAs), aplique o mesmo formato de entrega somente ao trecho pedido, sem título sugerido, mantendo o cabeçalho `###` da seção, sem o cabeçalho `##` da parte (exceto para o contexto, que não tem cabeçalho, e para Fora do Escopo, que mantém o rótulo `**Fora do Escopo:**`).

### Estrutura e agrupamento

O documento tem 4 partes, nesta ordem:

1. **Entendimento** (sem separador nem cabeçalho de parte): contexto, `**Objetivo:**`, `**Bloqueios:**` (condicional), Fora do Escopo e Glossário curto (condicional).
2. **Especificação**: linha `---` seguida do cabeçalho `## ESPECIFICAÇÃO`; contém Requisitos Funcionais, Regras de Negócio, Requisitos Não Funcionais.
3. **Validação**: linha `---` seguida do cabeçalho `## VALIDAÇÃO`; contém Critérios de Aceite.
4. **Pontos de Atenção**: linha `---` seguida do cabeçalho `## PONTOS DE ATENÇÃO`; contém Dependências e Riscos, Pendências e, se houver, o Anexo de Glossário. Reúne o que não é requisito nem critério de aceite, mas condiciona a execução: o que depende de terceiros, o que pode dar errado e o que ainda precisa de decisão. Omitir a parte inteira, inclusive o `---` e o cabeçalho, quando não houver nenhum desses itens.

Hierarquia de cabeçalhos:

- `##` apenas para as partes, sempre em letras maiúsculas: `## ESPECIFICAÇÃO`, `## VALIDAÇÃO` e `## PONTOS DE ATENÇÃO`.
- `###` para as seções (ex.: `### Requisitos Funcionais`, `### Glossário de Domínio`).
- `####` apenas para os grupos de Critérios de Aceite.

Use `---` apenas antes dos cabeçalhos das partes 2, 3 e 4.

### Regras de formatação Markdown

- Use `-` como marcador de lista em todo o documento.
- Linhas consecutivas que pertencem ao mesmo item (ex.: Dado que / Quando / Então; Critério de verificação; Impacto / Encaminhamento / Situação / Responsável) devem terminar com `\` para forçar a quebra de linha, exceto a última linha do item. Nunca use dois espaços no fim da linha para quebrar.
- Itens de uma única linha (RF, RN, Fora do Escopo) ficam em linhas consecutivas, sem linha em branco entre eles.
- Itens com várias linhas (RNF, CA, DR, PA) são separados por uma linha em branco, sempre — sem exceção dentro da mesma seção.
- Deixe uma linha em branco entre parágrafos e antes/depois de cabeçalhos, tabelas e `---`.
- Use apenas negrito (`**...**`) para destaques; não use negrito com itálico (`***...***`). Itálico só na referência de cobertura dos CAs.
- Os colchetes `[...]` do template são placeholders: substitua-os pelo conteúdo e não deixe colchetes, barras invertidas de escape (`\[`, `\]`) nem textos de exemplo na saída.
- Tabelas (apenas no Glossário) devem ter cabeçalho, linha separadora e o mesmo número de colunas em todas as linhas; escape `|` dentro de células como `\|`.
- Não use HTML.

## Processo

1. **Ler e classificar** cada informação do texto bruto em: contexto/evidência, comportamento esperado (RF), regra de domínio (RN), qualidade/restrição verificável (RNF), exclusão de escopo, dependência/risco, dúvida.
2. **Normalizar o vocabulário**: identificar termos do domínio e usar sempre o mesmo termo para o mesmo conceito. Avaliar se algum termo realmente precisa de definição (ver Glossário).
3. **Redigir as seções** na ordem do template, aplicando as regras abaixo.
4. **Garantir rastreabilidade**: todo RF, RN e RNF crítico deve ser coberto por ao menos um CA; todo CA deve indicar o que cobre.
5. **Revisar** com a lista de verificação final antes de entregar.

## Regras por seção

### Contexto, problema e objetivo (obrigatória)
- Não imprima nenhum cabeçalho para esta seção; o documento começa direto pelo texto do contexto.
- Explicar por que a demanda é necessária agora: problema atual, origem, evidências (incidente, chamado, métrica) e links presentes no texto.
- Indicar quem é afetado e a consequência atual.
- **O objetivo é sempre o último parágrafo do contexto**, iniciado por `**Objetivo:**`, declarando qual problema será resolvido, para quem e qual resultado observável se espera.
- Não inventar números ou evidências. Se não houver evidência, não a mencione — ou registre uma pendência se ela for necessária para priorizar/validar.

### Bloqueios (condicional)
- Linha única logo após o Objetivo: `**Bloqueios:** PAxx, PAyy — [resumo em uma frase]`.
- Incluir somente se houver pendências que impedem iniciar ou concluir a implementação. Listar apenas essas PAs, não todas. Omitir a linha se não houver bloqueio.

### Fora do Escopo (obrigatória)
- Não é uma seção com cabeçalho `###`: é um rótulo em negrito `**Fora do Escopo:**`, seguido de uma linha em branco e da lista, como no template.
- Fica logo após o Objetivo/Bloqueios, para delimitar a demanda antes dos requisitos.
- Listar o que explicitamente **não** será feito, extraído do texto ou de limites evidentes (ex.: "não altera entidades existentes").
- Incertezas não entram aqui; vão para Pendências.
- Se o texto não trouxer nenhuma exclusão, listar apenas limites que decorram diretamente do que foi dito; nunca inventar.

### Glossário de Domínio (condicional)
- Incluir **somente** quando houver termo, sigla ou conceito cuja interpretação divergente possa levar a uma implementação errada, ou que o leitor técnico provavelmente não conheça. Não incluir termos autoexplicativos, termos já definidos no próprio requisito ou apenas para "completar" o documento. Na dúvida, omitir.
- Até 5 termos: seção `### Glossário de Domínio` logo após Fora do Escopo.
- Mais de 5 termos: mover para o final do documento como `### Anexo — Glossário de Domínio`, após Pendências, dentro de Pontos de Atenção (se Pontos de Atenção não existir, criá-la só para o anexo).

### Requisitos Funcionais (obrigatória)
- Formato: `**RFxx — [nome curto]:** O sistema deve ...`.
- Um comportamento observável por requisito. Descrever **o quê**, não **como**.
- Detalhes de implementação só entram se forem restrição explícita da demanda (nesse caso, preferir RNF).

### Regras de Negócio (condicional)
- Formato: `**RNxx — [nome curto]:** ...`.
- Usar para regras de domínio que condicionam mais de um RF: elegibilidade, cálculo, derivação, combinação, vigência, prioridade, restrições de valores.
- Não duplicar o que já está claro em um RF. Omitir a seção se não houver regras adicionais.

### Requisitos Não Funcionais (condicional)
- Formato: `**RNFxx — [nome curto]:** ...` seguido, na linha seguinte, de `**Critério de verificação:**`.
- Abrange segurança (autorização, validação no servidor), proteção (atomicidade, integridade, preservação de dados), desempenho, acessibilidade, compatibilidade, auditoria, observabilidade, e restrições técnicas explícitas (ex.: uso obrigatório de transação).
- Proibido usar termos vagos ("rápido", "seguro", "intuitivo") sem medida. Se o texto pede algo vago sem limiar, registre uma pendência em vez de inventar o número.

### Critérios de Aceite (obrigatória)
- Formato exato:
  ```
  - **CAxx — [resultado esperado]** *(Cobre RFxx, RNxx, RNFxx)*\
    **Dado que** [contexto inicial],\
    **Quando** [ator executa uma ação],\
    **Então** [resultado verificável].
  ```
- **Ordem:** seguir a ordem dos RFs que cobrem; para o mesmo RF, o cenário positivo vem antes do negativo. CAs que cobrem apenas RN ou RNF vêm depois, na ordem de RN e depois RNF.
- **Agrupamento:** com mais de 8 CAs, agrupar por funcionalidade com subtítulos `####` (ex.: `#### Exportação`, `#### Acesso`, `#### Auditoria`), mantendo a numeração contínua entre os grupos. Com 8 ou menos, não usar subtítulos.
- Cada CA testa um comportamento; o "Então" deve ser objetivamente verificável.
- Incluir cenários **negativos** para autorização, validação de entrada, limites, cancelamento e preservação de dados quando aplicável.
- Usar exemplos concretos do domínio (valores, perfis, datas) quando o texto os fornecer.

### Dependências e Riscos (condicional)
- Lista, não tabela. Formato:
  ```
  - **DRxx — [Dependência | Risco]:** [descrição]\
    **Impacto:** [...]\
    **Encaminhamento:** [mitigação ou ação]\
    **Situação:** [...]
  ```
- Incluir somente o que o texto indicar ou que seja consequência direta (ex.: depende de mapeamento existente, risco de apagar dados fora do escopo). Omitir se não houver.

### Pendências (condicional)
- Omitir quando não houver dúvidas.
- Formato `**PAxx —** [pergunta objetiva]` seguido de **Impacto** e **Responsável** (papel/área; use "A definir" se desconhecido).
- Registrar aqui toda lacuna, ambiguidade ou contradição do texto que bloqueie ou possa alterar a implementação. **Nunca resolver uma lacuna por suposição silenciosa.**

### Fusão de Dependências/Riscos e Pendências
- Quando ambas as seções existirem e cada uma tiver no máximo 2 itens, juntá-las em uma única seção `### Riscos e Pendências`, listando primeiro os DRs e depois as PAs, mantendo seus identificadores e formatos.
- Caso contrário, manter as duas seções separadas.

## Princípios

- **Não inventar fatos**: métricas, prazos, nomes de tabelas, endpoints, perfis, telas ou regras ausentes no texto não podem aparecer como requisito.
- **Separar necessidade de solução**: soluções sugeridas no texto bruto viram RF/RN apenas se forem a necessidade; viram RNF se forem restrição técnica explícita; caso contrário, podem ser mencionadas no contexto ou viram pendência ("A solução X é obrigatória?").
- **Proporcionalidade**: demandas simples devem resultar em documentos curtos. Seções condicionais vazias são omitidas — não deixe placeholders nem "N/A".
- **Linguagem verificável**: "deve", "não deve", "exibe", "rejeita", "preserva". Evitar "adequado", "conforme necessário", "etc.".
- **Identificadores** únicos e sequenciais por tipo, sem lacunas: RF01, RF02…; RN01…; RNF01…; CA01…; DR01…; PA01….
- **Preservar termos do domínio** exatamente como o negócio os usa (nomes de perfis, telas, campos).
- **Contradições** no texto bruto: não escolher um lado; registrar como pendência citando ambas as versões.

## Lista de verificação final

Antes de entregar, confirme:

- [ ] Há uma linha de título sugerido fora do bloco (exceto em entrega parcial).
- [ ] O objetivo é o último parágrafo do contexto; a linha de Bloqueios, se houver, vem logo depois e cita apenas PAs bloqueantes existentes.
- [ ] Fora do Escopo vem logo após o Objetivo/Bloqueios, como rótulo em negrito seguido de linha em branco.
- [ ] Todas as seções obrigatórias estão presentes e na ordem do template; `---` aparece apenas antes dos cabeçalhos `## ESPECIFICAÇÃO`, `## VALIDAÇÃO` e `## PONTOS DE ATENÇÃO`; seções usam `###` e grupos de CA usam `####`.
- [ ] Seções condicionais sem conteúdo foram omitidas; o Glossário só existe se esclarece algo necessário, e está no lugar certo conforme a quantidade de termos.
- [ ] Dependências e Riscos e Pendências foram fundidas se ambas têm no máximo 2 itens.
- [ ] Todo RF, RN e RNF crítico está coberto por pelo menos um CA, e todo CA indica o que cobre.
- [ ] CAs estão na ordem dos RFs (positivo antes do negativo) e agrupados com `####` apenas se forem mais de 8.
- [ ] Há ao menos um CA negativo quando existe autorização, validação ou exclusão de dados.
- [ ] Nenhum RNF usa termo vago sem critério de verificação.
- [ ] Nenhum dado foi inventado; lacunas estão em Pendências.
- [ ] Identificadores estão sequenciais e as referências cruzadas existem.
- [ ] A saída está no formato de entrega pedido (bloco ` ````markdown ` único ou arquivo), sem texto extra.
- [ ] Linhas de um mesmo item terminam com `\`; itens multilinha separados por linha em branco; sem `***`, sem placeholders `[...]` nem escapes `\[`.
