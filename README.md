# Modelagem dimensional com dbt e BigQuery — Execução orçamentária federal

Projeto dbt que transforma a tabela plana de execução orçamentária (Portal da Transparência, agosto/2026) em um **modelo estrela documentado e testado** no BigQuery. É a evolução do projeto [análise de execução orçamentária](https://github.com/Ochion/analise-execucao-orcamentaria-portal-transparencia).

## Contexto
A base tratada em Python tinha 205.378 empenhos em uma única tabela de 15 colunas. Funciona para um dashboard, mas mistura descrição e medidas, repete textos em cada linha e não tem regras de qualidade versionadas.

## Ação
1. **Staging:** limpeza e tipagem da tabela de origem (textos vazios viram "Não informado", valores ausentes viram 0) e criação das chaves das dimensões com hash MD5.
2. **Marts:** modelo estrela com uma fato e cinco dimensões.
3. **Testes:** unicidade e não nulidade das chaves, integridade referencial entre fato e dimensões, valores aceitos na situação da execução e dois testes singulares de reconciliação (contagem de linhas e total pago entre staging e fato).
4. **Documentação:** descrição de todos os modelos e colunas em YAML e site de documentação com o grafo de linhagem (`dbt docs`).

## Modelo

```mermaid
erDiagram
    fct_execucao }o--|| dim_data : data_key
    fct_execucao }o--|| dim_orgao : orgao_key
    fct_execucao }o--|| dim_favorecido : favorecido_key
    fct_execucao }o--|| dim_despesa : despesa_key
    fct_execucao }o--|| dim_situacao : situacao_key
    fct_execucao {
        string codigo_empenho PK
        numeric valor_original_empenho
        numeric valor_liquidado
        numeric valor_pago
        float percentual_liquidado
        float percentual_pago
    }
    dim_orgao { string orgao_key PK }
    dim_favorecido { string favorecido_key PK }
    dim_despesa { string despesa_key PK }
    dim_situacao { string situacao_key PK }
    dim_data { int data_key PK }
```

**Grão da fato:** um registro por empenho.

## Resultado
<!-- Preencha com os números reais depois de rodar `dbt build`. -->
- Modelos criados: 1 staging, 1 fato e 5 dimensões.
- Testes executados: `__` aprovados, `__` com aviso, `__` falhas.
- Linhas na fato: `__` (igual à staging).

## Como executar
```bash
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
gcloud auth application-default login
# copie profiles.yml.example para ~/.dbt/profiles.yml e ajuste
dbt debug
dbt build
dbt docs generate
dbt docs serve
```

## Stack
dbt Core, BigQuery, SQL, Git.
