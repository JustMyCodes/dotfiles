## Git
Just My Git Configuration

Inicialmente essa configuração tem como finalidade apenas automatizar 
o preenchimento de commits com o número de referência da issue.

### Pré-requisito para o hook funcionar

O nome da *branch* precisa conter o número da issue, já que é dali que o número é extraído.

Sem número no nome da branch, o commit segue normalmente, só que sem a referência automática.

### Estrutura

Configuração centralizada em `~/.config/git/`:
```
~/.config/git/
├── gitmessage.txt   # template padrão de mensagem de commit (Conventional Commits)
└── hooks/
    └── prepare-commit-msg   # preenche "refs #<NUMERO>" automaticamente
```

- **`gitmessage.txt`**: esqueleto de mensagem seguindo [Conventional Commits](https://www.conventionalcommits.org/),
  com a lista de tipos (`feat`, `fix`, `docs`...) comentada como referência.

- **`hooks/prepare-commit-msg`**: script executado automaticamente antes de
  finalizar o commit. Ele extrai o número do item de trabalho a partir do nome da
  branch atual (ex.: `124-descricao-branch`) e adiciona `refs #124` ao final da
  mensagem.

### Configuração

```bash
git config --global core.editor "nvim" # altere para seu editor preferido
git config --global commit.template ~/.config/git/gitmessage.txt
git config --global core.hooksPath ~/.config/git/hooks
chmod +x ~/.config/git/hooks/prepare-commit-msg
```
### Uso

#### `git commit`
Quando você usar apenas `git commit`, o git vai abrir o arquivo `gitmessage.txt` no seu editor de texto padrão;
- Edite a mensagem de commite e salve;

**Obs**
1. Os comentários (linhas iniciadas com #) são descartados automaticamente pelo git ao finalizar o commit — não é necessário apagá-los manualmente.
2. Para abortar o commit, basta deixar a mensagem sem nenhum conteúdo além de linhas em branco e comentários (linhas iniciadas com #).
O git detecta que a mensagem final ficaria vazia e aborta automaticamente, em vez de commitar.

#### `git commit -m '<MESSAGE>'`
Com a opção `-m`, o script adiciona `refs #<NUMERO>` no *corpo/footer* da mensagem de commit automaticamente (depois de `<MESSAGE>`). Nenhum editor será aberto.

> Para visualizar os metadados do commite mais recente e como ficou a mensagem completa use:
> ```git log -1```

### Identidade por repositório

O `user.name` e o `user.email` do `~/.gitconfig` valem para todos os
repositórios da máquina. Quando a mesma máquina tem repositórios de contas
diferentes (pessoal e trabalho, por exemplo), deixe no `~/.gitconfig` a
identidade mais usada e sobrescreva a outra por uma das formas abaixo.

Os valores são exemplos: troque `Seu Nome`, `voce@exemplo.com` e `SuaConta`.

#### Um repositório só

```bash
git config --local user.name "Seu Nome"
git config --local user.email voce@exemplo.com
```

Fica gravado no `.git/config` daquele clone. Um clone novo volta à identidade
global, então é preciso repetir.

#### Todos os repositórios de uma conta

Guarde a identidade em um arquivo próprio, por exemplo `~/.gitconfig-pessoal`:

```ini
[user]
	name = Seu Nome
	email = voce@exemplo.com
```

E inclua-o no **fim** do `~/.gitconfig`, depois da seção `[user]` (a última
definição lida é a que vale):

```ini
[includeIf "hasconfig:remote.*.url:git@github.com:SuaConta/**"]
	path = ~/.gitconfig-pessoal
[includeIf "hasconfig:remote.*.url:https://github.com/SuaConta/**"]
	path = ~/.gitconfig-pessoal
```

Todo repositório com um remoto dessa conta passa a usar a identidade do
arquivo, inclusive os clonados depois. São duas regras porque a URL muda
conforme o clone foi feito por SSH ou por HTTPS. Exige Git 2.36 ou mais novo.

#### Por diretório

A regra por remoto só vale depois do `git remote add`. Em um repositório
criado com `git init`, os commits feitos antes disso saem com a identidade
global. Para cobrir esse intervalo, inclua o mesmo arquivo pelo caminho:

```ini
[includeIf "gitdir:~/projetos/pessoal/"]
	path = ~/.gitconfig-pessoal
```

A barra no final faz a regra valer para o diretório e tudo abaixo dele.

#### Chave SSH por conta

A identidade do commit não escolhe a chave de autenticação. Para cada host,
indique a chave no `~/.ssh/config`:

```
Host github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_pessoal
  IdentitiesOnly yes
```

O `IdentitiesOnly yes` impede que as outras chaves da máquina sejam oferecidas
a esse host. Teste com `ssh -T git@github.com`.

#### Conferir antes do primeiro commit

```bash
git config --show-origin user.email
```

O comando mostra o email em vigor e o arquivo de onde ele veio. Depois do
commit, `git log -1 --format='%an <%ae>'` mostra o que foi gravado.

### Referencias

- [GitHub Flow](https://githubflow.github.io/)
- [Branchs - GitLab](https://docs.gitlab.com/user/project/repository/branches/#configure-default-pattern-for-branch-names-from-issues)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [GitHooks](https://git-scm.com/docs/githooks)
- [Git Commit](https://git-scm.com/docs/git-commit)
- [Git Config — Conditional includes](https://git-scm.com/docs/git-config#_conditional_includes)

