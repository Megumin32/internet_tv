## データベースの学習（仮想のインターネットTVが題材）
### はじめに
### 環境構築
### テーブル設計
``` uml
entity ユーザ {
  +ユーザid : INT [PK]
  --
  名前 : VARCHAR(100)
  アドレス : VARCHAR(100)
}

entity チャンネル {
  +チャンネルid : INT [PK]
  --
  チャンネル名 : VARCHAR(100)

}
entity 番組 {
  +番組id : INT [PK]
  --
  番組名 : VARCHAR(100)
  時間 : INT
  シーズン : VARCHAR(100)
  エピソード : VARCHAR(100)
  エピソードタイトル : VARCHAR(100)
  エピソード詳細 : VARCHAR(100)
  ジャンルid : [FK]
}
entity ジャンル {
  +ジャンルid : INT [PK]
  --
  ジャンル名 : DATE
}

entity 番組枠 {
  +番組枠id : INT [PK]
  --
  チャンネルid : INT[FK]
  番組id : INT[FK]
  開始時刻
  終了時刻
}
entity 視聴履歴 {
  +履歴id : INT [PK]
  --
  番組枠id : INT[FK]
  ユーザid : INT[FK]
}

チャンネル ||-r-o{ 番組枠
番組 ||-u-o{ 番組枠
番組 }o-d-|| ジャンル
ユーザ||-d-o{ 視聴履歴
番組枠||-u-o{ 視聴履歴
```

### データベース構築
1. データベースの作成
``` sql
CREATE DATABASE internet_tv;
USE internet_tv;
```
2. テーブルの作成
``` SQL
source create_table.sql
```
3. データの挿入
``` SQL
source [ファイル名（パス名）]
```
- sample_channels.sql
- sample_genres.sql
- sample_histories.sql
- sample_programs.sql
- sample_slots.sql
- sample_users.sql

### クエリの実行
- 視聴数トップ3のエピソードタイトルと視聴数を取得する．
``` SQL
SELECT 
    programs.program_name AS 番組名,
    programs.episode_title AS エピソードタイトル,
    COUNT(*) AS 視聴数
FROM 
    histories
INNER JOIN 
    slots ON histories.slot_id = slots.slot_id
INNER JOIN 
    programs ON slots.program_id = programs.program_id
GROUP BY 
    programs.program_name,
    programs.episode,
    programs.episode_title
HAVING 
    COUNT(*) > 1
ORDER BY 
    視聴数 DESC
LIMIT 3;
```
- 視聴数トップ3の番組タイトル，シーズン数，エピソード数，エピソードタイトル，視聴数を取得する．
``` SQL
SELECT 
    programs.program_name AS 番組名,
    programs.episode AS エピソード,
    programs.episode_title AS エピソードタイトル,
    COUNT(*) AS 視聴数

FROM 
    histories
INNER JOIN 
    slots ON histories.slot_id = slots.slot_id
INNER JOIN 
    programs ON slots.program_id = programs.program_id
GROUP BY 
    programs.program_name,
    programs.episode,
    programs.episode_title
HAVING 
    COUNT(*) > 1
ORDER BY 
    視聴数 DESC
LIMIT 3;  
```
- 本日放送される番組のチャンネル名，開始時刻，終了時刻，シーズン数，エピソード数，エピソードタイトル，エピソード詳細を取得する．
（「本日」の部分がうまく動かない場合は，コメントアウトしてある時刻に変更してください．）
``` SQL
SELECT 
    channels.channel_name AS チャンネル名,
    slots.start_time AS 開始時間,
    slots.end_time AS 終了時間,
    programs.season AS シーズン,
    programs.episode AS エピソード,
    programs.episode_title AS エピソードタイトル,
    programs.episode_detail AS 詳細
FROM 
    histories
INNER JOIN 
    slots ON histories.slot_id = slots.slot_id
INNER JOIN 
    programs ON slots.program_id = programs.program_id
INNER JOIN
    channels ON slots.channel_id = channels.channel_id
WHERE
    DATE(start_time) = CURRENT_DATE -- "2024-11-03" 
ORDER BY
    start_time;   
```
- チャンネル「ドラマ1」の本日から1週間分の番組表（開始時刻，終了時刻，シーズン数，エピソード数，エピソードタイトル，エピソード詳細）を取得する．
（「本日」の部分がうまく動かない場合は，コメントアウトしてある時刻に変更してください．）
``` SQL
SELECT 
    slots.start_time AS 開始時間,
    slots.end_time AS 終了時間,
    programs.season AS シーズン,
    programs.episode AS エピソード,
    programs.episode_title AS エピソードタイトル,
    programs.episode_detail AS 詳細 
FROM 
    slots
INNER JOIN 
    channels ON slots.channel_id = channels.channel_id
INNER JOIN 
    programs ON slots.program_id = programs.program_id
WHERE
    channels.channel_id = 7 &&
    start_time >= CURRENT_DATE && -- "2024-11-03" &&
    start_time < DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY) -- "2024-11-10"
ORDER BY
    start_time; 
```