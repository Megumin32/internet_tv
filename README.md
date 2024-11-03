## データベースの学習（架空のインターネットTV）
### はじめに
データベースの学習のために，架空のインターネットTVを仮定してデータベース設計を行った．

### テーブル設計
- テーブル：users（ユーザ）

| カラム名 | データ型 | NULL | キー | 初期値 | AUTO INCREMENT|
|:-|:-|:-|:-|:-|:-|
| user_id | int| | PRIMARY | | YES |
| user_name | varchar(100)| | | | |
| mail_address | varchar(100) | | | | |

- テーブル：genres（ジャンル）

| カラム名 | データ型 | NULL | キー | 初期値 | AUTO INCREMENT|
|:-|:-|:-|:-|:-|:-|
| genre_id | int| | PRIMARY | | YES |
| genre_name | varchar(100)| | | | |

- テーブル：channel（チャンネル）

| カラム名 | データ型 | NULL | キー | 初期値 | AUTO INCREMENT|
|:-|:-|:-|:-|:-|:-|
| channel_id | int| | PRIMARY | | YES |
| channel_name | varchar(100)| | | | |

- テーブル：programs（番組）

| カラム名 | データ型 | NULL | キー | 初期値 | AUTO INCREMENT|
|:-|:-|:-|:-|:-|:-|
| program_id | int | | PRIMARY | | YES |
| genre_id | int | | FOREIGN | | |
| program_name | int | | | | |
| air_time | int | | | | |
| season | int | YES | | | |
| episode | int | YES | | | |
| episode_title | varchar(100) | | | | |
| episode_detail | varchar(100) | | | | |


- テーブル：slots（放送枠）

| カラム名 | データ型 | NULL | キー | 初期値 | AUTO INCREMENT|
|:-|:-|:-|:-|:-|:-|
| slot_id | int| | PRIMARY | | YES |
| channel_id | int | | FOREIGN | | |
| program_id | int | | FOREIGN | | |
| start_time | datetime | | | | |
| end_time | datetime | | | | |

- テーブル：histories（視聴履歴）

| カラム名 | データ型 | NULL | キー | 初期値 | AUTO INCREMENT|
|:-|:-|:-|:-|:-|:-|
| history_id | int| | PRIMARY | | YES |
| slot_id | int | | FOREIGN | | |
| user_id | int | | FOREIGN | | |

- ER図

![ER図](http://www.plantuml.com/plantuml/proxy?cache=no&src=https%3A%2F%2Fraw.githubusercontent.com%2FMegumin32%2Finternet_tv%2Fmain%2Fdiagrams%2Fer.puml)

### データベース構築
1. データベースの作成と切り替え
``` sql
CREATE DATABASE internet_tv;
USE internet_tv; 
```
2. テーブルの作成
`queries/create_table.sql`を読み込む．
``` SQL
source create_table.sql
```
3. データの挿入
以下の6つの`queries/〇〇.sql`を読み込む．
- sample_channels.sql
- sample_genres.sql
- sample_histories.sql
- sample_programs.sql
- sample_slots.sql
- sample_users.sql
``` SQL
source [ファイル名（パス名）]
```

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
    channels.channel_id = 7 && -- channel_id = 7 => 「ドラマ1」
    start_time >= CURRENT_DATE && -- "2024-11-03" &&
    start_time < DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY) -- "2024-11-10"
ORDER BY
    start_time; 
```