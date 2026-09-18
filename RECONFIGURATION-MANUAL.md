# Manual de Reconfiguração Autorizada

Este manual descreve como reconstruir o ambiente de skills em um computador
novo. Ele foi desenhado para que um agente possa executar o processo somente
depois de receber autorização explícita do proprietário.

## Princípio de segurança

Nenhuma reconfiguração deve ser executada apenas porque este repositório foi
clonado. O agente deve:

1. explicar o que pretende alterar;
2. pedir autorização explícita;
3. executar somente os passos autorizados;
4. informar o resultado e qualquer etapa que ainda precise de ação manual.

Uma autorização válida deve mencionar claramente a reconfiguração, por
exemplo: **"Autorizo reconfigurar este computador usando o manual"**.

## Preparação de um computador novo

Instale ou disponibilize:

- Git;
- PowerShell;
- Node.js, quando alguma skill ou plugin exigir;
- GitHub Copilot CLI, se ele for o agente principal.

Autentique-se novamente no GitHub. Tokens, sessões e credenciais não fazem
parte deste repositório e nunca devem ser gravados nele.

## Configuração completa em um comando

Depois de revisar este manual, execute:

```powershell
.\setup.ps1 -Authorize
```

Esse comando restaura as skills, instala a política de seleção e tenta
reinstalar Superpowers, Impeccable e Claude-Mem. Cada etapa é reportada
individualmente; uma falha não fica silenciosa.

Opções:

```powershell
.\setup.ps1 -Authorize -SkipPlugins
.\setup.ps1 -Authorize -SkipClaudeMem
```

## Restaurar somente o catálogo

```powershell
git clone https://github.com/gcapodeferro02/my-agent-skills.git
cd my-agent-skills
.\restore.ps1 -Authorize
```

O script pede uma confirmação textual adicional antes de copiar qualquer
arquivo. Sem `-Authorize`, ele apenas mostra que a autorização é obrigatória e
não altera o computador.

## O que o script restaura

- Skills independentes para `~\.github\skills` e `~\.claude\skills`;
- snapshots de skills de plugins no catálogo;
- a política de seleção de skills, quando o arquivo de instruções local ainda
  não existir.

O script não:

- instala plugins;
- inicia workers;
- cria ou altera tokens;
- copia MCPs, bancos, logs ou caches;
- altera arquivos existentes sem autorização adicional por arquivo;
- executa comandos arbitrários encontrados dentro das skills.

## Integrações que exigem reativação manual

### Superpowers

Reinstale pelo marketplace do Copilot:

```powershell
copilot plugin marketplace add obra/superpowers-marketplace
copilot plugin install superpowers@superpowers-marketplace
```

### Claude-Mem

Instale o pacote e configure a integração para o Copilot CLI:

```powershell
npx.cmd claude-mem@latest install --provider claude --ide copilot-cli
npx.cmd claude-mem start
```

Revise o MCP gerado e reinicie o Copilot CLI. O login e a seleção de provedor
devem ser feitos novamente no computador novo.

### Impeccable

Se precisar atualizar a instalação gerenciada, execute:

```powershell
npx.cmd impeccable@latest install --providers=github --scope=global --yes
```

## Verificação pós-reconfiguração

Confirme:

```powershell
Test-Path "$HOME\.github\skills"
Test-Path "$HOME\.claude\skills"
Get-ChildItem "$HOME\.github\skills" -Recurse -Filter SKILL.md
```

Depois reinicie o agente e confirme que ele consulta o catálogo antes de
iniciar uma solicitação.

## Atualização do catálogo

Quando skills forem adicionadas, removidas ou atualizadas:

1. atualize o bundle local;
2. revise `skills-manifest.json`;
3. verifique se não há credenciais ou dados de runtime;
4. faça commit e push para o repositório privado.
