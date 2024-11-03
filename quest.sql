-- エピソード視聴数トップ3のエピソードタイトルと視聴数を取得
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

-- エピソード視聴数トップ3の番組タイトル、シーズン数、エピソード数、エピソードタイトル、視聴数を取得
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

-- 本日放送される全ての番組に対して、チャンネル名、放送開始時刻(日付+時間)、放送終了時刻、
-- シーズン数、エピソード数、エピソードタイトル、エピソード詳細を取得
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
    start_time
LIMIT 100;   


-- アニメのチャンネルに対して、放送開始時刻、放送終了時刻、シーズン数、エピソード数、
-- エピソードタイトル、エピソード詳細を本日から一週間分取得

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