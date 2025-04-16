#!/bin/bash

# ANSI สีเขียว
GREEN='\033[0;32m'
NC='\033[0m' # reset สี

while true; do
  clear

  # ดึงขนาดหน้าจอ
  ROWS=$(tput lines)
  COLS=$(tput cols)

  # ข้อความเมนู
  MENU=$(cat << EOF
==============================
      🔐 Certificate Tool      
==============================
1. สร้าง Root CA (create_root_ca.sh)
2. สร้าง CSR (gen_csr.sh)
3. แก้ไข SSL Extension (edit_ssl_ext.sh)
4. ลงนาม CSR (sign_csr.sh)
5. ออก (Exit)
------------------------------
เลือกเมนู (1-5): 
EOF
)

  # คำนวณบรรทัดเริ่มต้นเพื่อให้แสดงตรงกลางแนวตั้ง
  LINE_COUNT=$(echo "$MENU" | wc -l)
  START_ROW=$(( (ROWS - LINE_COUNT) / 2 ))

  # วาดเมนูตรงกลาง
  IFS=$'\n'
  row=$START_ROW
  for line in $MENU; do
    line_length=${#line}
    col=$(( (COLS - line_length) / 2 ))
    tput cup $row $col
    echo -e "${GREEN}${line}${NC}"
    ((row++))
  done
  unset IFS

  # อ่านคำตอบ (ตรงกลางบรรทัดล่าง)
  tput cup $((row)) $(( (COLS - 25) / 2 ))
  read -p "" choice

  case "$choice" in
    1)
      clear
      ./create_root_ca.sh
      read -p "กด Enter เพื่อกลับเมนูหลัก..." ;;
    2)
      clear
      ./gen_csr.sh
      read -p "กด Enter เพื่อกลับเมนูหลัก..." ;;
    3)
      clear
      ./edit_ssl_ext.sh
      read -p "กด Enter เพื่อกลับเมนูหลัก..." ;;
    4)
      clear
      ./sign_csr.sh
      read -p "กด Enter เพื่อกลับเมนูหลัก..." ;;
    5)
      echo -e "${GREEN}👋 ออกจากโปรแกรมแล้วครับ${NC}"
      exit 0 ;;
    *)
      echo -e "${GREEN}❌ กรุณาเลือก 1-5 เท่านั้น${NC}"
      read -p "กด Enter เพื่อเลือกใหม่..." ;;
  esac
done