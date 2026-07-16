; ============================================================
;  Áreas de trabalho estilo GNOME/Linux (AutoHotkey v2)
;  Funções:
;    1) Ctrl+Shift+Alt+Seta       -> move a JANELA ativa para a área vizinha (+ segue)
;    2) Criação dinâmica          -> uma nova área é criada sob demanda
;    3) Win+Alt+Seta              -> navega entre as áreas (estilo Linux);
;                                  na ÚLTIMA área, seta p/ direita CRIA uma nova.
;    4) Remoção dinâmica          -> ao SAIR de uma área VAZIA, ela é excluída.
;    5) Foco no monitor principal -> ao navegar, a janela inicialmente focada
;                                   é a do MONITOR PRINCIPAL (se existir).
;    * Novas áreas são nomeadas automaticamente como "WORKSPACE N" (N = número 1-based).
;    * Rotina ANTI-FLASH: após cada troca de área, cancela o piscar (vermelho) APENAS
;      dos ícones que realmente estão piscando, sem perturbar a barra de tarefas.
;
;  Requisito: VirtualDesktopAccessor.dll ao lado deste script
;             (ou em %USERPROFILE%\.config\yasb\)
;  Use AutoHotkey v2 de 64 bits com a DLL de 64 bits.

; ============================================================
#Requires AutoHotkey v2.0
#SingleInstance Force
#UseHook

; ------------------------------------------------------------
; Opções
; ------------------------------------------------------------
kWrapDesktops    := false          ; função 1: cria nova área ao passar do fim (false = comportamento GNOME)
kNamePrefix      := "WORKSPACE "   ; novas áreas recebem  <prefixo><N>  ex.: "WORKSPACE 3"
kAntiFlash       := true           ; true = cancela o piscar dos ícones após trocar de área
kAutoRemoveEmpty := true           ; true = ao sair de uma área VAZIA, exclui-a
kFocusPrimaryMonitor := true       ; true = ao navegar, foca a janela do MONITOR PRINCIPAL da área de destino

; ------------------------------------------------------------
; Carrega a VirtualDesktopAccessor.dll
; ------------------------------------------------------------
global gVdaPath   := ResolveVdaPath()
global gVdaH      := 0
global gVdaLoaded := false
global gVdaFuncs  := Map()

if (gVdaPath != "") {
    try gVdaH := DllCall("LoadLibrary", "Str", gVdaPath, "Ptr")
    catch
        gVdaH := 0
    gVdaLoaded := (gVdaH != 0)
}
if !gVdaLoaded
    TrayTip "Áreas de Trabalho", "VirtualDesktopAccessor.dll não carregada. Verifique o caminho da DLL e use AHK de 64 bits.", 3

ResolveVdaPath() {
    p1 := A_ScriptDir "\VirtualDesktopAccessor.dll"
    if FileExist(p1)
        return p1
    p2 := EnvGet("USERPROFILE") "\.config\yasb\VirtualDesktopAccessor.dll"
    if FileExist(p2)
        return p2
    return ""
}

VdaFunc(name) {
    global gVdaLoaded, gVdaH, gVdaFuncs
    if !gVdaLoaded
        return 0
    if gVdaFuncs.Has(name)
        return gVdaFuncs[name]
    try p := DllCall("GetProcAddress", "Ptr", gVdaH, "AStr", name, "Ptr")
    catch
        p := 0
    if (p)
        gVdaFuncs[name] := p
    return p
}

; ------------------------------------------------------------
; Wrappers da DLL (não quebram se alguma função faltar)
; ------------------------------------------------------------
GetDesktopCount() {
    f := VdaFunc("GetDesktopCount")
    return f ? DllCall(f, "Int") : 1
}
GetCurrentDesktopNumber() {
    f := VdaFunc("GetCurrentDesktopNumber")
    return f ? DllCall(f, "Int") : 0
}
GoToDesktopNumber(n) {
    f := VdaFunc("GoToDesktopNumber")
    return f ? DllCall(f, "Int", n) : 0
}
CreateDesktop() {
    f := VdaFunc("CreateDesktop")
    return f ? DllCall(f, "Int") : 0
}
RemoveDesktop(n) {
    f := VdaFunc("RemoveDesktop")
    return f ? DllCall(f, "Int", n) : 0
}
MoveWindowToDesktopNumber(h, n) {
    f := VdaFunc("MoveWindowToDesktopNumber")
    return f ? DllCall(f, "Ptr", h, "Int", n) : 0
}
GetWindowDesktopNumber(h) {
    f := VdaFunc("GetWindowDesktopNumber")
    return f ? DllCall(f, "Ptr", h, "Int") : -1
}
; Define o nome de uma área. Retorna -1 se a DLL não suportar.
SetDesktopName(idx, name) {
    f := VdaFunc("SetDesktopName")
    if !f
        return -1
    return DllCall(f, "Int", idx, "AStr", name, "Int")   ; DLL espera char* em UTF-8
}

; ------------------------------------------------------------
; Rotina ANTI-FLASH (cirúrgica)
; ------------------------------------------------------------
; Monta a struct FLASHWINFO (20 bytes em x86, 32 em x64 por causa do ponteiro alinhado).
BuildFlashInfo(hwnd, flags) {
    size := (A_PtrSize = 8) ? 32 : 20
    fi := Buffer(size, 0)
    off := 0
    NumPut("UInt", size, fi, off), off += 4
    if (A_PtrSize = 8)
        off += 4                       ; padding p/ alinhar o HWND em 8
    NumPut("Ptr",  hwnd,  fi, off), off += A_PtrSize
    NumPut("UInt", flags, fi, off), off += 4   ; dwFlags
    NumPut("UInt", 0,     fi, off), off += 4   ; uCount
    NumPut("UInt", 0,     fi, off)             ; dwTimeout
    return fi
}

StopFlashOne(hwnd) {
    static FLASHW_STOP := 0
    fi := BuildFlashInfo(hwnd, FLASHW_STOP)
    try DllCall("user32\FlashWindowEx", "Ptr", fi.Ptr)
}

; Cancela o piscar SOMENTE das janelas que não são a ativa e que possuem título,
; ignorando a shell (Progman/WorkerW) e a própria taskbar (Shell_TrayWnd).
StopFlashingSelectively() {
    global kAntiFlash
    if !kAntiFlash
        return
    active := WinExist("A")
    for hwnd in WinGetList() {
        if (hwnd = active)             ; nunca mexer na janela ativa
            continue
        if !DllCall("IsWindowVisible", "ptr", hwnd, "int")
            continue
        try title := WinGetTitle("ahk_id " hwnd)
        catch
            continue
        if (title = "")
            continue
        try cls := WinGetClass("ahk_id " hwnd)
        catch
            continue
        if (cls = "Progman" || cls = "WorkerW"
            || cls = "Shell_TrayWnd" || cls = "Shell_SecondaryTrayWnd"
            || cls = "NotifyIconOverflowWindow")
            continue
        StopFlashOne(hwnd)
    }
    ; Reafirma o estado auto-hide da barra de tarefas (ver função abaixo).
    ForceTaskbarAutoHide()
}

; Força a barra de tarefas a voltar ao estado AUTO-HIDE (recolhida), usando a API
; SHAppBarMessage(ABM_SETSTATE, ABS_AUTOHIDE). Isso limpa o estado "auto-hide
; desativado temporariamente" que o Windows aciona quando algo pede atenção,
; sem precisar clicar no Iniciar/ícones.
; MULTI-MONITOR: aplica à barra do monitor principal (Shell_TrayWnd) E a TODAS
; as barras dos monitores secundários (Shell_SecondaryTrayWnd), pois cada
; monitor tem sua própria janela de barra de tarefas.
;   ABM_SETSTATE = 0x0000000A ; ABS_AUTOHIDE = 0x0000000001
ForceTaskbarAutoHide() {
    ; barra principal
    hTray := WinExist("ahk_class Shell_TrayWnd")
    if (hTray)
        SetAppBarAutoHide(hTray)
    ; barras dos monitores secundários (pode haver mais de uma)
    for hSec in WinGetList("ahk_class Shell_SecondaryTrayWnd")
        SetAppBarAutoHide(hSec)
}

; Envia ABM_SETSTATE/ABS_AUTOHIDE para uma janela de barra específica.
SetAppBarAutoHide(hTray) {
    static ABM_SETSTATE := 0x0A
    static ABS_AUTOHIDE := 0x01
    ; struct APPBARDATA:
    ;   DWORD cbSize; HWND hWnd; UINT uCallbackMessage; UINT uEdge;
    ;   RECT rc (4x LONG); LPARAM lParam
    size := (A_PtrSize = 8) ? 48 : 36
    abd := Buffer(size, 0)
    off := 0
    NumPut("UInt", size,  abd, off), off += 4          ; cbSize
    if (A_PtrSize = 8)
        off += 4                                       ; padding p/ alinhar HWND
    NumPut("Ptr",  hTray, abd, off), off += A_PtrSize  ; hWnd
    NumPut("UInt", 0,     abd, off), off += 4          ; uCallbackMessage
    NumPut("UInt", 0,     abd, off), off += 4          ; uEdge
    off += 16                                          ; rc (16 bytes) zerada
    if (A_PtrSize = 8 && Mod(off, 8) != 0)
        off += 8 - Mod(off, 8)                         ; alinhamento do LPARAM em x64
    NumPut("Ptr", ABS_AUTOHIDE, abd, off)              ; lParam = ABS_AUTOHIDE
    try DllCall("shell32\SHAppBarMessage", "UInt", ABM_SETSTATE, "Ptr", abd.Ptr, "Ptr")
}

; ------------------------------------------------------------
; Contagem de janelas por área (para detectar área vazia)
; ------------------------------------------------------------
CountWindowsOnDesktop(idx) {
    if !VdaFunc("GetWindowDesktopNumber")
        return -1                      ; -1 = não dá para saber (DLL sem a função)
    n := 0
    for hwnd in WinGetList() {
        if !DllCall("IsWindowVisible", "ptr", hwnd, "int")
            continue
        try title := WinGetTitle("ahk_id " hwnd)
        catch
            continue
        if (title = "")
            continue
        try exStyle := WinGetExStyle("ahk_id " hwnd)
        catch
            continue
        if (exStyle & 0x00000080)      ; WS_EX_TOOLWINDOW
            continue
        try cls := WinGetClass("ahk_id " hwnd)
        catch
            continue
        if (cls = "Progman" || cls = "WorkerW"
            || cls = "Shell_TrayWnd" || cls = "Shell_SecondaryTrayWnd"
            || cls = "NotifyIconOverflowWindow")
            continue
        if (GetWindowDesktopNumber(hwnd) = idx)
            n += 1
    }
    return n
}

; Renomeia todas as áreas para "WORKSPACE N" (usado após remover uma área).
RenameAllDesktops() {
    global kNamePrefix
    if !VdaFunc("SetDesktopName")
        return
    count := GetDesktopCount()
    loop count
        SetDesktopName(A_Index - 1, kNamePrefix A_Index)
}

; ------------------------------------------------------------
; Auxiliar de nomeação
; ------------------------------------------------------------
CreateNamedDesktop() {
    global kNamePrefix
    CreateDesktop()
    idx := GetDesktopCount() - 1          ; a nova área é a última (0-based)
    SetDesktopName(idx, kNamePrefix (idx + 1))
    return idx
}

; ------------------------------------------------------------
; Troca de área com ANTI-FLASH e REMOÇÃO DINÂMICA da área vazia de origem
; ------------------------------------------------------------
GoToDesktopSilently(to, from := -1) {
    global kAutoRemoveEmpty

    removeFrom := false
    if (kAutoRemoveEmpty && from >= 0 && from != to && GetDesktopCount() > 1) {
        cnt := CountWindowsOnDesktop(from)
        if (cnt = 0)                    ; 0 = vazia (>=1 tem janela; -1 = desconhecido, não remove)
            removeFrom := true
    }

    GoToDesktopNumber(to)

    ; Remoção/renomeação PRIMEIRO (elas "acordam" a shell/taskbar); a supressão
    ; do flash vem DEPOIS, para a barra de tarefas com auto-hide voltar a ocultar.
    if (removeFrom) {
        RemoveDesktop(from)             ; remove a área de origem, agora vazia
        RenameAllDesktops()             ; reindexa os nomes "WORKSPACE N"
    }

    ; Vários passes de anti-flash: imediato + atrasados, pois o efeito de acordar
    ; a taskbar (flash/foreground) pode chegar depois da remoção/renomeação.
    StopFlashingSelectively()
    SetTimer(StopFlashingSelectively, -60)
    SetTimer(StopFlashingSelectively, -180)
    SetTimer(StopFlashingSelectively, -350)
    ; foca a janela do monitor principal da área de destino (após a transição)
    SetTimer(() => FocusPrimaryMonitorWindow(to), -120)
    ; passes finais: garantem que TODAS as barras (multi-monitor) recolham,
    ; mesmo quando o efeito de acordar chega atrasado
    SetTimer(ForceTaskbarAutoHide, -400)
    SetTimer(ForceTaskbarAutoHide, -700)
}


; ------------------------------------------------------------
; Foco no MONITOR PRINCIPAL após a navegação
; ------------------------------------------------------------
; Retorna true se a janela está (majoritariamente) no monitor principal.
IsWindowOnPrimaryMonitor(hwnd) {
    static MONITOR_DEFAULTTONEAREST := 2
    try hMon := DllCall("user32\MonitorFromWindow", "Ptr", hwnd, "UInt", MONITOR_DEFAULTTONEAREST, "Ptr")
    catch
        return false
    if !hMon
        return false
    ; MONITORINFO: DWORD cbSize; RECT rcMonitor; RECT rcWork; DWORD dwFlags
    mi := Buffer(40, 0)
    NumPut("UInt", 40, mi, 0)
    if !DllCall("user32\GetMonitorInfoW", "Ptr", hMon, "Ptr", mi.Ptr)
        return false
    return (NumGet(mi, 36, "UInt") & 1)    ; dwFlags & MONITORINFOF_PRIMARY
}

; Ativa a janela mais alta (ordem Z) do MONITOR PRINCIPAL na área 'idx'.
; Se não houver nenhuma no principal, não faz nada (comportamento nativo).
FocusPrimaryMonitorWindow(idx) {
    global kFocusPrimaryMonitor
    if !kFocusPrimaryMonitor
        return
    if !VdaFunc("GetWindowDesktopNumber")
        return
    ; WinGetList retorna em ordem Z (a primeira é a mais alta)
    for hwnd in WinGetList() {
        if !DllCall("IsWindowVisible", "ptr", hwnd, "int")
            continue
        try title := WinGetTitle("ahk_id " hwnd)
        catch
            continue
        if (title = "")
            continue
        try exStyle := WinGetExStyle("ahk_id " hwnd)
        catch
            continue
        if (exStyle & 0x00000080)      ; WS_EX_TOOLWINDOW
            continue
        try cls := WinGetClass("ahk_id " hwnd)
        catch
            continue
        if (cls = "Progman" || cls = "WorkerW"
            || cls = "Shell_TrayWnd" || cls = "Shell_SecondaryTrayWnd"
            || cls = "NotifyIconOverflowWindow")
            continue
        if (GetWindowDesktopNumber(hwnd) != idx)
            continue
        if !IsWindowOnPrimaryMonitor(hwnd)
            continue
        ; achou a janela mais alta do monitor principal nesta área -> ativa
        try WinActivate("ahk_id " hwnd)
        return
    }
    ; nenhuma janela no monitor principal -> mantém o comportamento nativo
}

; ------------------------------------------------------------
; Lógica principal
; ------------------------------------------------------------
EnsureDesktopIndex(idx) {                 ; garante áreas até o índice (0-based), nomeando as novas
    while (GetDesktopCount() <= idx)
        CreateNamedDesktop()
}

NeighborIndex(dir) {
    count := GetDesktopCount()
    curr  := GetCurrentDesktopNumber()    ; 0-based
    target := curr + dir
    if (kWrapDesktops)
        return Mod(target + count, count)
    if (target < 0)
        return 0
    if (target >= count) {
        EnsureDesktopIndex(target)
        count := GetDesktopCount()
        if (target >= count)
            target := count - 1
    }
    return target
}

; (1) Move a janela ativa para a área vizinha e segue junto.
MoveActiveNeighbor(dir) {
    hwnd := WinExist("A")
    if !hwnd
        return
    target := NeighborIndex(dir)
    MoveWindowToDesktopNumber(hwnd, target)
    GoToDesktopSilently(target)           ; sem 'from' -> não tenta remover origem aqui
}

; (3) Navegação Win+Alt+Seta; na última área, a seta p/ direita CRIA (e nomeia) uma nova.
;     Ao sair, se a área atual estiver VAZIA, ela é removida (remoção dinâmica).
SwitchDesktop(dir) {
    count := GetDesktopCount()
    curr  := GetCurrentDesktopNumber()
    if (dir < 0) {
        if (curr > 0)                    ; esquerda: vai para a anterior (trava na primeira)
            GoToDesktopSilently(curr - 1, curr)
        return
    }
    if (curr < count - 1) {              ; direita: se houver área à frente, apenas navega
        GoToDesktopSilently(curr + 1, curr)
    } else {                             ; está na última -> cria uma nova e vai para ela
        newIdx := CreateNamedDesktop()
        GoToDesktopSilently(newIdx, curr)
    }
}

; ------------------------------------------------------------
; Atalhos   ( ^ Ctrl   + Shift   ! Alt   # Win )
; ------------------------------------------------------------
; (1)+(2) Ctrl+Shift+Alt+Seta -> move a janela ativa (cria área nomeada sob demanda)
^+!Left::MoveActiveNeighbor(-1)
^+!Up::MoveActiveNeighbor(-1)
^+!Right::MoveActiveNeighbor(1)
^+!Down::MoveActiveNeighbor(1)

; (3) Win+Alt+Seta -> navega entre as áreas (estilo Linux); direita no fim cria uma nova.
#!Left::SwitchDesktop(-1)
#!Right::SwitchDesktop(1)
