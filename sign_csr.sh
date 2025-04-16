#!/bin/bash

GREEN='\033[0;32m'
NC='\033[0m'
OUTPUT_DIR="output"

echo -e "${GREEN}=== ✍️  Sign CSR with RootCA ===${NC}"

# 1. รายการไฟล์ .csr ที่มีใน output/
CSR_FILES=($(ls "$OUTPUT_DIR"/*.csr 2>/dev/null))

if [ ${#CSR_FILES[@]} -eq 0 ]; then
  echo -e "${GREEN}❌ ไม่พบไฟล์ .csr ในโฟลเดอร์ $OUTPUT_DIR${NC}"
  exit 1
elif [ ${#CSR_FILES[@]} -eq 1 ]; then
  CSR_PATH="${CSR_FILES[0]}"
  echo -e "${GREEN}📄 ใช้ไฟล์ CSR: $(basename "$CSR_PATH")${NC}"
else
  echo -e "${GREEN}📄 เลือก CSR ที่ต้องการ:${NC}"
  select csr in "${CSR_FILES[@]}"; do
    CSR_PATH="$csr"
    break
  done
fi

BASENAME=$(basename "$CSR_PATH" .csr)
CERT_PATH="$OUTPUT_DIR/${BASENAME}.crt"
CA_CERT="$OUTPUT_DIR/rootCA.crt"
CA_KEY="$OUTPUT_DIR/rootCA.key"
EXT_FILE="ssl_ext.cnf"

# 2. ตรวจสอบไฟล์
for f in "$CSR_PATH" "$CA_CERT" "$CA_KEY" "$EXT_FILE"; do
  if [ ! -f "$f" ]; then
    echo -e "${GREEN}❌ ไม่พบไฟล์: $f${NC}"
    exit 1
  fi
done

# 3. Loading effect
spinner() {
  local pid=$!
  local delay=0.1
  local spinstr='|/-\'
  while ps -p $pid &>/dev/null; do
    local temp=${spinstr#?}
    printf " [%c]  " "$spinstr"
    local spinstr=$temp${spinstr%"$temp"}
    sleep $delay
    printf "\b\b\b\b\b\b"
  done
  printf "    \b\b\b\b"
}

echo -en "${GREEN}🚀 ลงนาม CSR...${NC}"
(
  openssl x509 -req -in "$CSR_PATH" \
    -CA "$CA_CERT" -CAkey "$CA_KEY" -CAcreateserial \
    -out "$CERT_PATH" -days 365 -sha256 -extfile "$EXT_FILE"
) & spinner
echo -e "\n${GREEN}✅ ลงนามเรียบร้อยแล้ว${NC}"

# 4. ZIP
ZIP_FILE="$OUTPUT_DIR/${BASENAME}.zip"
zip -j "$ZIP_FILE" "$CERT_PATH" "$CSR_PATH" "$CA_CERT"  >/dev/null

# 5. เสียง beep
echo -en "\a"

# 6. สรุป
echo -e "${GREEN}📦 ZIP พร้อมส่ง: $ZIP_FILE${NC}"
echo -e "${GREEN}📂 พาธ: $(realpath "$ZIP_FILE")${NC}"

# 7. เสนอคำสั่ง copy
echo -e "${GREEN}📋 คัดลอกไฟล์ด้วยคำสั่งนี้:${NC}"
echo -e "cp \"$ZIP_FILE\" ~/Downloads/"

echo ""