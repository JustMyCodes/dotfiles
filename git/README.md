## Git
Just My Git Configuration

---

Configuração centralizada em `~/.config/git/`:
```
~/.config/git/
├── gitmessage.txt   # template padrão de mensagem de commit (Conventional Commits)
└── hooks/
    └── prepare-commit-msg   # preenche "Refs #<numero>" automaticamente
```

- **`gitmessage.txt`**: esqueleto de mensagem seguindo [Conventional Commits](https://www.conventionalcommits.org/),
  com a lista de tipos (`feat`, `fix`, `docs`...) comentada como referência.
> Para abortar o commit, salve a mensagem totalmente em branco (sem espaços ou texto imprimivel).
> O git aborta automaticamente (mensagem vazia), em vez de commitar por engano.
- **`hooks/prepare-commit-msg`**: script executado automaticamente antes de
  finalizar o commit. Ele extrai o número do item de trabalho a partir do nome da
  branch atual (ex.: `124-nome-da-tarefa`) e adiciona `Refs #124` ao final da
  mensagem.

### Configuração

```bash
git config --global core.editor "nvim"
git config --global commit.template ~/.config/git/gitmessage.txt
git config --global core.hooksPath ~/.config/git/hooks
chmod +x ~/.config/git/hooks/prepare-commit-msg
```

### Pré-requisito para o hook funcionar

O nome da branch precisa conter o número do item de trabalho,
já que é dali que o número é extraído. Sem número no nome da branch, o commit
segue normalmente, só sem a referência automática.
