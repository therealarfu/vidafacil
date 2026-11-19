# VidaFácil

Protótipo acadêmico funcional de organização financeira para MEIs. React + TypeScript + Vite, com processamento local de Excel e CSV, revisão, gráficos e relatório automático. Não exige cadastro, backend, banco de dados ou API de IA.

## Executar

Requer Node.js 22 ou superior e npm. Na pasta deste projeto:

```powershell
npm install
npm run dev
```

Abra o endereço indicado no terminal (normalmente http://127.0.0.1:5173). No Windows, também é possível dar dois cliques em `Iniciar VidaFacil.cmd`. Depois da instalação, o fluxo funciona sem internet: todas as bibliotecas e fontes utilizadas ficam locais. Mantenha o terminal aberto enquanto usa o site.

```powershell
npm test         # testes de importação e cálculos
npm run build   # verificação TypeScript e versão de produção
npm run preview # servir a versão compilada
```

## Demonstração em sala

1. Na página inicial, escolha **Experimentar com dados de exemplo**.
2. Confira os 19 registros. São 18 realizados e 1 previsto. Os valores são fictícios.
3. Gere o relatório: entradas de **R$ 4.380,00**, saídas de **R$ 1.600,00**, saldo das movimentações de **R$ 2.780,00**. O compromisso de R$ 160,00 não integra o saldo realizado.
4. Filtre natureza, categoria ou período. Edite um registro e veja a mudança nos indicadores.
5. Exporte PDF, CSV ou use a impressão.

Para demonstrar importação, use `exemplos/VidaFacil-demonstracao.xlsx` ou `.csv`. `duas-abas.xlsx` e `.xls` contêm uma aba de instruções e uma aba **Dados**, com crédito e débito separados. `revisao-pendencias.csv` mostra erros de data, valor e tipo que exigem correção. `VidaFacil-modelo.xlsx` tem uma estrutura simples para preenchimento. Há também um PDF gerado pelo mesmo código do aplicativo.

## Funcionalidades

- Upload real por seleção ou arrastar e soltar, XLSX/XLS/CSV, limite de 10 MB e 10.000 registros por aba.
- Seleção da aba e da linha de cabeçalho, detecção dos títulos e mapeamento manual.
- Normalização de datas brasileiras/ISO/seriais Excel, valores brasileiros e decimais, negativos, crédito e débito separados.
- Revisão editável de data, descrição, valor, tipo, categoria, natureza, situação e vencimento. Exclusão reversível, busca e paginação.
- Dados originais preservados na opção **Ver original**. Linhas inválidas não são descartadas. Apenas linhas completamente vazias são removidas.
- Categorias sugeridas por regras simples, com aviso. Natureza não identificada permanece pendente de classificação, sem presumir que seja do negócio.
- Indicadores e gráficos de entradas/saídas mensais, despesas por categoria, saldo acumulado diário e pessoal/negócio.
- Filtros compartilhados pelos indicadores, gráficos, texto do relatório, tabela e exportações.
- Relatório determinístico com resumo, concentração de gastos, meses deficitários, pendências e compromissos explicitamente previstos.
- PDF paginado com indicadores, gráficos e explicações; CSV organizado com proteção contra fórmulas; impressão com CSS próprio.
- Interface responsiva e navegação em português.
- Limpeza dos dados da sessão. Não utiliza localStorage, analytics ou serviços externos.

## Regras e limites

- Cálculos usam centavos inteiros. Saldo = entradas realizadas menos saídas realizadas. Não é lucro, não inclui saldo inicial, estoques, depreciação nem apuração fiscal.
- Data com barras é interpretada como dia/mês/ano. Datas impossíveis exigem correção. Datas somente com ano de dois dígitos não são inferidas.
- Valor textual `1.234` é ambíguo e exige correção. Use `1234,00`, `1.234,00` ou `1234.00`.
- Valores positivos sem tipo exigem classificação ou confirmação explícita da convenção de sinais na importação. Colunas de crédito/débito têm prioridade sobre valor único.
- Quando não existe coluna de situação, registros passados são tratados como realizados. Vencimento futuro sem situação exige confirmação. Data futura é proposta como prevista. Confira sempre a revisão.
- Apenas registros válidos e não excluídos podem seguir para o relatório. Previsto fica fora dos indicadores de realizado. O filtro de período usa a data do registro, inclusive para compromissos.
- Fórmulas Excel usam o valor previamente calculado e salvo no arquivo; o app não recalcula fórmulas, executa macros ou interpreta imagens. Salve a planilha recalculada antes da importação.
- Uma aba por análise. Importar outra planilha substitui a sessão atual; não há mesclagem automática, deduplicação ou histórico persistente entre visitas.
- O relatório não faz previsões, diagnóstico financeiro nem apuração de lucro. Comparações mensais refletem apenas os dados disponíveis; não presume que um mês esteja completo.
- O protótipo não implementa bot WhatsApp, captura de áudio/foto, integração bancária ou aconselhamento por IA. A apresentação prevê essas etapas, mas este frontend implementa a parte web solicitada: planilha, revisão, análise e exportação.
- Fechar/recarregar a página remove os registros da memória. Exporte antes. Não substitui acompanhamento contábil profissional.

## Referência visual e decisões

Foram analisados os 45 slides de `VidaFacil_Apresentavel.pptx`, com atenção aos esboços dos slides 31–32 e ao fluxo dos slides 33–35. O painel preserva os agrupamentos de acompanhamento econômico, dados por período e gastos. Os esboços são monocromáticos: azul escuro, verde e tipografia derivam da apresentação. A marca tipográfica e o ícone de folha são uma adaptação para este protótipo, não um logotipo extraído dos slides. Os rótulos de lucro do esboço foram substituídos por saldo das movimentações, conforme o requisito financeiro do pedido.

## Organização

`src/components/Upload.tsx`: importação e mapeamento.
`src/components/Transactions.tsx`: revisão e classificação.
`src/components/Dashboard.tsx`: indicadores, gráficos, filtros e relatório.
`src/lib/parsers.ts`: leitura e normalização.
`src/lib/finance.ts`: cálculos e interpretação determinística.
`src/lib/exports.ts`: PDF, CSV e modelo Excel.
`src/data/demo.ts`: dados fictícios.
`src/types.ts`: contratos de dados.
`src/styles.css`: componentes visuais, responsividade e impressão.

As camadas de leitura, cálculo e relatório são separadas da interface para permitir futura API ou persistência com autenticação e consentimento. Uma integração de linguagem natural deve usar o resumo validado e manter as regras de cálculo determinísticas.

Documentação técnica consultada: [SheetJS: leitura](https://docs.sheetjs.com/docs/api/parse-options/), [SheetJS: datas](https://docs.sheetjs.com/docs/csf/features/dates/), [Papa Parse](https://www.papaparse.com/docs).
