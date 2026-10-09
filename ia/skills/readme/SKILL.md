---
name: readme
description: Cria ou revisa o README.md de um repositório usando um modelo próprio, que separa instalação de uso, trata erros no ponto onde eles acontecem e termina a instalação com uma verificação. Use sempre que o usuário pedir README, "documentar o projeto", "documentação do repositório", revisão de um README existente, ou quando um projeto novo for criado e ainda não tiver documentação de entrada.
---

Você vai escrever ou revisar o `README.md` de um repositório.

O modelo em `readme_template.md` (mesma pasta desta skill) é o ponto de partida. Leia-o antes de começar. As regras abaixo explicam *por que* ele é assim — elas valem mais que o template quando as duas coisas conflitarem.

## 1. Levante o contexto antes de escrever

Nunca preencha o template com texto plausível inventado. Um README com informação errada é pior que um README curto: quem chega confia nele e perde tempo.

Inspecione o que estiver disponível:

- Arquivos de manifesto (`package.json`, `go.mod`, `pom.xml`) — nome, versões, scripts.
- `docker-compose.yml`, `Dockerfile`, `Makefile` — como o projeto realmente sobe.
- `.env.example`, `config/` — variáveis de ambiente.
- `.gitlab-ci.yml`, `.github/workflows/` — como o CI monta e testa; é a documentação de build mais confiável que existe, porque ela roda.

O que não der para descobrir assim, pergunte. Se o usuário não souber ou não quiser responder agora, deixe a seção com um comentário HTML marcando a lacuna — comentário não aparece no render, então o README não fica com placeholder visível.

## 2. Ordem das seções

Da pergunta mais urgente para a menos urgente:

```
Título + uma frase + sobre implícito
Estrutura do projeto
Pré-requisitos
Instalação
Uso
Configuração
Desenvolvimento
Testes
Deploy
Solução de Problemas (Troubleshooting)
```

Remova o que não se aplica e mantenha a estrutura minimalista. Um README com seção "Deploy" vazia ensina o leitor a não confiar nos títulos.

**Instalação e Uso são seções separadas.** Subir o projeto é um problema; usá-lo é outro. Quem já instalou não quer reler a instalação para lembrar um comando.

## 3. Erros de instalação: dois lugares, critério claro

Esta é a parte que a maioria dos READMEs erra, e é o que mais economiza tempo depois.

**Inline, logo abaixo do passo que falha** — erros previsíveis, de causa única, com correção sempre igual. Formato *sintoma → causa → correção*, em duas ou três linhas. Exemplos do tipo: dependência ausente, VPN desligada, permissão de arquivo, diretório que precisa existir antes.

O motivo é comportamental: quem está no meio de um erro não rola a página até o fim. A informação precisa estar onde os olhos já estão.

**Na seção Troubleshooting** — o que exige diagnóstico. Várias causas possíveis, dependente de ambiente, ou que só aparece depois da instalação. Use `<details>` para não inflar a página.

O teste para decidir: se a correção cabe em duas linhas e é sempre a mesma, é inline. Se a primeira resposta honesta é "depende, o que o log diz?", é Troubleshooting.

**Avisos não são erros.** `warn` que não interrompe a execução não vira seção de troubleshooting. Se o aviso for esperado e inofensivo, uma linha dizendo isso basta. Se ele tiver consequência silenciosa — algo que deixa de acontecer sem ninguém perceber —, aí sim documente, e documente a consequência, não o texto do aviso.

## 4. Termine a Instalação com uma verificação

Sempre feche a seção com um comando que confirma que deu certo, e a saída esperada:

```bash
docker compose ps        # todos os serviços em "running"
curl -s localhost:8080/health
```

Isso é o item de maior retorno do README inteiro. Converte falha silenciosa em falha visível no momento em que ainda é barato consertar — em vez de o problema aparecer vinte minutos depois, longe da causa.

## 5. Prefira decisão executável a decisão narrada

Quando uma orientação puder virar arquivo versionado em vez de parágrafo, ela deve virar arquivo. Um campo de configuração no manifesto, um `.env.example`, um alvo no `Makefile` — isso passa por revisão, não precisa ser lido para funcionar e não envelhece em silêncio.

O README então explica o *porquê* da decisão, não o passo a passo dela.

## 6. Formato do conteúdo

- **Configuração em tabela** (`Variável | Obrigatória | Padrão | Descrição`). Em prosa, envelhece mal e ninguém percebe.
- **Pré-requisitos em tabela**, com versão mínima. Inclua acessos, não só ferramentas: VPN, chave SSH, credencial de registry.
- **Estrutura do projeto**: só as pastas que importam para quem chega agora. Não cole a saída do `tree`.
- **Exemplo concreto vence descrição.** Em Uso, mostre entrada e saída reais.
- Nunca coloque segredo real, mesmo de ambiente interno. Aponte para o `.env.example`.
- Se o projeto for interno e sem licença, diga isso explicitamente em Licença. Seção ausente é ambígua.

## 7. Ao revisar um README existente

Não reescreva por padrão. Compare com a ordem da seção 2, aponte o que falta e o que está desatualizado em relação ao código que você inspecionou, e proponha as mudanças. Comandos que não existem mais são o defeito mais comum e o mais caro.

## 8. Feche

Salve como `README.md` na raiz do repositório (ou onde o usuário indicar) e liste em uma ou duas linhas as lacunas que ficaram marcadas com comentário, para o usuário completar.

