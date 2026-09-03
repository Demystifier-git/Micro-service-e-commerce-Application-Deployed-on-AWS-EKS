sudo tee /usr/local/bin/load-secrets.sh > /dev/null <<'EOF'
#!/bin/bash
set -euo pipefail

REGION="us-east-1"

MYSQL_EXPORTER_SECRET_NAME="production/production/mysql_exporter/default-default"
GRAFANA_SECRET_NAME="production/production/grafana/default-default"

MYSQL_EXPORTER_SECRET=$(aws secretsmanager get-secret-value \
  --secret-id "$MYSQL_EXPORTER_SECRET_NAME" \
  --region "$REGION" \
  --query SecretString \
  --output text)

GRAFANA_SECRET=$(aws secretsmanager get-secret-value \
  --secret-id "$GRAFANA_SECRET_NAME" \
  --region "$REGION" \
  --query SecretString \
  --output text)

export MYSQL_EXPORTER_USER=$(echo "$MYSQL_EXPORTER_SECRET" | jq -r .username)
export MYSQL_EXPORTER_PASSWORD=$(echo "$MYSQL_EXPORTER_SECRET" | jq -r .password)
export DATA_SOURCE_NAME="${MYSQL_EXPORTER_USER}:${MYSQL_EXPORTER_PASSWORD}@mysql-db.ckxym2w48okb.us-east-1.rds.amazonaws.com/"

export GRAFANA_ADMIN_USER=$(echo "$GRAFANA_SECRET" | jq -r .username)
export GRAFANA_ADMIN_PASSWORD=$(echo "$GRAFANA_SECRET" | jq -r .password)

# Persist to /etc/environment
{
  echo "MYSQL_EXPORTER_USER=$MYSQL_EXPORTER_USER"
  echo "MYSQL_EXPORTER_PASSWORD=$MYSQL_EXPORTER_PASSWORD"
  echo "DATA_SOURCE_NAME=$DATA_SOURCE_NAME"
  echo "GRAFANA_ADMIN_USER=$GRAFANA_ADMIN_USER"
  echo "GRAFANA_ADMIN_PASSWORD=$GRAFANA_ADMIN_PASSWORD"
} | sudo tee /etc/environment > /dev/null
EOF

sudo chmod +x /usr/local/bin/load-secrets.sh

