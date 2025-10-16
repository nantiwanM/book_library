# แอปพลิเคชันระบบจัดการหนังสือ
แอปพลิเคชันระบบจัดการหนังสือ Final Project ในรายวิชา Mobile Application Programming 68/1 พัฒนาด้วย Flutter และใช้ PocketBase เป็นฐานข้อมูล สามารถจัดการข้อมูลหนังสือได้ดังนี้ เพิ่ม แก้ไข ลบ (CRUD) พร้อมค้นหาข้อมูลและดูแดชบอร์ด

### ตัวอย่างหน้าจอ

<table align="center">
  <tr>
    <td><img src="https://github.com/user-attachments/assets/dfdca3c9-1748-46ae-aab7-a36173f7d01c" width="120"/></td>
    <td><img src="https://github.com/user-attachments/assets/c67db6ab-f90b-44d0-a4c0-6c82738af1dc" width="120"/></td>
    <td><img src="https://github.com/user-attachments/assets/830d7126-8132-4dfa-afb7-be56075c2437" width="120"/></td>
  </tr>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/370e8466-3295-4596-9e12-cd2510d2f6f0" width="120"/></td>
    <td><img src="https://github.com/user-attachments/assets/ba99195b-39a9-4c20-9309-38f74427f4e0" width="120"/></td>
    <td><img src="https://github.com/user-attachments/assets/5beef062-0e97-447c-b02a-32e2204a20c3" width="120"/></td>
  </tr>
</table>

### การติดตั้งและรันโปรเจกต์

#### 1. Clone โปรเจกต์
```bash
git clone https://github.com/nantiwanM/book_library.git
cd book_library
````

#### 2. start pocketbase 

```bash
./pocketbase serve
```
> **ข้อมูลเข้าสู่ระบบ**
>
> * Email: `admin@gmail.com`
> * Password: `admin123456789`

#### 3. ติดตั้ง Dependencies

```bash
flutter pub get
```

#### 4. รันแอป

* **บน Chrome (Web)**

```bash
flutter run -d chrome
```
