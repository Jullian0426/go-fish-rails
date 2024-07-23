SELECT
    users.id AS user_id,
    users.name AS user_name,
    COALESCE(wins_table.wins, 0) AS wins,
    COALESCE(losses_table.losses, 0) AS losses,
    COALESCE(wins_table.wins, 0) + COALESCE(losses_table.losses, 0) AS games_played,
    CASE
        WHEN COALESCE(wins_table.wins, 0) + COALESCE(losses_table.losses, 0) = 0 THEN 0
        ELSE ROUND(
            COALESCE(wins_table.wins, 0)::decimal /
            (COALESCE(wins_table.wins, 0) + COALESCE(losses_table.losses, 0)) * 100, 2
        )
    END AS win_rate,
    COALESCE(time_table.total_seconds, 0) AS seconds_played,
    COALESCE(score_table.total_score, 0) AS score
FROM users
LEFT JOIN (
    --wins
    SELECT users.id AS user_id, COUNT(game_users.winner) AS wins
    FROM users
    JOIN game_users on users.id = game_users.user_id
    WHERE game_users.winner = true
    GROUP BY users.id
) as wins_table
ON users.id = wins_table.user_id
LEFT JOIN (
    --losses
    SELECT users.id AS user_id, COUNT(game_users.winner) AS losses
    FROM users
    JOIN game_users on users.id = game_users.user_id
    WHERE game_users.winner = false
    GROUP BY users.id
) as losses_table
ON users.id = losses_table.user_id
LEFT JOIN (
    -- time played
    SELECT users.id AS user_id, SUM(EXTRACT(EPOCH FROM (games.finished_at - games.started_at))) AS total_seconds
    FROM users
    JOIN game_users on users.id = game_users.user_id
    JOIN games on game_users.game_id = games.id
    WHERE games.finished_at IS NOT NULL
    GROUP BY users.id
) as time_table
ON users.id = time_table.user_id
LEFT JOIN (
    -- score
    SELECT users.id AS user_id, SUM(game_users.score) AS total_score
    FROM users
    JOIN game_users on users.id = game_users.user_id
    GROUP BY users.id
) as score_table
ON users.id = score_table.user_id
ORDER BY score DESC, win_rate DESC;