# Meu Catálogo de Skills

Repositório privado com uma cópia portátil das skills e das configurações
necessárias para reconstruir meu ambiente de IA em outro computador.

**Repositório:** <https://github.com/gcapodeferro02/my-agent-skills>

## O que está incluído

- `skills/` — skills e arquivos auxiliares catalogados.
- `skills-manifest.json` — origem, caminho e hash SHA-256 de cada `SKILL.md`.
- `SKILL-SELECTION-POLICY.md` — regra para escolher a melhor skill antes de
  iniciar cada solicitação.
- `RECONFIGURATION-MANUAL.md` — manual completo de configuração.
- `setup.ps1` — instalação completa em um comando.
- `configure.ps1` — restauração protegida do catálogo.
- `restore.ps1` — cópia das skills para os diretórios locais.

Caches, logs, bancos de dados, tokens, sessões e credenciais são excluídos
intencionalmente.

## Configuração em um computador novo

### 1. Instale os pré-requisitos

No computador novo, instale:

- Git;
- PowerShell;
- Node.js (inclui `npm` e `npx`);
- GitHub Copilot CLI, se ele for o agente que você pretende usar.

Depois, autentique-se novamente no GitHub. O token nunca é armazenado neste
repositório.

### 2. Baixe o catálogo

Abra o PowerShell e execute:

```powershell
cd $HOME
git clone https://github.com/gcapodeferro02/my-agent-skills.git
cd my-agent-skills
```

Se o repositório já existir localmente e você quiser atualizá-lo:

```powershell
cd "$HOME\my-agent-skills"
git pull
```

### 3. Faça a configuração completa

Revise o que será feito e execute:

```powershell
.\setup.ps1 -Authorize
```

Quando solicitado, digite exatamente:

```text
I AUTHORIZE RECONFIGURATION
```

O instalador irá:

1. restaurar as skills;
2. configurar a política de seleção automática;
3. instalar o Superpowers;
4. instalar o Impeccable;
5. instalar e iniciar o Claude-Mem;
6. mostrar um resumo de sucesso e falha.

Ao terminar, reinicie o Copilot CLI.

### 4. Verifique a instalação

```powershell
Test-Path "$HOME\.github\skills"
Test-Path "$HOME\.claude\skills"
Get-ChildItem "$HOME\.github\skills" -Recurse -Filter SKILL.md
copilot plugin list
```

Também confirme que o worker do Claude-Mem responde:

```powershell
Invoke-WebRequest http://127.0.0.1:37777 -UseBasicParsing
```

### 5. Faça login nos serviços novamente

Em um computador novo, será necessário autenticar novamente os serviços que
exigem conta. O catálogo não transporta credenciais por segurança.

## Opções

Simular as etapas sem alterar o computador:

```powershell
.\setup.ps1 -Authorize -WhatIf
```

Restaurar somente os arquivos das skills:

```powershell
.\restore.ps1 -Authorize
```

Pular a instalação de plugins:

```powershell
.\setup.ps1 -Authorize -SkipPlugins
```

Pular o Claude-Mem:

```powershell
.\setup.ps1 -Authorize -SkipClaudeMem
```

## Solução de problemas

### `git` não encontrado

Instale o Git e abra um novo PowerShell.

### `npx` ou Node.js não encontrado

Instale o Node.js e abra um novo PowerShell.

### Copilot CLI não encontrado

Instale o GitHub Copilot CLI e execute novamente com:

```powershell
.\setup.ps1 -Authorize
```

### O Claude-Mem não iniciou

Execute manualmente:

```powershell
npx.cmd claude-mem start
```

Depois reinicie o Copilot CLI.

## Atualizar o catálogo

Quando uma skill for adicionada ou atualizada:

1. atualize os arquivos locais;
2. revise `skills-manifest.json`;
3. confirme que não há segredos ou dados de runtime;
4. faça commit e push:

```powershell
git add .
git commit -m "Atualiza catálogo de skills"
git push
```

Para o manual detalhado e as regras de autorização, consulte
`RECONFIGURATION-MANUAL.md`.
