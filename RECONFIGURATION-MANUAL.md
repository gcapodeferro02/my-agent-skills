# Manual de Reconfiguração Autorizada

Este manual explica como reconstruir o ambiente de skills em um computador
novo. O processo foi preparado para ser executado com um único comando, mas
sempre exige autorização explícita.

## Regra de segurança

O agente não deve reconfigurar o computador apenas porque encontrou este
repositório. Antes de executar o instalador, ele deve:

1. explicar as etapas que serão executadas;
2. pedir autorização explícita;
3. executar somente o escopo autorizado;
4. informar o resultado de cada etapa.

O comando principal é:

```powershell
.\setup.ps1 -Authorize
```

O script pedirá uma confirmação textual adicional. Digite:

```text
I AUTHORIZE RECONFIGURATION
```

Sem essa confirmação, nada será alterado.

## Passo a passo completo

### 1. Preparar o computador

Instale:

- Git;
- PowerShell;
- Node.js 20 ou superior;
- GitHub Copilot CLI.

Abra um novo PowerShell depois das instalações para atualizar o `PATH`.

### 2. Autenticar

Faça login no GitHub e nos serviços que serão usados. Tokens, sessões, bancos,
logs e credenciais não são armazenados no catálogo.

### 3. Clonar ou atualizar

Para uma instalação nova:

```powershell
cd $HOME
git clone https://github.com/gcapodeferro02/my-agent-skills.git
cd my-agent-skills
```

Para atualizar uma cópia existente:

```powershell
cd "$HOME\my-agent-skills"
git pull
```

### 4. Conferir antes de alterar

```powershell
.\setup.ps1 -Authorize -WhatIf
```

Esse modo apenas lista as etapas e não instala nada.

### 5. Executar a configuração completa

```powershell
.\setup.ps1 -Authorize
```

O instalador restaura as skills, configura a política de seleção e tenta
reinstalar o Superpowers, o Impeccable e o Claude-Mem.

### 6. Reiniciar e verificar

Reinicie o Copilot CLI e confirme:

```powershell
Get-ChildItem "$HOME\.github\skills" -Recurse -Filter SKILL.md
copilot plugin list
Invoke-WebRequest http://127.0.0.1:37777 -UseBasicParsing
```

## O que é restaurado

- Skills independentes em `~\.github\skills` e `~\.claude\skills`;
- snapshots das skills dos plugins presentes no catálogo;
- política de seleção no arquivo de instruções do Copilot, se ainda não existir;
- plugins e runtimes suportados pelo `setup.ps1`.

## O que não é restaurado automaticamente

- tokens, senhas e sessões;
- bancos de dados, logs e caches;
- credenciais do GitHub ou de outros provedores;
- dados históricos do Claude-Mem;
- configurações específicas de outros sistemas operacionais;
- scripts arbitrários encontrados dentro das skills.

## Pular partes da instalação

Se algum componente já estiver configurado:

```powershell
.\setup.ps1 -Authorize -SkipPlugins
.\setup.ps1 -Authorize -SkipClaudeMem
```

É possível combinar as opções:

```powershell
.\setup.ps1 -Authorize -SkipPlugins -SkipClaudeMem
```

## Instalação manual de integrações

### Superpowers

```powershell
copilot plugin marketplace add obra/superpowers-marketplace
copilot plugin install superpowers@superpowers-marketplace
```

### Impeccable

```powershell
npx.cmd impeccable@latest install --providers=github --scope=global --yes
```

### Claude-Mem

```powershell
npx.cmd claude-mem@latest install --provider claude --ide copilot-cli
npx.cmd claude-mem start
```

Revise o MCP gerado e reinicie o Copilot CLI. O login e a seleção de provedor
devem ser feitos novamente no computador novo.

## Problemas comuns

### Dependência ausente

Se o instalador indicar que Git, Node.js, `npx` ou Copilot CLI não foi
encontrado, instale o componente indicado, abra um novo PowerShell e execute o
comando novamente.

### Claude-Mem sem resposta

```powershell
npx.cmd claude-mem start
Invoke-WebRequest http://127.0.0.1:37777 -UseBasicParsing
```

### Repositório privado sem acesso

Autentique-se no GitHub com uma conta que tenha acesso a
`gcapodeferro02/my-agent-skills` e repita o `git clone` ou `git pull`.
