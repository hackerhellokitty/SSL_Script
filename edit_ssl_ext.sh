#!/bin/bash

CONFIG_FILE="ssl_ext.cnf"

# ตรวจสอบว่าไฟล์ config มีอยู่หรือไม่
if [ ! -f "$CONFIG_FILE" ]; then
  echo "❌ ไม่พบไฟล์ $CONFIG_FILE"
  exit 1
fi

# เตรียมไฟล์ชั่วคราว
TMP_FILE=$(mktemp)
in_alt_names=false
skip_line=false

while IFS= read -r line; do
  if [[ "$line" =~ ^\[alt_names\] ]]; then
    in_alt_names=true
    skip_line=true
    echo "[alt_names]" >> "$TMP_FILE"
    continue
  fi

  if $in_alt_names; then
    if [[ "$line" =~ ^[[:space:]]*$ ]]; then
      continue  # ข้ามบรรทัดว่างระหว่าง alt_names
    fi
    if [[ "$line" =~ ^[^[:space:]] ]]; then
      in_alt_names=false
    else
      continue  # ข้าม DNS เดิมทั้งหมด
    fi
  fi

  # ถ้าไม่ต้องข้าม ให้เขียนบรรทัดเดิมกลับเข้าไป
  if ! $skip_line; then
    echo "$line" >> "$TMP_FILE"
  fi
  skip_line=false
done < "$CONFIG_FILE"

# เพิ่ม DNS ใหม่เข้าไป
echo ""
echo "=== 📝 เพิ่ม DNS ใน [alt_names] (ค่าเดิมจะถูกล้าง) ==="
dns_count=1
while true; do
  read -p "เพิ่ม DNS.${dns_count} (ปล่อยว่างถ้าไม่เพิ่ม): " dns
  if [ -z "$dns" ]; then
    break
  fi
  echo "DNS.${dns_count} = $dns" >> "$TMP_FILE"
  ((dns_count++))
done

# ถ้ายังไม่มี DNS ใหม่เลย ให้ลบบรรทัด [alt_names] ทิ้ง
if [ "$dns_count" -eq 1 ]; then
  sed -i '/\[alt_names\]/d' "$TMP_FILE"
fi

# แทนที่ไฟล์เดิม
mv "$TMP_FILE" "$CONFIG_FILE"

echo ""
echo "✅ อัปเดตเสร็จเรียบร้อย: $CONFIG_FILE"