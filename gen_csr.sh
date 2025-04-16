#!/bin/bash

# ANSI สี
GREEN='\033[0;32m'
NC='\033[0m' # reset สี

echo -e "${GREEN}=== 🔐 Generate Private Key & CSR ===${NC}"

# โฟลเดอร์เก็บผลลัพธ์
OUTPUT_DIR="output"
mkdir -p "$OUTPUT_DIR"

# ขอชื่อไฟล์ Key และ CSR พร้อม default
read -p "ชื่อไฟล์สำหรับ Private Key [default: private.example.com.key]: " KEY_FILE
KEY_FILE=${KEY_FILE:-private.example.com.key}

read -p "ชื่อไฟล์สำหรับ CSR [default: private.example.com.csr]: " CSR_FILE
CSR_FILE=${CSR_FILE:-private.example.com.csr}

# ขอ Subject Detail
read -p "Country (C) [default: TH]: " C
C=${C:-TH}

read -p "State/Province (ST) [default: Bangkok]: " ST
ST=${ST:-Bangkok}

read -p "Locality (L) [default: Bangkok]: " L
L=${L:-Bangkok}

read -p "Organization (O) [default: MyCompany]: " O
O=${O:-MyCompany}

read -p "Organizational Unit (OU) [default: IT]: " OU
OU=${OU:-IT}

read -p "Common Name (CN - เช่น ชื่อโดเมน) [default: private.example.com]: " CN
CN=${CN:-private.example.com}

# สร้าง Private Key
echo -e "${GREEN}📦 กำลังสร้าง Private Key: $OUTPUT_DIR/$KEY_FILE${NC}"
openssl genrsa -out "$OUTPUT_DIR/$KEY_FILE" 2048

# สร้าง CSR
echo -e "${GREEN}📄 กำลังสร้าง CSR: $OUTPUT_DIR/$CSR_FILE${NC}"
openssl req -new -key "$OUTPUT_DIR/$KEY_FILE" -out "$OUTPUT_DIR/$CSR_FILE" \
-subj "/C=$C/ST=$ST/L=$L/O=$O/OU=$OU/CN=$CN"

# สรุปผล
echo ""
echo -e "${GREEN}✅ เสร็จเรียบร้อย!${NC}"
echo -e "${GREEN}🔐 Private Key: ${OUTPUT_DIR}/${KEY_FILE}${NC}"
echo -e "${GREEN}📄 CSR        : ${OUTPUT_DIR}/${CSR_FILE}${NC}\n"