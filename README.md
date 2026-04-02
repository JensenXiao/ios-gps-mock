# O.Paperclip

**ZH-TW:** macOS GPS 定位偽裝工具，透過 USB 或 Wi‑Fi 對 iPhone / iPad 注入模擬座標。  
**EN:** macOS app that spoofs GPS location on iPhone / iPad over USB or Wi‑Fi.

---

## 系統需求 / Requirements

| 項目 | 需求 |
|------|------|
| macOS | 13 Ventura 以上 |
| iPhone / iPad | iOS 16 以上，需開啟「開發者模式」 |
| 連線方式 | USB 或 Wi‑Fi（同一網路） |
| 其他 | 無需安裝 Python、Homebrew 或任何套件 |

---

## 安裝 / Installation

### 方法一：下載 DMG（推薦）

1. 前往 [Releases](../../releases) 頁面，下載最新的 `O.Paperclip.dmg`
2. 開啟 DMG，將 `O.Paperclip.app` 拖入 `Applications` 資料夾
3. 第一次開啟時，右鍵點選 App → 選「開啟」→ 確認開啟（繞過 Gatekeeper）

### 方法二：從原始碼建置

```bash
git clone https://github.com/YOUR_USERNAME/O.Paperclip.git
cd O.Paperclip
xcodebuild -project O.Paperclip.xcodeproj -scheme O.Paperclip -configuration Release build
```

---

## 使用前準備 / Before You Start

### iPhone / iPad 設定

1. **開啟開發者模式**（iOS 16+）  
   設定 → 隱私權與安全性 → 開發者模式 → 開啟 → 重新啟動

2. **信任這台 Mac**（USB 首次連線）  
   插上 USB 後，iPhone 會詢問「是否信任此電腦？」→ 點「信任」→ 輸入密碼

3. **Wi‑Fi 連線額外步驟**  
   先用 USB 完成一次信任配對，之後才能切換為 Wi‑Fi 模式

---

## 使用步驟 / How to Use

### 步驟一：連線裝置

**USB 連線（預設）：**
1. 用 USB 線連接 iPhone / iPad
2. 開啟 O.Paperclip
3. 側邊欄確認「USB 有線連線」已選取
4. 點「開始連線」
5. 若出現密碼提示，輸入 Mac 管理員密碼（建立 tunnel 需要）

**Wi‑Fi 無線連線：**
1. 確保 iPhone 與 Mac 在同一個 Wi‑Fi 網路
2. 開啟 O.Paperclip
3. 側邊欄切換為「Wi‑Fi 無線連線」
4. 點「開始連線」

> 連線成功後，側邊欄會顯示「已連線」及裝置名稱。

---

### 步驟二：選擇操作模式

側邊欄頂部的分段選擇器可切換三種模式：

| 模式 | 說明 |
|------|------|
| **A-B** | 在地圖上點選起點 A 和終點 B，App 自動規劃路線並沿路移動 |
| **定點** | 固定在地圖上點選的單一座標 |
| **多點** | 依序點選多個路徑點，App 依序移動 |

---

### 步驟三：設定位置

**A-B 路線模式：**
1. 點選地圖設定起點 A → 點「確認 A 點」
2. 點選地圖設定終點 B → 點「確認 B 點」
3. 選擇路線後點「開始移動」
4. 可調整速度（km/h）和是否循環

**定點模式：**
1. 點選地圖上的目標位置
2. 點「釘選此位置」
3. GPS 即固定在該點

**多點模式：**
1. 依序點選地圖上的路徑點
2. 點「開始移動」

> 也可在搜尋欄輸入地址或地名直接跳轉。

---

### 步驟四：停止模擬

點「停止」或「清除路線」即可停止 GPS 偽裝，裝置恢復真實位置。

---

## 進階設定 / Advanced Settings

展開側邊欄的「進階連線設定」可手動指定：

- **UDID**：有多台裝置時指定目標裝置
- **手動 RSD Host / Port**：自動連線失敗時，可用 `pymobiledevice3 remote start-tunnel` 取得後手動填入

---

## PurePoint 地圖圖層 / PurePoint Overlay

支援匯入 KML 格式的地理資料，在地圖上顯示自訂標記：

1. 側邊欄點「匯入 KML」
2. 選擇 `.kml` 檔案
3. 圖層會顯示在地圖上，可依分類篩選

---

## 常見問題 / Troubleshooting

**Q: 點「開始連線」後一直轉圈？**  
A: 確認 iPhone 已解鎖、USB 已信任此 Mac。若使用 Wi‑Fi，確認同一網路。

**Q: 出現「需要管理員密碼」提示？**  
A: 正常現象。建立 tunnel 需要短暫的 root 權限，輸入 Mac 密碼即可。

**Q: Wi‑Fi 連線失敗，自動切換為 USB？**  
A: App 會自動 fallback。若要強制 Wi‑Fi，確認裝置在同一網路且防火牆未封鎖。

**Q: 停止後 GPS 沒有恢復？**  
A: 點「清除定位點」或重新啟動 iPhone 的定位服務。

**Q: iOS 17 以上連線失敗？**  
A: 確認已開啟「開發者模式」，並在 Xcode 或 Finder 中信任過此裝置。

---

## 注意事項 / Disclaimer

本工具僅供開發測試、隱私保護等合法用途。請勿用於欺詐、遊戲作弊或任何違反服務條款的行為。使用者須自行承擔相關法律責任。

This tool is intended for legitimate use cases such as development testing and privacy protection. Do not use it for fraud, game cheating, or any activity that violates terms of service. Users are solely responsible for their actions.

---

## 授權 / License

MIT License — 詳見 [LICENSE](LICENSE)
