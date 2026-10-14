# Modelos de nota

Campos marcados como opcionais são omitidos quando não houver conteúdo. A ordem dos campos é fixa.

## Nota de Progresso

```markdown
**[1]** [Feito, resultado e não esforço]; **[2]** [Outro feito; se pertinente, avanço nos critérios de aceite].

**Bloqueios:**

- [ ] [Opcional. Externo: o quê, de quem, desde dd/mm/aaaa, impacto. Pessoal: o quê, sem data];
- [ ] [Outro bloqueio].

**Próximo:**

- [ ] [Passo concreto];
- [ ] [Outro passo].
```

Primeira linha: com um item só, sem numeração (`Validação de CPF implementada.`). Campos com rótulo: sempre em lista de tarefas, mesmo com um item; itens terminados com `;` e o último com `.`. Campos separados por linha em branco.

Exemplo (bloqueio externo):

```markdown
**[1]** Validação de CPF implementada no cadastro de fornecedores; **[2]** CA01–CA02 atendidos, CA03 pendente.

**Bloqueios:**

- [ ] Aguardando acesso ao banco de homologação (equipe de *Infraestrutura*, desde 28/09/2026); impacta o prazo.

**Próximo:**

- [ ] Validar em homologação.
```

Exemplo (item de estudo, um item por campo):

```markdown
Capítulos 1 e 2 de *Linux Basics for Hackers* concluídos.

**Próximo:**

- [ ] Continuar a partir do capítulo 3.
```

Exemplo (bloqueio pessoal):

```markdown
**[1]** Capítulos sobre particionamento de *PostgreSQL: Up and Running* concluídos; **[2]** Síntese iniciada na wiki.

**Bloqueios:**

- [ ] Dificuldade em entender estratégias de reindexação; revisando material complementar.

**Próximo:**

- [ ] Aplicar particionamento na tabela de auditoria em ambiente de teste;
- [ ] Publicar a síntese na wiki.
```
## Nota de Ocorrência

```markdown
[Evento/tema (data e horário apenas se registro retroativo)];
> [Opcional. Desdobramento: o que ficou para o usuário; quem decidiu; issue criada, se houver];
```

Exemplo (com desdobramento):

```markdown
Reunião semanal da equipe de *Engenharia*;
> Definido com *Maria Souza* que assumo a issue #512;
```

Exemplo (sem desdobramento):

```markdown
Reunião semanal da equipe de *Engenharia*;
```

Exemplo (registro retroativo):

```markdown
Reunião semanal da equipe de *Engenharia* (25/09/2026, 11h00–11h30);
```

## Nota de Entrega

```markdown
**[1]** [O que foi entregue; critérios atendidos, se pertinente; merge request ou commit com repositório, se for a entrega]; **[2]** [...].

**Desdobramento:**

- [ ] [Opcional: pendência ou descoberta a tratar separadamente → issue nova];
- [ ] [...].
```

Exemplo:

```markdown
**[1]** CA01–CA04 atendidos; **[2]** CPF inválido bloqueado e CPF válido aceito no cadastro de fornecedores; **[3]** Merge request cadastro-fornecedores!87 integrado à `main`.

**Desdobramento:**

- [ ] Verificação de duplicidade de CPF → #530;
- [ ] Descoberta: cadastro de clientes também aceita CPF inválido → #531.
```

Exemplo (item de estudo):

```markdown
*Linux Basics for Hackers* finalizado e síntese publicada na wiki da equipe.
```