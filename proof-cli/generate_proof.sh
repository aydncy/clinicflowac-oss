#!/bin/bash

echo "🔐 Generating workflow hash..."

sha256sum workflow.json | awk '{print $1}' > workflow_hash.txt
HASH=$(cat workflow_hash.txt)

echo "✍️ Requesting signature from OVWI..."

curl -s http://localhost:8080/api/v1/token/$HASH > signature.json

echo "📡 Fetching JWKS snapshot..."

curl -s http://localhost:8080/.well-known/jwks.json > jwks_snapshot.json

echo "📦 Building proof pack..."

rm -f proof_pack.zip
zip proof_pack.zip workflow.json workflow_hash.txt signature.json jwks_snapshot.json > /dev/null

echo "✅ Proof pack generated: proof_pack.zip"
