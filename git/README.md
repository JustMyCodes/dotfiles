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


### Referencias

- [GitHub Flow](https://githubflow.github.io/)
- [Branchs - GitLab](https://docs.gitlab.com/user/project/repository/branches/#configure-default-pattern-for-branch-names-from-issues)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [GitHooks](https://git-scm.com/docs/githooks)
- [Git Commit](https://git-scm.com/docs/git-commit)

