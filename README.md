# my-agent-skills

Este repositório é um catálogo portátil de skills de agente e assistentes de instalação para fluxos de trabalho de configuração e restauração local.

Ele foi projetado para ajudar usuários a instalar e gerenciar skills de forma reproduzível, mantendo uma política conservadora em relação à procedência, licenciamento e direitos de redistribuição de materiais de terceiros.

## O que este projeto faz

- Cataloga skills e recursos de apoio;
- Registra a origem, caminho e procedência (SHA-256) no arquivo `skills-manifest.json`;
- Mantém um caminho de restauração local para o conteúdo de skills aprovadas;
- Verifica o manifesto e a integridade das cópias de skills empacotadas;
- Bloqueia por padrão a redistribuição pública insegura até que uma revisão humana confirme os direitos.

## Público-alvo

Este projeto destina-se a usuários e operadores que desejam:

- Restaurar um catálogo de skills local em uma nova máquina;
- Manter um ambiente de skills reproduzível;
- Revisar a procedência e o licenciamento antes da publicação;
- Gerenciar instalações locais sem assumir que o conteúdo externo é livremente redistribuível.

## Plataformas suportadas

### Windows
Suportado.

### macOS
Não suportado atualmente / experimental.

### Linux
Não suportado atualmente / experimental.

## Estrutura do repositório

- `skills/` — Snapshots de skills e arquivos relacionados;
- `skills-manifest.json` — Metadados de procedência, origem, hash e redistribuição por skill;
- `legal-and-docs/` - Documentação legal, de conformidade e auxiliar.
- `setup.ps1` — Ponto de entrada para restauração e instalação;
- `restore.ps1` — Fluxo de trabalho de restauração local;

## Conteúdo de terceiros

Este repositório pode referenciar ou redistribuir skills criadas por terceiros.

O conteúdo de terceiros NÃO é automaticamente coberto pela licença deste repositório.

Cada componente de terceiro permanece sujeito à sua licença e termos originais.

Consulte `legal-and-docs/THIRD-PARTY-NOTICES.md` e `skills-manifest.json`.

## Postura de auditoria atual

O manifesto contém atualmente:

- 52 entradas com origem upstream verificada e evidência Apache-2.0, registradas como
  `allowed_with_conditions`;
- 1 snapshot local ainda marcado como `review_required` / `unknown`.

As 52 entradas condicionais permanecem bloqueadas por padrão porque a redistribuição
exige a preservação da licença Apache, avisos de direitos autorais e quaisquer
avisos específicos do plugin ou de dependência. O snapshot local não tem evidência
de licença reproduzível e não deve ser publicado como conteúdo próprio do projeto.

Consulte `legal-and-docs/third-party-notices/` para a licença Apache e os avisos preservados.

## Instalação

1. Revise este README e os avisos de licenciamento.
2. Rode o script de verificação antes de instalar ou publicar:

```powershell
.\legal-and-docs\scripts\verify.ps1
```

3. Use autorização explícita apenas para restauração local:

```powershell
.\setup.ps1 -Authorize -WhatIf
.\setup.ps1 -Authorize
```

Entradas condicionais ou não verificadas são intencionalmente puladas, a menos que
`-AllowLocalReference` seja explicitamente solicitado. Essa opção permite o uso
de referência local apenas; ela não concede permissão para redistribuir o conteúdo.

## Verificação e atualização

O repositório inclui verificações de segurança para a integridade do manifesto, presença de arquivos e status de procedência:

```powershell
.\legal-and-docs\scripts\list.ps1
.\legal-and-docs\scripts\doctor.ps1
.\legal-and-docs\scripts\verify.ps1
.\legal-and-docs\scripts\update.ps1
```

## Contribuição

Por favor, não contribua ou publique conteúdo cuja origem, licença ou
direitos de redistribuição não sejam claros. Se uma skill ou recurso não foi
explicitamente revisado, mantenha-o fora da redistribuição pública.

Leia [`legal-and-docs/CONTRIBUTING.md`](CONTRIBUTING.md) antes de abrir um pull request. Cada
nova skill empacotada requer metadados de procedência, licença, atribuição,
redistribuição e integridade no `skills-manifest.json`.

A sequência de governança atual é:

1. Concluir a auditoria e apresentar o relatório para aprovação humana;
2. Aplicar quaisquer remoções ou alterações de metadados aprovadas;
3. Executar `.\legal-and-docs\scripts\verify.ps1`;
4. Revisar o diff e o changelog;
5. Fazer o commit e abrir o pull request final somente após a aprovação.

Nenhuma restauração, commit, publicação ou pull request automatizado sobrepõe essas
barreiras.

Consulte [`legal-and-docs/CHANGELOG.md`](CHANGELOG.md) para o histórico de alterações do repositório.

## Licenciamento

O conteúdo original deste repositório é coberto pela `LICENSE` em `legal-and-docs/`, a menos que outro arquivo ou aviso indique o contrário.

O conteúdo de terceiros permanece sujeito à sua licença original e requisitos de aviso.

## Segurança

Este repositório segue uma postura de segurança conservadora para scripts, plugins e conteúdo externo. Consulte `legal-and-docs/SECURITY.md`.

## Limitações

- Algumas skills empacotadas podem ser apenas referências locais, não cópias redistribuíveis publicamente;
- Nem toda skill de terceiro no catálogo tem uma licença de redistribuição confirmada;
- As funcionalidades de instalação e restauração não anulam as condições da licença de origem.

## Suporte

Este repositório é mantido como um catálogo e assistente de configuração com foco em segurança. O suporte é limitado a verificações de procedência, restauração e saúde da instalação, não à liberação legal para redistribuição.
