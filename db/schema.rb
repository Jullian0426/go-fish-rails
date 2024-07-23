# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_07_23_193156) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "game_users", force: :cascade do |t|
    t.bigint "game_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "winner"
    t.integer "score"
    t.index ["game_id", "user_id"], name: "index_game_users_on_game_id_and_user_id", unique: true
    t.index ["game_id"], name: "index_game_users_on_game_id"
    t.index ["user_id"], name: "index_game_users_on_user_id"
  end

  create_table "games", force: :cascade do |t|
    t.string "name", null: false
    t.integer "required_player_count", default: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "go_fish"
    t.datetime "started_at"
    t.datetime "finished_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "game_users", "games"
  add_foreign_key "game_users", "users"

  create_view "leaderboards", sql_definition: <<-SQL
      SELECT users.id AS user_id,
      users.name AS user_name,
      COALESCE(wins_table.wins, (0)::bigint) AS wins,
      COALESCE(losses_table.losses, (0)::bigint) AS losses,
      (COALESCE(wins_table.wins, (0)::bigint) + COALESCE(losses_table.losses, (0)::bigint)) AS games_played,
          CASE
              WHEN ((COALESCE(wins_table.wins, (0)::bigint) + COALESCE(losses_table.losses, (0)::bigint)) = 0) THEN (0)::numeric
              ELSE round((((COALESCE(wins_table.wins, (0)::bigint))::numeric / ((COALESCE(wins_table.wins, (0)::bigint) + COALESCE(losses_table.losses, (0)::bigint)))::numeric) * (100)::numeric), 2)
          END AS winning_percentage,
      COALESCE(time_table.total_seconds, (0)::numeric) AS seconds_played,
      COALESCE(points_table.total_points, (0)::bigint) AS points
     FROM ((((users
       LEFT JOIN ( SELECT users_1.id AS user_id,
              count(game_users.winner) AS wins
             FROM (users users_1
               JOIN game_users ON ((users_1.id = game_users.user_id)))
            WHERE (game_users.winner = true)
            GROUP BY users_1.id) wins_table ON ((users.id = wins_table.user_id)))
       LEFT JOIN ( SELECT users_1.id AS user_id,
              count(game_users.winner) AS losses
             FROM (users users_1
               JOIN game_users ON ((users_1.id = game_users.user_id)))
            WHERE (game_users.winner = false)
            GROUP BY users_1.id) losses_table ON ((users.id = losses_table.user_id)))
       LEFT JOIN ( SELECT users_1.id AS user_id,
              sum(EXTRACT(epoch FROM (games.finished_at - games.started_at))) AS total_seconds
             FROM ((users users_1
               JOIN game_users ON ((users_1.id = game_users.user_id)))
               JOIN games ON ((game_users.game_id = games.id)))
            WHERE (games.finished_at IS NOT NULL)
            GROUP BY users_1.id) time_table ON ((users.id = time_table.user_id)))
       LEFT JOIN ( SELECT users_1.id AS user_id,
              sum(game_users.score) AS total_points
             FROM (users users_1
               JOIN game_users ON ((users_1.id = game_users.user_id)))
            GROUP BY users_1.id) points_table ON ((users.id = points_table.user_id)))
    ORDER BY COALESCE(points_table.total_points, (0)::bigint) DESC,
          CASE
              WHEN ((COALESCE(wins_table.wins, (0)::bigint) + COALESCE(losses_table.losses, (0)::bigint)) = 0) THEN (0)::numeric
              ELSE round((((COALESCE(wins_table.wins, (0)::bigint))::numeric / ((COALESCE(wins_table.wins, (0)::bigint) + COALESCE(losses_table.losses, (0)::bigint)))::numeric) * (100)::numeric), 2)
          END DESC;
  SQL
end
