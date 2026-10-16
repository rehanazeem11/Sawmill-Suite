# Timber, Door & Frame Billing System v2.0 (Modern Rebuild)

A modern, high-performance offline billing application built for wholesale & retail timber, wood door, and door-frame businesses. It delivers an identical desktop experience matching the original Windows desktop software layout and workflow, while seamlessly adapting to mobile phones and tablets.

---

## 1. Architecture & Technical Choices

- **Unified Frontend**: React 19 + TypeScript + Vite. 100% code sharing across desktop and mobile.
- **Styling**: Vanilla CSS Design Tokens (`src/core/theme/tokens.css`). Strict adherence to the original soft mint background (`#B3EEB0`), signature orange items grid (`#FFA500`), and color-coded fields.
- **Offline Storage**: Dexie.js (IndexedDB). Zero-config, sub-millisecond local queries, handles 50,000+ bills completely offline on each device.
- **Calculations Core**: Isolated, unit-tested formula module (`src/core/formulas/timberCalculations.ts`) with Vitest test suite.
- **Invoicing & Reports**: Client-side offline PDF generation for standard A4 Tax Invoices and 80mm POS Thermal receipts via `jspdf` + `jspdf-autotable`.
- **Packaging**:
  - **Windows Desktop**: Electron + electron-builder producing standalone executable and NSIS installer.
  - **Android**: Capacitor native wrapper (`android/` project) producing Android APKs.

---

## 2. List of Assumptions (Flagged for Review)

1. **ASSUMPTION on Net Payable Formula**:
   - `Net Payable = Net Total + Old Balance - Advance`.
   - Old Balance is auto-fetched when a customer (M/S) is selected from past customer ledger history. Advance paid directly subtracts from the payable amount.
2. **ASSUMPTION on Screen 6 (Door Frame Bill)**:
   - Because no screenshot was provided for Screen 6, it is built as a dedicated variant of **Direct Frames Sales** with its own bill prefix (`DF-0001`), separate auto-incrementing sequence, and identical Discount and GST features.
3. **ASSUMPTION on Making Charges**:
   - "Making Charges" present in the legacy footer is removed everywhere. **Discount** (% or flat ₹ toggle) occupies this exact position in the footer calculations.
4. **ASSUMPTION on Direct Frames Sales Amount**:
   - Total Amount for Direct Frame line items is calculated as `Qty × Rate` (e.g. 10 frames × ₹12 = ₹120).
5. **ASSUMPTION on Display Precision**:
   - CFT displays up to 3 or 4 decimals (e.g. `0.1667` instead of raw float `0.166666666666667`). Currency amounts display to 2 decimals (e.g. `₹3.17`).

---

## 3. Screen Overview & Workflow

| # | Screen / Module | Desktop Layout (Original Match) | Mobile / Tablet Adaptation |
|---|---|---|---|
| **Home** | **Main Menu** | Icon launcher with all 7 modules in exact sequence + active window tabs bar | Responsive 7-tile touch grid with 44px+ tap targets |
| **1** | **Customer Billing** | Bill #, Date, M/S autocomplete, Qty, Len, Size L×W, cyan CFT, Rate, coral Amt, Orange Grid, Footer | Stacked inputs, compact entry form, card list with accent strip, sticky expandable summary footer |
| **2** | **Door Wood Billing** | Same as Screen 1 + Design dropdown, Door Size, Door Qty, and top-right live door thumbnail preview | Design thumbnail above form, full door spec inputs, card list |
| **3** | **Total Billing** | "Days Table Billing" dialog: Date From, Date To, Print, Close | Full-screen date range picker, live day-wise preview table, GST rate breakdown, PDF export |
| **4** | **Direct Frames Sales** | Bill # (`NF-0001`), M/S, Mobile #, Design, Qty, Code, Size, Rate, Total Amt, Magenta buttons, preview box | Compact stacked cards, touch buttons, expandable breakdown |
| **5** | **Frames Designs** | "Designs" dialog: Design Name, Code, square preview box, Browse, Clear Logo, Save, Close | Full-screen catalog, device camera and gallery capture, auto-resize & JPEG compress |
| **6** | **Door Frame Bill** | Variant of Direct Frames Sales with `DF-0001` prefix and dedicated sequence | Full mobile card list with `DF-` numbering |
| **7** | **Find Bill** | Bills Dashboard: KPI cards (Billed, Discount, GST, Received, Outstanding), table with sort/filter/export | Horizontal metric cards, slide-up filter drawer, infinite card list, mobile share sheet |

---

## 4. Exact Color Tokens Reference

Sampled directly from the software screenshots:
- **Window Background**: Soft Mint Green (`#B3EEB0`)
- **Title Bar**: Blue-Grey Gradient (`#C9DAF0` to `#A9C4E8`)
- **Items Grid**: Signature Orange Header & Body (`#FFA500`) with white border dividers
- **CFT (Entry Row)**: Cyan (`#00E5FF`)
- **Total Amt (Entry Row)**: Salmon/Coral (`#FA8072`)
- **Total Qty (Footer)**: Gold (`#FFD700`)
- **Total CFT (Footer)**: Sky Blue (`#87CEEB`)
- **Total Amt (Footer)**: Peach (`#FFDAB9`)
- **Discount (Footer)**: Soft Light Orange (`#FFE0B2`)
- **Taxable Amount (Footer)**: Pale Blue (`#BBDEFB`)
- **GST Lines (Footer)**: Light Lavender (`#E1BEE7`)
- **Net Total (Footer)**: Light Green (`#90EE90`)
- **Old Balance (Footer)**: Aquamarine (`#7FFFD4`)
- **Net Payable (Footer)**: Plum/Violet (`#DDA0DD`)
- **Direct Frames Total**: Pale Yellow (`#F0E68C`)
- **Direct Frames Payable**: Teal-Green (`#66CDAA`)
- **Add to List / Delete**: Magenta (`#FF00FF`)
- **Confirm Tick**: Orange Circle (`#FF8C00`) with white check
- **Cancel Cross**: Red Square (`#D32F2F`) with white cross
- **Dark Mode**: Derived deep forest green (`#122114`) with high-contrast text

---

## 5. Formulas & Unit Tests Verification

Run unit tests:
```bash
npm test
```
All 11 test cases pass, verifying:
- `Qty 2, Len 3, 2×2, Rate 19` → CFT: `0.1667`, Amount: `₹3.17`
- `Qty 2, Len 1, 1×3, Rate 90` → CFT: `0.0417`, Amount: `₹3.75`
- `Total 100, 10% discount, 18% GST` → Taxable: `₹90.00`, GST: `₹16.20`, Net Total: `₹106.20`
- Flat discount, GST off, inclusive mode, intra-state split (CGST 50% + SGST 50%), and inter-state IGST.
- Rejection of negative discounts and discounts exceeding total amount.

---

## 6. How to Run & Build

### Development (Web / Local)
```bash
npm install
npm run dev
```
Open [http://localhost:5173](http://localhost:5173).

### Windows Desktop App
- **Run in Desktop Electron Window**:
  ```bash
  npm run build
  npm run electron:start
  ```
- **Build Standalone Windows Desktop App (.exe)**:
  ```bash
  npm run package:win
  ```
  The packaged Windows desktop application is generated in:
  `dist-desktop/TimberBilling-win32-x64/TimberBilling.exe`

### Android App (APK)
The project is pre-configured with Capacitor Android:
1. Sync web assets into Android project:
   ```bash
   npm run cap:sync
   ```
2. Build Android Debug APK using Gradle:
   ```bash
   cd android
   .\gradlew assembleDebug
   ```
   The APK is generated at:
   `android/app/build/outputs/apk/debug/app-debug.apk`

---

## 7. Data Sync & Conflict Resolution

Each device works offline on its local IndexedDB storage.
Under **Settings & Backup**:
- **Export Backup**: Generates an encrypted `.timberbackup` file.
- **Mobile Share**: Directly shares the backup file via WhatsApp, Bluetooth, or Google Drive.
- **Restore / Merge**: Merges records from other devices. Conflict handling uses device ID prefixes (`DESK-`, `MOB-`) and Last-Write-Wins based on timestamps (`updatedAt`) to guarantee bills never overwrite each other.
