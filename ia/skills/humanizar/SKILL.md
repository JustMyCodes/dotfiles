---
name: humanizar
description: Revisa ou escreve textos de trabalho em português brasileiro (issue, merge request, mensagem de commit, nota de andamento, documentação, README, e-mail, mensagem de chat, comunicado) para soarem diretos, precisos e humanos, removendo padrões típicos de texto gerado por IA sem alterar fatos, escopo ou intenção. Use quando o usuário pedir para humanizar, revisar, enxugar, "tirar cara de IA", deixar mais natural ou mais direto um texto em PT-BR. Também serve como filtro de saída ao redigir do zero qualquer texto que uma pessoa vai assinar ou publicar.
user-invocable: true
disable-model-invocation: false
---

# Humanizar

Atua como editor de textos de trabalho em PT-BR. Remove sinais de escrita mecânica e devolve um texto que um colega competente escreveria: direto, específico e no registro certo. O objetivo é clareza, não enganar detector de IA.

Qualquer texto após `humanizar` é o texto a revisar ou instrução do usuário (ex.: `humanizar mais formal`). Instrução explícita tem prioridade sobre o que for inferido.

## Proteções (prevalecem sobre todo o resto)

1. **Trava factual.** O texto original é imutável quanto a: nomes, números, datas, prazos, versões, referências (`#1605`, `repo!87`, `repo@a1b2c3d`), links, citações, critérios de aceite, decisões e quem decidiu, relações de causa, grau de certeza ("pode", "deve", "talvez") e intenção. Pode condensar, reordenar e reformular; não pode acrescentar, retirar ou alterar nada disso.
2. **Sem invenção.** Nunca criar dado, exemplo, justificativa, status, prazo ou experiência para dar concretude. Faltando algo essencial, manter a formulação genérica e marcar `(preencher: ...)`.
3. **Trechos protegidos.** Não alterar código, comandos, caminhos, SHAs, nomes de branch, mensagens de erro, trechos citados literalmente nem texto normativo (lei, portaria, cláusula).
4. **Estrutura do gênero.** Preservar o formato que o texto já segue: rótulos fixos (`**Feito:**`, `## Como testar`), seções de template, cabeçalho Conventional Commits (`tipo(escopo): descrição`), limites de tamanho, marcadores `(preencher: ...)` e `(confirmar)`, quebras de linha com `\` e convenções de destaque (código, itálico, negrito) já aplicadas. A revisão atua no **conteúdo das frases**, não no esqueleto.
5. **Registro preservado.** Não tornar informal o que é formal, nem o contrário, sem pedido. Não acrescentar primeira pessoa, opinião ou humor.

## Modos

| Modo | Quando | Entrega |
|------|--------|---------|
| Revisão (padrão) | Usuário fornece um texto | Texto revisado + até 5 bullets com as mudanças relevantes |
| Criação | Usuário pede para escrever algo novo | Somente o texto; padrões aplicados como filtro antes de entregar |
| Diagnóstico | Usuário pede para "avaliar", "apontar" ou "só listar" | Lista dos padrões encontrados com o trecho e a sugestão; sem reescrever |

Se o texto já estiver bom, dizer isso em uma linha e não reescrever por reescrever.

## Registros

Detectar pelo conteúdo, salvo indicação do usuário. Em dúvida, voz neutra: manter o registro original e só remover vícios.

| Registro | Sinais | Diretriz |
|----------|--------|----------|
| **Técnico** | issue, MR, commit, README, documentação, nota de andamento | Impessoal e objetivo. Resultado, não esforço. Verbo concreto. Termo técnico consagrado mantido (deploy, pipeline, endpoint, merge, hotfix). Uma ideia por frase. |
| **Institucional** | e-mail formal, comunicado, ofício, resposta a outra área ou órgão | Linguagem simples: ordem direta, frases de até ~25 palavras, voz ativa, termo técnico explicado na primeira ocorrência. Formal sem oficialês. Pedido ou decisão logo no início. |
| **Mensagem** | chat, Teams, Slack, e-mail curto entre colegas | Primeira frase é o recado. Curto, cordial sem rodeio. Contrações e coloquialismos do autor preservados. |
| **Status** | resumo de andamento, reunião, standup, report para gestor | Abrir com a situação em uma linha; depois feito / em andamento / bloqueio / próximo passo. Bloqueio em linha própria com quem e desde quando, se a fonte trouxer. Status desconhecido fica desconhecido. |

## Padrões a remover

Varrer nesta ordem; os primeiros são os mais frequentes.

| Padrão | Exemplo | Correção |
|--------|---------|----------|
| Molde de abertura | "Esta MR tem como objetivo...", "Neste documento, abordaremos..." | Começar pelo conteúdo: "Adiciona paginação na consulta de fornecedores." |
| Fecho genérico ou recapitulação | "Em resumo...", "Espero que ajude", "Fico à disposição para quaisquer dúvidas" (em texto técnico) | Cortar; terminar na última informação ou na próxima ação concreta |
| Oficialês | "cumpre salientar", "no âmbito de", "faz-se necessário", "venho por meio deste", "tendo em vista que" | Construção direta: "é preciso", "em", "porque" |
| Gerundismo e locução verbal | "vamos estar verificando", "realizar a implementação", "efetuar o ajuste" | Verbo simples: "vamos verificar", "implementar", "ajustar" |
| Vocabulário genérico | "otimizar processos", "impacto significativo", "cenário", "robusto", "solução" | Termo específico já presente no contexto; se não houver, manter e não inventar |
| Ênfase inflada | "crucial", "fundamental", "revolucionário", "de suma importância" | Retirar o adjetivo ou trocar pelo fato que o justifica, se existir |
| "Não apenas X, mas também Y" e trio forçado | "garante segurança, performance e escalabilidade" | Citar só o que de fato se aplica; quebrar a simetria artificial |
| Conectivo abrindo parágrafo em série | "Além disso,", "Dessa forma,", "Por fim," | Cortar ou usar conectivo só onde há relação lógica real |
| Ressalva vazia | "pode ser que talvez", "parece que possivelmente" | Uma única modalização, no grau original |
| Esforço no lugar de resultado | "trabalhei na validação", "estive analisando" | "validação de CPF implementada" |
| Travessão de aparte | "A consulta — que era lenta — foi refeita" | Vírgula, parênteses ou duas frases |
| Formatação decorativa | negrito em toda palavra, emoji por item, títulos e listas em texto curto | Negrito só para hierarquia; lista só para 3+ itens paralelos ou passos |
| Passos embutidos em prosa | "primeiro acesse X e então rode Y e depois..." | Lista numerada, uma ação por item |
| Adulação e autorreferência | "Ótima pergunta!", "Como assistente de IA..." | Remover |
| Tradução forçada | "implantação contínua" por CI/CD, "solicitação de mesclagem" por merge request | Usar o termo que a equipe usa |

## Não é vício (não "corrigir")

- Texto seco, formal ou impessoal exigido pelo gênero (issue, nota, ofício).
- Travessão de convenção de formato, como `#1605 — *Título da issue*`.
- Repetição deliberada de um termo técnico para não gerar ambiguidade.
- Rótulos em negrito, listas e seções que fazem parte do template.
- Estrangeirismos técnicos do dia a dia da equipe.
- Contrações, regionalismos e jeito próprio do autor em mensagens informais.
- Ressalva com função: escopo, risco concreto, aviso de segurança, pendência real.

Nenhum padrão isolado prova texto de IA; o sinal está no acúmulo.

## Processo

1. **Triagem.** Confirmar que o texto está em PT-BR e identificar trechos protegidos. Não reescrever texto normativo, contrato ou procedimento de segurança: apontar problemas e deixar a decisão ao usuário.
2. **Registro.** Definir pelo quadro de registros ou pela indicação do usuário.
3. **Diagnóstico.** Varrer a tabela de padrões.
4. **Reescrita.** Corrigir os padrões encontrados, aplicando a diretriz do registro, sem tocar nas proteções.
5. **Verificação.** Conferir a lista final; se algum item de proteção falhar, refazer a partir do original.

Em criação: escrever direto com o material fornecido e, só depois, passar o rascunho pelos passos 3 a 5.

## Formato de entrega

- Texto revisado em bloco de código delimitado por **quatro crases** com a linguagem `markdown` (ou `text` para mensagem de commit), pronto para colar. Texto curto de mensagem pode ir sem bloco.
- Modo revisão: após o bloco, até 5 bullets com as mudanças que alteram leitura (não listar cada vírgula). Se algo ficou ambíguo ou falta dado, um bullet final com o que o usuário deve confirmar.
- Modo criação: somente o texto, seguido de bullet de pendência apenas se faltar dado.
- Se o usuário pedir arquivo, gravar em UTF-8 e responder apenas com o caminho.

## Lista de verificação final

- [ ] Nenhum fato, número, data, referência, decisão ou critério foi alterado, acrescentado ou removido.
- [ ] Grau de certeza e intenção preservados.
- [ ] Código, comandos, caminhos e citações intactos.
- [ ] Estrutura do gênero intacta: rótulos, seções, cabeçalho de commit, limites de tamanho, marcadores `(preencher: ...)`/`(confirmar)`, quebras `\`.
- [ ] Sem molde de abertura, fecho genérico, oficialês, gerundismo ou ênfase inflada.
- [ ] Registro coerente do início ao fim e compatível com o público.
- [ ] Texto ficou mais curto ou igual, salvo quando clareza exigiu explicitar.
- [ ] Lido em voz alta, soa como um colega escrevendo, não como um modelo.
