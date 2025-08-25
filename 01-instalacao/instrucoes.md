# 📥 Etapa 01 – Instalação do Elasticsearch e Kibana

Nesta primeira etapa vamos preparar o ambiente para usar o **Elasticsearch na Prática**.  
Você aprenderá a instalar os pré-requisitos, subir os containers e validar que tudo está funcionando.

---

## 📦 Pré-requisitos

### 1. Instalar **Docker**
O Docker é necessário para rodar o Elasticsearch e o Kibana em containers.

- **Windows**
  - Baixe o [Docker Desktop](https://www.docker.com/products/docker-desktop).
  - Ative o **WSL 2** durante a instalação.
  - Após instalar, abra o Docker Desktop e confirme que ele está rodando.
  - Teste no terminal (PowerShell ou Git Bash):
    ```bash
    docker --version
    ```

- **Linux (Ubuntu/Debian)**
  ```bash
  sudo apt update
  sudo apt install -y docker.io docker-compose
  sudo systemctl enable --now docker
  docker --version
  ```
  Obs: em alguns sistemas pode ser necessário adicionar seu usuário ao grupo `docker`:
  ```bash
  sudo usermod -aG docker $USER
  ```

---

### 2. Instalar **Git**
O Git será usado para clonar o repositório oficial do curso.

- **Windows**
  - Baixe o [Git for Windows](https://git-scm.com/download/win).
  - Ele já vem com o **Git Bash**, que permite rodar comandos estilo Linux.
  - Teste a instalação:
    ```bash
    git --version
    ```

- **Linux (Ubuntu/Debian)**
  ```bash
  sudo apt update
  sudo apt install -y git
  git --version
  ```

---

### 3. Testar se tudo está pronto
No terminal, rode:
```bash
docker --version
docker compose version
git --version
```

Se os três comandos funcionarem, você está pronto para começar.

---

## 🚀 Subir o ambiente com Docker

Na pasta `01-instalacao/`, existe o arquivo `docker-compose.yml`. Ele define os serviços:
- `elasticsearch`: banco de dados de busca e análise.
- `kibana`: interface gráfica para visualizar dados.

Execute:
```bash
docker compose up -d
```

Isso iniciará os containers em background.

---

## 🔎 Validar a instalação

- Acesse o Elasticsearch no terminal:
```bash
curl http://localhost:9200
```

- Acesse o Kibana no navegador:  
👉 [http://localhost:5601](http://localhost:5601)

- Veja a saúde do cluster no Dev Tools:
```json
GET _cluster/health
```

---

## ⚠️ Erros comuns

1. **Porta 9200 já usada** → feche outros processos que usem essa porta.  
2. **Docker com pouca memória** → ajuste no Docker Desktop para alocar pelo menos 2GB de RAM.  
3. **Confundir `docker-compose` e `docker compose`** → versões recentes usam `docker compose`.  

---

## 🧪 Exercício rápido

1. Crie um índice de teste:
```json
PUT teste
{ "mappings": { "properties": { "campo": { "type": "keyword" } } } }
```

2. Liste os índices existentes:
```json
GET _cat/indices?v
```

3. Verifique a saúde do cluster:
```json
GET _cluster/health
```

---

## ✅ Encerramento

Parabéns! 🎉 Você já subiu seu primeiro cluster Elasticsearch + Kibana e confirmou que está funcionando.  
Na próxima aula, vamos **indexar dados de infraestrutura** simulados.

**Conectou, buscou e achou.**
