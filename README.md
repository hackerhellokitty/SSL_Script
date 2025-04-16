📄 README: TLS Certificate Script Helper
======================================

🧰 สคริปต์นี้ประกอบด้วยเครื่องมือในการสร้างและจัดการใบรับรอง (TLS/SSL Certificates) สำหรับใช้งานภายใน เช่น HTTPS หรือ VPN ในองค์กรของคุณ

📁 โฟลเดอร์ output/
--------------------
ไฟล์ที่สร้างขึ้นจากสคริปต์ทั้งหมดจะถูกเก็บไว้ในโฟลเดอร์นี้ เพื่อไม่ให้ไฟล์กระจายอยู่ทั่วระบบ

🔧 รายการสคริปต์
-------------------

1. **create_rootca.sh**
   - สร้าง Root Certificate Authority (RootCA)
   - สร้าง `rootCA.key` (Private Key) และ `rootCA.crt` (Certificate)
   - ข้อมูลเช่น Country, Organization สามารถกรอกผ่านหน้าจอได้

2. **gen_key_csr.sh**
   - สร้าง Private Key และ Certificate Signing Request (CSR)
   - เหมาะสำหรับโดเมนที่ต้องการให้ RootCA ลงนามให้
   - จะได้ไฟล์: `xxx.key`, `xxx.csr`

3. **sign_csr.sh**
   - เลือกไฟล์ `.csr` ที่อยู่ใน `output/`
   - ลงนามด้วย RootCA เพื่อออกใบรับรอง `.crt`
   - สร้าง `.zip` ที่รวมไฟล์ใช้งาน พร้อมเสียง beep 🎵 หลังสำเร็จ

💡 ข้อมูลใน zip:
------------------
`<ชื่อโดเมน>.zip` จะประกอบด้วย:
- `xxx.crt`  – ใบรับรองที่ถูกลงนามแล้ว
- `xxx.csr`  – ไฟล์ CSR ต้นฉบับ (ไว้ตรวจสอบ)
- `rootCA.crt` – ใบรับรองของ RootCA (สำหรับ client ที่ต้อง import เพื่อเชื่อถือ)

🚫 ไม่รวม:
- `rootCA.key` – สำคัญมาก ห้ามแจก!
- `.srl` – Serial number สำหรับ RootCA, ไม่จำเป็นต้องแจก

🔐 Security Note
------------------
กรุณาเก็บ `rootCA.key` ไว้ในที่ปลอดภัย **ห้ามแจก ห้ามแนบใน zip**
ผู้ที่ได้ไฟล์นี้สามารถออกใบรับรองปลอมได้ทันที!

🛠️ ข้อแนะนำเพิ่มเติม
------------------------
- สามารถเพิ่ม Extension ไฟล์สำหรับ SAN หรือ OID ได้ที่ `ssl_ext.cnf`
- หากลงนามหลายใบ อย่าลืมว่า serial number จะถูกอัปเดตในไฟล์ `.srl` โดยอัตโนมัติ

📦 คำสั่งที่ควรรู้:
---------------------
- ติดตั้ง rootCA.crt ลงใน browser หรือ OS:  
  → สำหรับ Windows: double click > Install  
  → สำหรับ Linux: copy ไปไว้ใน `/usr/local/share/ca-certificates/` แล้ว `update-ca-certificates`

✨ สนุกกับการสร้างระบบที่ปลอดภัย!
