# 📊 Aula 05 – Visualização no Kibana

Nesta etapa vamos transformar os dados de infraestrutura em **dashboards visuais** dentro do Kibana.  
A ideia é sair da “lista de documentos” e passar a enxergar padrões, gargalos e insights de forma clara, rápida e visual.  
Dashboards contam uma história: mostram saúde geral, gargalos por serviço, quem são os críticos e como tudo evolui no tempo.

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
- Ajuste as cores: verde → online, amarelo → warning, vermelho → offline.  
- Renomeie o título para **Distribuição de Hosts por Status**.  

💡 Insight: ótimo para uma visão geral rápida da saúde dos hosts.

#### 📊 Barras: uso médio de CPU por serviço
- Escolha **Bar Vertical**.  
- Arraste `servico` para eixo X.  
- Arraste `cpu` e selecione *Average*.  
- Renomeie o título para **CPU Médio por Serviço**.  

💡 Insight: ajuda a identificar gargalos de consumo de CPU por serviço (ex: database vs webserver).

#### 📋 Tabela: top 10 hosts com maior uso de memória
- Escolha **Tabela**.  
- Adicione colunas: `host`, `servico`, `status`, `cpu`, `memoria`.  
- Ordene por `memoria` desc.  
- Limite para **Top 10**.  
- Renomeie o título para **Top 10 Hosts – Memória**.  

💡 Insight: ranking prático para identificar máquinas críticas.

#### 📈 Linha do tempo: @timestamp vs uso de CPU
- Escolha **Linha do tempo (Line)**.  
- Eixo X → `@timestamp` (usar agregação por minuto ou hora).  
- Eixo Y → `cpu` (média).  
- Renomeie o título para **Uso de CPU ao Longo do Tempo**.  

💡 Insight: revela picos e tendências, útil para correlação com incidentes.

---

### 4. Montar o Dashboard
- Vá em **Dashboard → Create new Dashboard**.  
- Adicione as 4 visualizações criadas.  
- Ajuste o layout de forma legível.  
- Salve como **infra-overview-20250802**.  

---

## 💡 Dicas Extras (Up Bonus)

- **Filtros globais:** foque apenas em críticos (`status: warning` ou `offline`).  
- **Intervalo de tempo:** configure o *Time Filter* para Agosto/2025.  
- **Legibilidade:** CPU e memória como porcentagem (%) com 2 casas decimais.  
- **Exportar:** gere PDF/PNG para relatórios executivos.  
- **Reutilização:** dashboards podem ser base para SOCs, NOCs ou relatórios de negócio.

---

## ✅ Conclusão

Com esses gráficos, conseguimos sair da visão bruta de documentos e enxergar:  
- **Saúde geral** (status)  
- **Gargalos por serviço** (CPU)  
- **Hosts críticos** (memória)  
- **Tendências no tempo** (linha do tempo de CPU)  

👉 Agora você tem um **painel inicial de observabilidade** que pode ser evoluído.  
Na próxima etapa, vamos avançar com desafios práticos e cenários mais complexos.

**Conectou, buscou e achou 🚀**
