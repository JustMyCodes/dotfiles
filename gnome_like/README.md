# GNOME-like
Áreas de trabalho virtuais no Windows com comportamento parecido com o **GNOME/Linux**,
usando [AutoHotkey v2](https://www.autohotkey.com/) e a
[`VirtualDesktopAccessor.dll`](https://github.com/Ciantic/VirtualDesktopAccessor).

O script `gnome_like.ahk` traz navegação fluida entre áreas de trabalho no estilo
Linux (`Win+Alt+←/→`), criação e remoção **dinâmicas** de áreas (cria quando precisa,
apaga quando esvazia), nomeação automática (`WORKSPACE N`), rotina **anti-flash**
(evita ícones piscando na barra de tarefas), preservação do **auto-hide** da barra em
setups **multi-monitor** e foco inicial na janela do **monitor principal** ao navegar.

## Funcionalidades

| Atalho | Ação |
|---|---|
| `Win+Alt+←` / `Win+Alt+→` | Navega para a área anterior/próxima (estilo Linux). Na **última** área, `→` **cria** uma nova. |
| `Ctrl+Shift+Alt+←/→/↑/↓` | Move a **janela ativa** para a área vizinha e segue junto com ela. |

Comportamentos automáticos:

- **Criação dinâmica** — ao navegar para a direita na última área, uma nova é criada sob demanda.
- **Remoção dinâmica** — ao **sair de uma área vazia**, ela é excluída automaticamente
  (nunca remove a última área existente).
- **Reindexação de nomes** — após remover uma área do meio, todas são renomeadas em ordem
  (`WORKSPACE 1`, `WORKSPACE 2`, `WORKSPACE 3`...), sem buracos na numeração.
- **Nomeação automática** — novas áreas recebem o nome `WORKSPACE N` (N = número 1-based).
- **Anti-flash** — cancela o piscar (vermelho) dos ícones na barra de tarefas após cada
  troca, de forma **seletiva** (sem perturbar a própria barra de tarefas).
- **Auto-hide preservado (multi-monitor)** — força a barra de tarefas com ocultação
  automática a recolher após a troca, via API oficial `SHAppBarMessage`, aplicando o
  comando à barra do monitor **principal** e a **todas** as barras dos monitores
  **secundários**.
- **Foco no monitor principal** — ao entrar numa área, a janela inicialmente focada é a
  mais alta (ordem Z) do **monitor principal**; se não houver nenhuma nele, vale o
  comportamento nativo do Windows.

## Requisitos

- **Windows 10/11** com áreas de trabalho virtuais.
- **AutoHotkey v2** (64 bits) — https://www.autohotkey.com/
- **VirtualDesktopAccessor.dll** (64 bits) — compatível com a sua build do Windows.
  Baixe em: https://github.com/Ciantic/VirtualDesktopAccessor

> ⚠️ Use **AHK de 64 bits com a DLL de 64 bits**. Misturar arquiteturas (32/64)
> faz a DLL não carregar.


Funções da DLL utilizadas: `GetDesktopCount`, `GetCurrentDesktopNumber`,
`GoToDesktopNumber`, `CreateDesktop`, `RemoveDesktop`, `MoveWindowToDesktopNumber`,
`GetWindowDesktopNumber`, `SetDesktopName`.

## Instalação

1. Instale o **AutoHotkey v2 (64 bits)**.
2. Coloque a **`VirtualDesktopAccessor.dll`** (64 bits) em um destes locais:
   - Na **mesma pasta** do script; **ou**
   - Em `%USERPROFILE%\.config\yasb\VirtualDesktopAccessor.dll`.
   O script procura automaticamente nesses dois caminhos.
4. Dê **duplo clique** em `gnome_like.ahk` para executar.
5. *(Opcional)* Para iniciar junto com o Windows, crie um atalho do script na pasta:
   ```
   shell:startup
   ```

## ⚙️ Configuração

As opções ficam no topo de `gnome_desktops.ahk`:

```autohotkey
kWrapDesktops        := false          ; true = navegação circular (dá a volta no fim/início)
kNamePrefix          := "WORKSPACE "   ; prefixo dos nomes -> "WORKSPACE 1", "WORKSPACE 2"...
kAntiFlash           := true           ; true = cancela o piscar dos ícones após trocar de área
kAutoRemoveEmpty     := true           ; true = ao sair de uma área VAZIA, exclui-a
kFocusPrimaryMonitor := true           ; true = ao navegar, foca a janela do MONITOR PRINCIPAL
```

| Opção | Padrão | Descrição |
|---|---|---|
| `kWrapDesktops` | `false` | Comportamento GNOME (não circular). `true` faz a navegação dar a volta. |
| `kNamePrefix` | `"WORKSPACE "` | Prefixo usado na nomeação automática das áreas. |
| `kAntiFlash` | `true` | Suprime o efeito de piscar (vermelho) dos ícones na barra de tarefas. |
| `kAutoRemoveEmpty` | `true` | Remove automaticamente a área ao sair dela quando está vazia. |
| `kFocusPrimaryMonitor` | `true` | Ao entrar numa área, ativa a janela do monitor principal (se existir). |

## Notas

- **Reordenar áreas não é suportado.** Nem a `VirtualDesktopAccessor.dll` nem o próprio
  Windows expõem uma API pública para reordenar (mover a posição) de áreas de trabalho.
  As funções `MoveDesktop`/`MoveDesktopIndex` **não existem** na DLL.
- **Anti-flash seletivo.** A rotina cancela o piscar (`FlashWindowEx` com `FLASHW_STOP`)
  apenas de janelas de apps, **ignorando** `Shell_TrayWnd`, `Shell_SecondaryTrayWnd`,
  `NotifyIconOverflowWindow`, `Progman` e `WorkerW`, além da janela ativa. Isso evita
  perturbar o auto-hide da barra de tarefas.
- **Auto-hide multi-monitor.** Cada monitor tem sua própria janela de barra de tarefas
  (`Shell_TrayWnd` no principal; `Shell_SecondaryTrayWnd` em cada secundário). Após
  remover/renomear áreas (operações que "acordam" a shell), o script chama
  `SHAppBarMessage(ABM_SETSTATE, ABS_AUTOHIDE)` — a mesma ação que o Windows executa
  internamente — em **todas** as barras, com passes atrasados (400/700 ms) para cobrir
  efeitos que chegam depois da transição.
- **Foco no monitor principal.** Detecta o monitor principal via `MonitorFromWindow` +
  `GetMonitorInfoW` (flag `MONITORINFOF_PRIMARY`) e ativa, com pequeno atraso (120 ms)
  após a transição, a janela mais alta na ordem Z daquela área que esteja no principal.
  Fallback: sem janelas no principal, mantém o comportamento nativo.
- **Detecção de área vazia.** Uma área é considerada vazia quando não há janelas "reais"
  (visíveis, com título, sem `WS_EX_TOOLWINDOW`, fora da shell). Se a contagem não puder
  ser determinada, a área **não** é removida (medida de segurança).
- **Structs em 64 bits.** `FLASHWINFO`, `APPBARDATA` e `MONITORINFO` são montadas
  respeitando o alinhamento de ponteiros do x64.
- A `VirtualDesktopAccessor.dll` é um binário de terceiros e depende da build do Windows; recomenda-se **não** versioná-la e sim documentar de onde baixá-la.