#!/bin/bash

# ANSI สี
GREEN='\033[0;32m'
NC='\033[0m' # reset สี

# สร้างโฟลเดอร์สำหรับเก็บ output
OUTPUT_DIR="output"
mkdir -p "$OUTPUT_DIR"

# ขอชื่อไฟล์จากผู้ใช้ (มีค่า default)
read -p "กรุณาใส่ชื่อไฟล์สำหรับ RootCA Key (default: rootCA.key): " KEY_FILE
KEY_FILE=${KEY_FILE:-rootCA.key}

read -p "กรุณาใส่ชื่อไฟล์สำหรับ RootCA Certificate (default: rootCA.crt): " CERT_FILE
CERT_FILE=${CERT_FILE:-rootCA.crt}

# ขอรายละเอียด Subject จากผู้ใช้ (มี default)
read -p "Country (C) [default: TH]: " C
C=${C:-TH}

read -p "State/Province (ST) [default: Bangkok]: " ST
ST=${ST:-Bangkok}

read -p "Organization (O) [default: MyCompany]: " O
O=${O:-MyCompany}

read -p "Organizational Unit (OU) [default: IT Department]: " OU
OU=${OU:-IT Department}

read -p "Common Name (CN) [default: MyCompany Root CA]: " CN
CN=${CN:-MyCompany Root CA}

read -p "อายุ Root CA [default: 365 Days]: " DAY
DAY=${DAY:-365} 

# สร้าง Key
openssl genrsa -out "$OUTPUT_DIR/$KEY_FILE" 2048

# สร้าง Certificate
openssl req -x509 -new -nodes -key "$OUTPUT_DIR/$KEY_FILE" -sha256 -days "$DAY" -out "$OUTPUT_DIR/$CERT_FILE" \
-subj "/C=$C/ST=$ST/O=$O/OU=$OU/CN=$CN"

# สรุปผล
echo -e "\n${GREEN}✅ สร้าง Root CA เสร็จสิ้นแล้ว${NC}"
echo -e "${GREEN}🔐 Key         : ${OUTPUT_DIR}/${KEY_FILE}${NC}"
echo -e "${GREEN}📄 Certificate : ${OUTPUT_DIR}/${CERT_FILE}${NC}\n"