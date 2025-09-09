# 📊 Aula 05 – Visualização no Kibana

Nesta etapa vamos transformar os dados de infraestrutura em **dashboards visuais** dentro do Kibana.  
A ideia é sair da “lista de documentos” e enxergar padrões, gargalos e insights de forma visual.

---

## 🚀 Passos

### 1. Acesse o Kibana
Abra [http://localhost:5601](http://localhost:5601) no navegador.

---

### 2. Criar Data View
- Vá em **Management → Stack Management → Data Views**.  
- Verifique se já existe um Data View para o índice `infra-hosts`.  
- Caso não exista, crie um novo Data View com o padrão `infra-hosts*`.  

---

### 3. Criar visualizações

#### 🥧 Pizza: quantidade de hosts por status
- Vá em **Visualize Library → Create visualization → Lens**.  
- Arraste `status` para *Slices*.  
- Ajuste as cores:  
  - Verde → `online`  
  - Amarelo → `warning`  
  - Vermelho → `offline`  
- Renomeie o título para **Distribuição de Hosts por Status**.

#### 📊 Barras: uso médio de CPU por serviço
- Escolha **Bar Vertical**.  
- Arraste `servico` para eixo X.  
- Arraste `cpu` e selecione *Average*.  
- Renomeie o título para **CPU Médio por Serviço**.  
- Esse gráfico mostra quais serviços consomem mais CPU.

#### 📋 Tabela: top 10 hosts com maior uso de memória
- Escolha **Tabela**.  
- Adicione colunas: `host`, `servico`, `status`, `cpu`, `memoria`.  
- Ordene por `memoria` desc.  
- Limite para **Top 10**.  
- Renomeie o título para **Top 10 Hosts – Memória**.  
- Útil para identificar máquinas mais críticas.

#### 📈 Linha do tempo: @timestamp vs uso de CPU
- Escolha **Linha do tempo (Line)**.  
- Eixo X → `@timestamp` (usar agregação por minuto ou hora).  
- Eixo Y → `cpu` (média).  
- Renomeie o título para **Uso de CPU ao Longo do Tempo**.  
- Esse gráfico revela **picos e tendências**, ótimo para correlação com incidentes.

---

### 4. Montar o Dashboard
- Vá em **Dashboard → Create new Dashboard**.  
- Adicione as 4 visualizações criadas.  
- Ajuste o layout de forma legível.  
- Salve como **infra-overview-20250802**.  

---

## 💡 Dicas Extras (Up Bonus)

- **Filtros globais:** adicione um filtro `status: warning` ou `status: offline` para focar em críticos.  
- **Intervalo de tempo:** configure o *Time Filter* para **Agosto/2025**.  
- **Legibilidade:** converta CPU e memória para porcentagem (%) com 2 casas decimais.  
- **Exportar:** baixe o dashboard em **PDF** ou **PNG** para compartilhar com o time.  
- **Reutilização:** esses dashboards podem servir como base para monitoramento de um SOC ou NOC.  

---

## ✅ Conclusão

Com esses gráficos, conseguimos sair da visão bruta de documentos e enxergar:  
- **Saúde geral** (status)  
- **Gargalos por serviço** (CPU)  
- **Hosts críticos** (memória)  
- **Tendências no tempo** (linha do tempo de CPU)  

👉 Agora seu ambiente já tem um **painel de observabilidade inicial**.  
Na próxima etapa, vamos evoluir com desafios práticos e cenários avançados.

Conectou, buscou e achou 🚀

